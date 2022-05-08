//
//  ExplorePostCollectionViewCell.swift
//  TikTok
//
//  Created by Ivan Potapenko on 26.04.2022.
//

import UIKit

class ExplorePostCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExplorePostCollectionViewCell"

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(captionLabel)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let captionHeight = contentView.height/5
        thumbnailImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: contentView.width,
            height: contentView.height - captionHeight
        )
        captionLabel.frame = CGRect(
            x: 0,
            y: contentView.height - captionHeight,
            width: contentView.width,
            height: captionHeight
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        captionLabel.text = nil
    }

    func configure(with viewModel: ExplorePostViewModel) {
        captionLabel.text = viewModel.caption
        thumbnailImageView.image = viewModel.thumbnailImage
    }
}
