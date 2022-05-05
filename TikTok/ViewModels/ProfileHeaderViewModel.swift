//
//  ProfileHeaderViewModel.swift
//  TikTok
//
//  Created by Ivan Potapenko on 05.05.2022.
//

import Foundation

struct ProfileHeaderViewModel {
    let avatarImageURL: URL?
    let followerCount: Int
    let followingCount: Int
    let isFollowing: Bool?
}
