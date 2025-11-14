//
//  RankingCell.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

import SnapKit
import Then

final class RankingCell: UICollectionViewCell {
    
    private let gradientLayer = CAGradientLayer()

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.baeminGray200.cgColor
    }

    private let brandLabel = UILabel().then {
        $0.font = .body_r_12
        $0.textColor = .baeminGray600
    }

    private let starImageView = UIImageView().then {
        $0.image = UIImage(named: "star")
        $0.contentMode = .scaleAspectFit
    }

    private let ratingLabel = UILabel().then {
        $0.font = .body_r_12
        $0.textColor = .baeminGray600
    }

    private let titleLabel = UILabel().then {
        $0.font = .title_sb_14
        $0.textColor = .baeminBlack
        $0.numberOfLines = 2
    }

    private let discountPercentLabel = UILabel().then {
        $0.font = .head_b_14
        $0.textColor = .baeminRed
    }

    private let priceLabel = UILabel().then {
        $0.font = .head_b_14
        $0.textColor = .baeminBlack
    }

    private let originalPriceLabel = UILabel().then {
        $0.font = .body_r_12
        $0.textColor = .baeminGray300
    }

    private let minOrderLabel = UILabel().then {
        $0.font = .head_b_14
        $0.textColor = .baeminPurple
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupGradient()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        gradientLayer.frame = contentView.bounds
    }

    // MARK: - Layout

    private func setup() {

        contentView.addSubview(thumbnailImageView)

        let ratingRow = UIStackView(arrangedSubviews: [starImageView, ratingLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .center
        }

        let brandRow = UIStackView(arrangedSubviews: [brandLabel, ratingRow]).then {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }

        let priceRow = UIStackView(arrangedSubviews: [discountPercentLabel, priceLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.alignment = .center
        }

        let priceBlock = UIStackView(arrangedSubviews: [priceRow, originalPriceLabel]).then {
            $0.axis = .vertical
            $0.spacing = 2
            $0.alignment = .leading
        }

        let infoStack = UIStackView(
            arrangedSubviews: [brandRow, titleLabel, priceBlock, minOrderLabel]
        ).then {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .leading
        }

        contentView.addSubview(infoStack)

        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(145)
        }

        infoStack.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }

    // MARK: - Configure

    func configure(with model: RankingModel) {
        thumbnailImageView.image = UIImage(named: model.thumbnailName)
        brandLabel.text = model.brandName
        ratingLabel.text = "\(model.rating) (\(model.reviewCount))"
        titleLabel.text = model.title

        if let percent = model.discountPercent {
            discountPercentLabel.text = "\(percent)%"
            priceLabel.text = "\(formatPrice(model.price))원"
            originalPriceLabel.attributedText =
                model.originalPrice.map { "\(formatPrice($0))원".strikeThrough }
        } else {
            discountPercentLabel.text = nil
            priceLabel.text = "\(formatPrice(model.price))원"
            originalPriceLabel.attributedText = nil
        }

        minOrderLabel.text = model.minOrderText
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.baeminBackgroundPurple.withAlphaComponent(1.0).cgColor,
            UIColor.baeminBackgroundPurple.withAlphaComponent(0.05).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint   = CGPoint(x: 3, y: 3)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: - Helper

    private func formatPrice(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

// MARK: - Attributed Helper

private extension String {
    var strikeThrough: NSAttributedString {
        NSAttributedString(
            string: self,
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
    }
}
