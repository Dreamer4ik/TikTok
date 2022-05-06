//
//  PostViewController.swift
//  TikTok
//
//  Created by Ivan Potapenko on 20.04.2022.
//

import UIKit
import AVFoundation

protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel)
    func didTapFollowButton(_ vc: PostViewController, didTapFollowButtonFor post: PostModel, button: UIButton)
}

class PostViewController: UIViewController {
    
    weak var delegate: PostViewControllerDelegate?
    
    var model: PostModel
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.right.fill"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "add"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Check out this video! #awesome #chill #life #tiktok #232 Check out this video! #awesome #chill #life #tiktok"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    var player: AVPlayer?
    
    private var playerDidFinishObserver: NSObjectProtocol?
    
    private let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }()
    
    // MARK: -Init
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(videoView)
        videoView.addSubview(spinner)
        configureVideo()
        view.backgroundColor = .black
        
        
        setUpButtons()
        setUpDoubleTapToLike()
        view.addSubview(captionLabel)
        view.addSubview(profileButton)
        view.addSubview(followButton)
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = videoView.center
    
        let size:CGFloat = 40
        let yStart: CGFloat = view.height - (size*4) - 30 - view.safeAreaInsets.bottom
        for (index, button)  in [likeButton,commentButton,shareButton].enumerated() {
            button.frame = CGRect(
                x: view.width-size-10,
                y: yStart + (CGFloat(index) * 10) + (CGFloat(index) * size),
                width: size,
                height: size
            )
        }
        
        captionLabel.sizeToFit()
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 12, height: view.height))
        captionLabel.frame = CGRect(
            x: 5,
            y: view.height - 10 - view.safeAreaInsets.bottom - labelSize.height,
            width: view.width - size - 12,
            height: labelSize.height
        )
        profileButton.frame = CGRect(
            x: 0,
            y: likeButton.top - size*2,
            width: size + 12,
            height: size + 12
        )
        profileButton.center.x = likeButton.center.x
        profileButton.layer.cornerRadius = (size + 12)/2
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = UIColor.white.cgColor
        
        followButton.frame = CGRect(
            x: 0,
            y: profileButton.bottom - 15,
            width: 25,
            height: 25
        )
        followButton.center.x = profileButton.center.x
    }
    
    private func configureVideo() {

        StorageManager.shared.getDownloadURL(for: model) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.spinner.stopAnimating()
                strongSelf.spinner.removeFromSuperview()
                switch result {
                case .success(let url):
                    strongSelf.player = AVPlayer(url: url)
                    
                    let playerLayer = AVPlayerLayer(player: self?.player)
                    playerLayer.frame = strongSelf.view.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    strongSelf.videoView.layer.addSublayer(playerLayer)
                    
                    strongSelf.player?.volume = 1.0
                    strongSelf.player?.play()
                case .failure(_):
                    guard let path = Bundle.main.path(forResource: "video", ofType: "mp4") else {
                        return
                    }
                    let url = URL(fileURLWithPath: path)
                    strongSelf.player = AVPlayer(url: url)
                    
                    let playerLayer = AVPlayerLayer(player: strongSelf.player)
                    playerLayer.frame = strongSelf.view.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    strongSelf.videoView.layer.addSublayer(playerLayer)
                    strongSelf.player?.volume = 1.0
                    strongSelf.player?.play()
                }
            }
        }
        
        guard let player = player else {
            return
        }

        
        playerDidFinishObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main,
            using: { _ in
                player.seek(to: .zero)
                player.play()
            })
    }
    
    @objc private func didTapProfileButton() {
        delegate?.postViewController(self, didTapProfileButtonFor: model)
    }
    
    @objc private func didTapFollowButton() {
        delegate?.didTapFollowButton(self, didTapFollowButtonFor: model, button: followButton)
    }
    
    func setUpButtons() {
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
    
    @objc private func didTapLike() {
        model.isLikedByCurrentUser = !model.isLikedByCurrentUser
        
        likeButton.tintColor = model.isLikedByCurrentUser ? .systemRed : .white
    }
    
    @objc private func didTapComment() {
        delegate?.postViewController(self, didTapCommentButtonFor: model)
    }
    
    @objc private func didTapShare() {
        guard let url = URL(string: "https://www.tiktok.com") else {
            return
        }
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        
        present(vc, animated: true)
    }
    
    func setUpDoubleTapToLike() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if !model.isLikedByCurrentUser {
            //            model.isLikedByCurrentUser = true
            didTapLike()
        }
        
        let touchPoint = gesture.location(in: view)
        
        let imageView  = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .systemRed
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = touchPoint
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 1
        } completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    UIView.animate(withDuration: 0.4) {
                        let size = self.view.frame.size.width * 1
                        imageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
                        imageView.center = touchPoint
                        
                        imageView.alpha = 0
                    } completion: { done in
                        imageView.removeFromSuperview()
                    }
                }
            }
        }
    }
}
