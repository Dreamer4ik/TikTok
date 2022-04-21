//
//  PostViewController.swift
//  TikTok
//
//  Created by Ivan Potapenko on 20.04.2022.
//

import UIKit

class PostViewController: UIViewController {
    
    let model: PostModel
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors: [UIColor] = [
            .systemRed,
            .systemGreen,
            .systemPink,
            .systemTeal,
            .systemPurple,
            .systemGray,
            .systemBlue,
            .systemBrown,
            .systemYellow,
            .systemOrange,
            .white
        ]
        
        view.backgroundColor = colors.randomElement()
        
    }
    
}
