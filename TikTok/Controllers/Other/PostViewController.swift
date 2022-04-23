//
//  PostViewController.swift
//  TikTok
//
//  Created by Ivan Potapenko on 20.04.2022.
//

import UIKit

protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
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
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Check out this video! #awesome #chill #life #tiktok #232 Check out this video! #awesome #chill #life #tiktok"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    // MARK: -init
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors: [UIColor] = [
            .systemRed,
            .systemGreen,
            .systemPink,
            .systemTeal,
            .systemPurple,
            .systemGray,
            .systemBlue,
            .systemBrown,
            .systemYellow,
            .systemOrange,
        ]
        
        view.backgroundColor = colors.randomElement()
        
        
        setUpButtons()
        setUpDoubleTapToLike()
        view.addSubview(captionLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size:CGFloat = 40
        let yStart: CGFloat = view.height - (size*4) - 30 - view.safeAreaInsets.bottom - (tabBarController?.tabBar.height ?? 0)
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
            y: view.height - 10 - view.safeAreaInsets.bottom - labelSize.height - (tabBarController?.tabBar.height ?? 0),
            width: view.width - size - 12,
            height: labelSize.height
        )
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
