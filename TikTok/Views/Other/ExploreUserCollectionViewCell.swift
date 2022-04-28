//
//  ExploreUserCollectionViewCell.swift
//  TikTok
//
//  Created by Ivan Potapenko on 26.04.2022.
//

import UIKit

class ExploreUserCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExploreUserCollectionViewCell"
    
    private let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(profilePicture)
        contentView.addSubview(userNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 55
        profilePicture.frame = CGRect(
            x: (contentView.width - imageSize)/2,
            y: 0,
            width: imageSize,
            height: imageSize
        )
        profilePicture.layer.cornerRadius = profilePicture.height/2
        userNameLabel.frame = CGRect(
            x: 0, y: profilePicture.bottom,
            width: contentView.width,
            height: 55
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = nil
        profilePicture.image = nil
    }
    
    func configure(with viewModel: ExploreUserViewModel) {
        userNameLabel.text = viewModel.username
        
        profilePicture.image = viewModel.profilePicture
        
    }
}
