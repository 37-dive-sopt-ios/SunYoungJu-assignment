//
//  ListView.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

import SnapKit

final class ListView: UIView {

    // MARK: - UI
    
    let collectionView: UICollectionView

    private let gradientBackgroundView = UIView()
    private let gradientLayer = CAGradientLayer()

    // MARK: - Init
    
    override init(frame: CGRect) {
        let layout = ListSectionLayoutProvider.makeLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setup()
        setupGradient()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup
    
    private func setup() {
        
        backgroundColor = .baeminWhite

        addSubview(gradientBackgroundView)
        addSubview(collectionView)

        gradientBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(260)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }

        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true

        collectionView.register(RankingCell.self,
                                forCellWithReuseIdentifier: "RankingCell")
        collectionView.register(RecentCell.self,
                                forCellWithReuseIdentifier: "RecentCell")
        collectionView.register(DiscountCell.self,
                                forCellWithReuseIdentifier: "DiscountCell")

        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)

        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: "SeparatorView",
                                withReuseIdentifier: "SeparatorView")
    }

    // MARK: - Gradient
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.baeminBackgroundPurple.withAlphaComponent(1.0).cgColor,
            UIColor.baeminBackgroundPurple.withAlphaComponent(0.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.2)
        gradientLayer.endPoint   = CGPoint(x: 0, y: 0.5)
        gradientBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientBackgroundView.bounds
    }
}
