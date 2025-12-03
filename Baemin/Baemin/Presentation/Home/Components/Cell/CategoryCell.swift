//
//  BaeminCategoryCell.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

import SnapKit
import Then

final class CategoryCell: UICollectionViewCell {

    // MARK: - ID
    
    static let reuseID = "BaeminCategoryCell"

    // MARK: - UI
    
    private let thumbView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup
    
    private func setupUI() {
        contentView.addSubview(thumbView)
        contentView.addSubview(titleLabel)

        thumbView.do {
            $0.backgroundColor = UIColor.baeminBackgroundWhite
            $0.layer.masksToBounds = true
        }

        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        thumbView.addSubview(imageView)

        titleLabel.do {
            $0.textAlignment = .center
            $0.textColor = .baeminBlack
            $0.font = .body_r_14
            $0.numberOfLines = 1
        }

        thumbView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(58)
        }
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbView.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualTo(58)
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbView.layer.cornerRadius = 20
    }

    // MARK: - Configure
    
    func configure(title: String, image: UIImage? = nil) {
        titleLabel.attributedText = Self.makeTitle(title)
        imageView.image = image
    }

    // MARK: - Helpers
    
    private static func makeTitle(_ text: String) -> NSAttributedString {
        let p = NSMutableParagraphStyle()
        p.lineHeightMultiple = 0.84
        return NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.body_r_14,
                .foregroundColor: UIColor.baeminBlack
            ]
        )
    }
}
