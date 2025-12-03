//
//  SectionHeaderView..swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

import SnapKit
import Then

enum SectionHeaderStyle {
    case ranking
    case recent
    case discounted
}

final class SectionHeaderView: UICollectionReusableView {

    static let reuseIdentifier = "SectionHeaderView"

    private let titleLabel = UILabel().then {
        $0.font = .head_b_18
        $0.textColor = .baeminBlack
    }

    private let subtitleLabel = UILabel().then {
        $0.font = .body_r_14
        $0.textColor = .baeminGray600
        $0.isHidden = true
    }

    private let infoImageView = UIImageView().then {
        $0.image = UIImage(named: "info")?.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
    }

    private let moreLabel = UILabel().then {
        $0.text = "전체보기"
        $0.font = .body_r_12
        $0.textColor = .baeminBlack
    }

    private let chevronImageView = UIImageView().then {
        $0.image = UIImage(named: "chevron-right")?.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
    }

    private let discountImageView = UIImageView().then {
        $0.image = UIImage(named: "discount")
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }

    private lazy var titleRowStack = UIStackView(arrangedSubviews: [titleLabel, infoImageView]).then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }

    private lazy var textStack = UIStackView(arrangedSubviews: [titleRowStack, subtitleLabel]).then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }

    private lazy var moreStack = UIStackView(arrangedSubviews: [moreLabel, chevronImageView]).then {
        $0.axis = .horizontal
        $0.spacing = 2
        $0.alignment = .center
    }

    private lazy var rightStack = UIStackView(arrangedSubviews: [moreStack, discountImageView]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }

    private lazy var rootStack = UIStackView(arrangedSubviews: [textStack, UIView(), rightStack]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(rootStack)

        infoImageView.snp.makeConstraints { $0.size.equalTo(CGSize(width: 16, height: 16)) }
        chevronImageView.snp.makeConstraints { $0.size.equalTo(CGSize(width: 10, height: 10)) }
        discountImageView.snp.makeConstraints { $0.size.equalTo(CGSize(width: 66, height: 59)) }

        rootStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(title: String, subtitle: String?, style: SectionHeaderStyle) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = (subtitle == nil)

        switch style {
        case .ranking:
            titleLabel.textColor = .baeminWhite
            subtitleLabel.textColor = .baeminWhite
            moreLabel.textColor = .baeminWhite
            infoImageView.tintColor = .baeminWhite
            chevronImageView.tintColor = .baeminWhite

            moreStack.isHidden = false
            discountImageView.isHidden = true

        case .recent:
            titleLabel.textColor = .baeminBlack
            subtitleLabel.textColor = .baeminGray600
            moreLabel.textColor = .baeminBlack
            infoImageView.tintColor = .baeminBlack
            chevronImageView.tintColor = .baeminBlack

            moreStack.isHidden = false
            discountImageView.isHidden = true

        case .discounted:
            titleLabel.textColor = .baeminBlack
            subtitleLabel.textColor = .baeminGray600
            infoImageView.tintColor = .baeminBlack

            moreStack.isHidden = true
            discountImageView.isHidden = false
        }
    }
}
