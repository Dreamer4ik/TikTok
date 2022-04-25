//
//  ExploreBannerViewModel.swift
//  TikTok
//
//  Created by Ivan Potapenko on 25.04.2022.
//

import UIKit

struct ExploreBannerViewModel {
    let image: UIImage?
    let title: String
    let handler: (() -> Void)
}
