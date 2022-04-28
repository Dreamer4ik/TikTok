//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by Ivan Potapenko on 25.04.2022.
//

import UIKit

struct ExploreUserViewModel {
    let profilePicture: UIImage?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}
