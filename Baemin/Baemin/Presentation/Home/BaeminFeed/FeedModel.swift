//
//  FeedModel.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

struct BaeminCategory {
    let title: String
    let image: UIImage?
}

enum BaeminFeed {
    static let categories: [BaeminCategory] = [
        BaeminCategory(title: "한그릇", image: UIImage(named: "nunmeongi1")),
        BaeminCategory(title: "치킨", image: UIImage(named: "nunmeongi2")),
        BaeminCategory(title: "카페·디저트", image: UIImage(named: "nunmeongi3")),
        BaeminCategory(title: "피자", image: UIImage(named: "nunmeongi4")),
        BaeminCategory(title: "분식", image: UIImage(named: "nunmeongi5")),
        BaeminCategory(title: "고기", image: UIImage(named: "nunmeongi6")),
        BaeminCategory(title: "찜·탕", image: UIImage(named: "nunmeongi7")),
        BaeminCategory(title: "야식", image: UIImage(named: "nunmeongi8")),
        BaeminCategory(title: "패스트푸드", image: UIImage(named: "nunmeongi9")),
        BaeminCategory(title: "픽업", image: UIImage(named: "nunmeongi10"))
    ]
}
