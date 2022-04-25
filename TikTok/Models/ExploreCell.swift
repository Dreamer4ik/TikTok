//
//  ExploreCell.swift
//  TikTok
//
//  Created by Ivan Potapenko on 25.04.2022.
//

import Foundation

enum ExploreCell {
    case banner(viewModel: ExploreBannerViewModel)
    case post(viewModel: ExplorePostViewModel)
    case hashtag(viewModel: ExploreHashtagViewModel)
    case user(viewModel: ExploreUserViewModel)
}
