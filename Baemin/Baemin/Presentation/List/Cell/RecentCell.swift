//
//  RecentCell.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

import SnapKit
import Then

final class RecentCell: UICollectionViewCell {

    private let thumbnailContainer = UIView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.baeminGray200.cgColor
    }

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let recentIcon = UIImageView().then {
        $0.image = UIImage(named: "time")
        $0.contentMode = .scaleAspectFit
    }

    private let recentLabel = UILabel().then {
        $0.font = .body_r_12
        $0.textColor = .baeminBlue
        $0.text = "최근 1번 주문한 가게"
    }

    private let titleLabel = UILabel().then {
        $0.font = .head_b_14
        $0.textColor = .baeminBlack
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }

    private let starImageView = UIImageView().then {
        $0.image = UIImage(named: "star")
        $0.contentMode = .scaleAspectFit
    }

    private let ratingLabel = UILabel().then {
        $0.font = .body_r_12
        $0.textColor = .baeminBlack
    }

    private let timeIcon = UIImageView().then {
        $0.image = UIImage(named: "money")
        $0.contentMode = .scaleAspectFit
    }

    private let etaLabel = UILabel().then {
        $0.font = .body_r_12
        $0.textColor = .baeminBlack
    }

    private let freeIcon = UIImageView().then {
        $0.image = UIImage(named: "bamin_club")
        $0.contentMode = .scaleAspectFit
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }

    private let freeDeliveryLabel = UILabel().then {
        $0.font = .head_b_14
        $0.textColor = .baeminPurple
        $0.text = "무료배달"
    }

    private let clubChip = ChipView(
        icon: UIImage(named: "bamin_club"),
        text: "배민클럽",
        textColor: .baeminMint600,
        borderColor: .baeminMint600,
        backgroundColor : UIColor.baeminMint300.withAlphaComponent(0.2)
    )

    private let pickupChip = ChipView(
        icon: nil,
        text: "픽업가능",
        textColor: .baeminGray700,
        borderColor: .clear,
        backgroundColor: .baeminBackgroundWhite
    )

    private let container = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .leading
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }

    private func configureUI() {
        contentView.backgroundColor = .baeminWhite
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = false

        contentView.addSubview(thumbnailContainer)
        thumbnailContainer.addSubview(thumbnailImageView)

        thumbnailContainer.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(188)
            $0.height.equalTo(126)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let recentRow = UIStackView(arrangedSubviews: [recentIcon, recentLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
        recentIcon.snp.makeConstraints { $0.size.equalTo(CGSize(width: 14, height: 14)) }

        let titleRight = UIStackView(arrangedSubviews: [starImageView, ratingLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 1
            $0.alignment = .center
        }
        starImageView.snp.makeConstraints { $0.size.equalTo(CGSize(width: 14, height: 14)) }

        let titleRow = UIStackView(arrangedSubviews: [titleLabel, UIView(), titleRight]).then {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .center
        }

        let leftEta = UIStackView(arrangedSubviews: [timeIcon, etaLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .center
        }
        timeIcon.snp.makeConstraints { $0.size.equalTo(CGSize(width: 16, height: 16)) }

        let freeRow = UIStackView(arrangedSubviews: [freeIcon, freeDeliveryLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .center
        }
        freeIcon.snp.makeConstraints { $0.size.equalTo(CGSize(width: 16, height: 16)) }

        let etaRow = UIStackView(arrangedSubviews: [leftEta, UIView(), freeRow]).then {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .center
        }

        let chipRow = UIStackView(arrangedSubviews: [clubChip, pickupChip]).then {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }

        [recentRow, titleRow, etaRow, chipRow].forEach { container.addArrangedSubview($0) }
        contentView.addSubview(container)

        container.snp.makeConstraints {
            $0.top.equalTo(thumbnailContainer.snp.bottom).offset(12)
            $0.leading.equalTo(thumbnailContainer.snp.leading)
            $0.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }

    func configure(with model: RecentModel) {
        thumbnailImageView.image = UIImage(named: model.thumbnailName)
        recentLabel.text = model.recentOrderText ?? "최근 주문한 가게"
        titleLabel.text = model.name
        ratingLabel.text = String(format: "%.1f", model.rating)
        etaLabel.text = model.deliveryTimeText

        let isFree = (model.deliveryFeeText == "무료배달")
        freeIcon.isHidden = !isFree
        freeDeliveryLabel.isHidden = !isFree
        freeDeliveryLabel.text = model.deliveryFeeText

        clubChip.isHidden = !model.tags.contains("배민클럽")
        pickupChip.isHidden = !model.tags.contains("픽업가능")
    }
}
