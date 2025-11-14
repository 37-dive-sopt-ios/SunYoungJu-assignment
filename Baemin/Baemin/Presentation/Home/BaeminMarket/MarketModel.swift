//
//  MarketModel.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

struct BaeminMarketCategory {
    let title: String
    let image: UIImage?
}

enum BaeminMarket {
    static let categories: [BaeminMarketCategory] = [
        BaeminMarketCategory(title: "B마트", image: UIImage(named: "nyangi1")),
        BaeminMarketCategory(title: "CU", image: UIImage(named: "nyangi2")),
        BaeminMarketCategory(title: "이마트슈퍼", image: UIImage(named: "nyangi3")),
        BaeminMarketCategory(title: "홈플러스", image: UIImage(named: "nyangi4")),
        BaeminMarketCategory(title: "GS25", image: UIImage(named: "nyangi5")),
        BaeminMarketCategory(title: "이마트", image: UIImage(named: "nyangi6"))
    ]
}
