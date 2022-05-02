//
//  CaptionViewController.swift
//  TikTok
//
//  Created by Ivan Potapenko on 01.05.2022.
//

import ProgressHUD
import UIKit

class CaptionViewController: UIViewController {
    
    let videoURL: URL
    
    private let captionTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        return textView
    }()
    
    // MARK: - Init
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
        view.addSubview(captionTextView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captionTextView.frame = CGRect(x: 5, y: view.safeAreaInsets.top+5, width: view.width-10, height: 150).integral
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captionTextView.becomeFirstResponder()
    }
    
    @objc private func didTapPost() {
        captionTextView.resignFirstResponder()
        let caption = captionTextView.text ?? ""
        // Generate a video name that is unique based on id
        let newVideoName = StorageManager.shared.generateVideoName()
        
        ProgressHUD.show("Posting...")
        
        // upload video
        StorageManager.shared.uploadVideoURL(from: videoURL, filename: newVideoName) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    // update database
                    DatabaseManager.shared.insertPost(filename: newVideoName, caption: caption) { dataBaseUpdated in
                        if dataBaseUpdated {
                            HapticsManager.shared.vibrateForType(for: .success)
                            ProgressHUD.dismiss()
                            // reset camera and switch to feed
                            self?.navigationController?.popToRootViewController(animated: true)
                            self?.tabBarController?.selectedIndex = 0
                            self?.tabBarController?.tabBar.isHidden = false
                        }
                        else {
                            HapticsManager.shared.vibrateForType(for: .error)
                            ProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Woops",
                                                          message: "We were unable to upload your video. Please try again.",
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                            self?.present(alert, animated: true)
                        }
                    }
                    
                }
                else {
                    HapticsManager.shared.vibrateForType(for: .error)
                    ProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Woops",
                                                  message: "We were unable to upload your video. Please try again.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
                
            }
        }
    }
    
}


