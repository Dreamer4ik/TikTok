//
//  EditProfileViewController.swift
//  TikTok
//
//  Created by Ivan Potapenko on 07.05.2022.
//

import UIKit

class EditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Profile"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapClose))
    }

    @objc private func didTapClose() {
        dismiss(animated: true)
    }

}
