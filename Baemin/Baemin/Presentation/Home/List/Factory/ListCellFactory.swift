//
//  ListCellFactory.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

enum ListCellFactory {

    static func makeCell(for section: ListSection,
                         at indexPath: IndexPath,
                         in collectionView: UICollectionView) -> UICollectionViewCell {

        switch section {
        case .ranking(let items):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "RankingCell",
                for: indexPath
            ) as! RankingCell
            cell.configure(with: items[indexPath.item])
            return cell

        case .recent(let items):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "RecentCell",
                for: indexPath
            ) as! RecentCell
            cell.configure(with: items[indexPath.item])
            return cell
            
        case .discounted(let items):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DiscountCell",
                for: indexPath
            ) as! DiscountCell
            cell.configure(with: items[indexPath.item])
            return cell
        }
    }
}
