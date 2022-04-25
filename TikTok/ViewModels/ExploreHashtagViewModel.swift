//
//  ExploreHashtagViewModel.swift
//  TikTok
//
//  Created by Ivan Potapenko on 25.04.2022.
//

import UIKit

struct ExploreHashtagViewModel {
    let text: String
    let icon: UIImage?
    let count: Int // number of posts associated with tag
    let handler: (() -> Void)
}
