//
//  ListViewController.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

final class ListViewController: UIViewController {

    private let listView = ListView()
    private let factory = MockListSectionFactory()

    private var listData: [ListSection] = []

    override func loadView() { view = listView }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        listView.collectionView.dataSource = self
        listView.collectionView.delegate   = self
    }

    private func configureData() {
        listData = [
            .ranking(factory.makeRanking(4)),
            .recent(factory.makeRecent(4)),
            .discounted(factory.makeDiscounted(4))
        ]
    }
}

extension ListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { listData.count }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        listData[section].itemCount
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        ListCellFactory.makeCell(for: listData[indexPath.section],
                                 at: indexPath,
                                 in: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        SupplementaryViewFactory.make(kind: kind,
                                      at: indexPath,
                                      in: collectionView,
                                      sections: listData)
    }
}


extension ListViewController: UICollectionViewDelegate {}

#Preview {
    ListViewController()
}
