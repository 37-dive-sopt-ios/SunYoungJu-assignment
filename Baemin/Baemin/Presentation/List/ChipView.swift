//
//  ChipView.swift
//  Baemin
//
//  Created by sun on 11/14/25.
//

import UIKit

import SnapKit
import Then

final class ChipView: UIView {

    private let imageView = UIImageView()
    private let label = UILabel()

    init(icon: UIImage?, text: String, textColor: UIColor, borderColor: UIColor, backgroundColor: UIColor) {
        super.init(frame: .zero)

        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = borderColor.cgColor
        layer.backgroundColor = backgroundColor.cgColor

        imageView.image = icon
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = (icon == nil)
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 14, height: 14))
        }

        label.text = text
        label.font = .title_sb_10
        label.textColor = textColor

        let hStack = UIStackView(arrangedSubviews: [imageView, label]).then {
            $0.axis = .horizontal
            $0.spacing = icon == nil ? 0 : 2
            $0.alignment = .center
        }

        addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(4)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
