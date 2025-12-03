//
//  BaeminMarketViewController.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

import SnapKit
import Then

final class BaeminMarketViewController: BaseViewController,
                                        UICollectionViewDataSource,
                                        UICollectionViewDelegateFlowLayout {

    // MARK: - Data

    private let items: [BaeminMarketCategory] = BaeminMarket.categories

    // MARK: - UI

    private let topDividerView = UIView()
    private let bottomDividerView = UIView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubviews(topDividerView, collectionView, bottomDividerView)

        topDividerView.do {
            $0.backgroundColor = .baeminBackgroundWhite
        }
        bottomDividerView.do {
            $0.backgroundColor = .baeminBackgroundWhite
        }

        topDividerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(10)
        }

        collectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseID)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topDividerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomDividerView.snp.top)
        }

        bottomDividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: - CollectionView DataSource

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCell.reuseID,
            for: indexPath
        ) as! CategoryCell

        let item = items[indexPath.item]
        cell.configure(title: item.title, image: item.image)
        return cell
    }

    // MARK: - CollectionView FlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 58, height: 58 + 6 + 18)
    }
}
