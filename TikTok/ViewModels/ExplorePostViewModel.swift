//
//  ExplorePostViewModel.swift
//  TikTok
//
//  Created by Ivan Potapenko on 25.04.2022.
//

import UIKit

struct ExplorePostViewModel {
    let thumbnailImage: UIImage?
    let caption: String
    let handler: (() -> Void)
}
