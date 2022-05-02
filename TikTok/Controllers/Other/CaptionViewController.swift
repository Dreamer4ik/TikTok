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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc private func didTapPost() {
        // Generate a video name that is unique based on id
        let newVideoName = StorageManager.shared.generateVideoName()
        
        ProgressHUD.show("Posting...")
        
        // upload video
        StorageManager.shared.uploadVideoURL(from: videoURL, filename: newVideoName) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    // update database
                    DatabaseManager.shared.insertPost(filename: newVideoName) { dataBaseUpdated in
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


