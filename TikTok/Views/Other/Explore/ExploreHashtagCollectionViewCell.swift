//
//  ExploreHashtagCollectionViewCell.swift
//  TikTok
//
//  Created by Ivan Potapenko on 26.04.2022.
//

import UIKit

class ExploreHashtagCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExploreHashtagCollectionViewCell"

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let hashtagLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        contentView.addSubview(hashtagLabel)
        contentView.backgroundColor = .secondarySystemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let iconSize: CGFloat = contentView.height/2

        iconImageView.frame = CGRect(
            x: 10,
            y: (contentView.height - iconSize)/2,
            width: iconSize,
            height: iconSize
        ).integral

        hashtagLabel.sizeToFit()
        hashtagLabel.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0,
            width: contentView.width - iconImageView.right - 10,
            height: contentView.height
        ).integral
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hashtagLabel.text = nil
        iconImageView.image = nil
    }

    func configure(with viewModel: ExploreHashtagViewModel) {
        hashtagLabel.text = viewModel.text
        iconImageView.image = viewModel.icon
    }
}
