//
//  HomeViewController.swift
//  Baemin
//
//  Created by sun on 11/16/25.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - UI
    
    private let homeView = HomeView()

    // MARK: - Data
    
    private let factory = MockListSectionFactory()
    private var listData: [ListSection] = []

    // MARK: - LifeCycle
    
    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        setupListView()
    }

    // MARK: - Setup
    
    private func setupListView() {
        homeView.listView.collectionView.dataSource = self
        homeView.listView.collectionView.delegate   = self
    }

    private func configureData() {
        listData = [
            .ranking(factory.makeRanking(4)),
            .recent(factory.makeRecent(4)),
            .discounted(factory.makeDiscounted(4))
        ]
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        listData.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        listData[section].itemCount
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        ListCellFactory.makeCell(
            for: listData[indexPath.section],
            at: indexPath,
            in: collectionView
        )
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        SupplementaryViewFactory.make(
            kind: kind,
            at: indexPath,
            in: collectionView,
            sections: listData
        )
    }
}

extension HomeViewController: UICollectionViewDelegate {}
