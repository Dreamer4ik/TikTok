//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by Ivan Potapenko on 25.04.2022.
//

import UIKit

struct ExploreUserViewModel {
    let profilePictureURL: URL?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}
