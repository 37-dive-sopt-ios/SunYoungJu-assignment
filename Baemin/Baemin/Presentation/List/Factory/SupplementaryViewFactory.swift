//
//  SupplementaryViewFactory.swift
//  Baemin
//
//  Created by sun on 11/14/25.
//

import UIKit

enum SupplementaryViewFactory {

    static func make(kind: String,
                     at indexPath: IndexPath,
                     in collectionView: UICollectionView,
                     sections: [ListSection]) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as! SectionHeaderView

            let section = sections[indexPath.section]

            header.configure(
                title: section.title,
                subtitle: section.subtitle,
                style: section.headerStyle
            )
            return header
        }

        if kind == "SeparatorView" {
            let sep = collectionView.dequeueReusableSupplementaryView(
                ofKind: "SeparatorView",
                withReuseIdentifier: "SeparatorView",
                for: indexPath
            )
            sep.backgroundColor = .baeminBackgroundWhite
            return sep
        }

        return UICollectionReusableView()
    }
}
