//
//  SwitchTableViewCell.swift
//  TikTok
//
//  Created by Ivan Potapenko on 07.05.2022.
//

import UIKit

protocol SwitchTableViewCellDelegate: AnyObject {
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateSwitchTo isOn: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    static let identifier = "SwitchTableViewCell"

    weak var delegate: SwitchTableViewCellDelegate?

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private let _switch: UISwitch = {
        let _switch = UISwitch()
        _switch.tintColor = .systemPink
        _switch.isOn = UserDefaults.standard.bool(forKey: "save_video")
        return _switch
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        selectionStyle = .none
        contentView.addSubview(label)
        contentView.addSubview(_switch)
        _switch.addTarget(self, action: #selector(didChangeSwitchValue(_:)), for: .valueChanged)
    }

    @objc private func didChangeSwitchValue(_ sender: UISwitch) {
        delegate?.switchTableViewCell(self, didUpdateSwitchTo: sender.isOn)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 10, y: 0, width: label.width, height: contentView.height)

        _switch.sizeToFit()
        _switch.frame = CGRect(x: contentView.width - _switch.width - 10, y: 6, width: _switch.width, height: _switch.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }

    func configure(with viewModel: SwitchCellViewModel) {
        label.text = viewModel.title
        _switch.isOn = viewModel.isOn
    }

}
