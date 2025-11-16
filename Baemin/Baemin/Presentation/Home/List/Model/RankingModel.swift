//
//  RankingModel.swift
//  Baemin
//
//  Created by sun on 11/14/25.
//

import Foundation

struct RankingModel: Hashable {
    let id: Int
    let brandName: String
    let rating: Double
    let reviewCount: String
    let title: String
    let discountPercent: Int?
    let price: Int
    let originalPrice: Int?
    let minOrderText: String
    let thumbnailName: String
}

extension RankingModel {
    static let mocks: [RankingModel] = [
        RankingModel(
            id: 0,
            brandName: "백억보쌈제육...",
            rating: 5.0,
            reviewCount: "1,973",
            title: "[든든한 한끼] 보쌈 막국수",
            discountPercent: 25,
            price: 12_000,
            originalPrice: 16_000,
            minOrderText: "최소주문금액 없음",
            thumbnailName: "hangeureut1"
        ),
        RankingModel(
            id: 1,
            brandName: "백억보쌈제육...",
            rating: 5.0,
            reviewCount: "1,973",
            title: "(1인) 피자 + 사이드 Set",
            discountPercent: 20,
            price: 12_000,
            originalPrice: 16_000,
            minOrderText: "최소주문금액 없음",
            thumbnailName: "hangeureut2"
        ),
        RankingModel(
            id: 2,
            brandName: "백억보쌈제육...",
            rating: 5.0,
            reviewCount: "1,973",
            title: "[든든한 한끼] 보쌈막국수",
            discountPercent: 25,
            price: 12_000,
            originalPrice: 16_000,
            minOrderText: "최소주문금액 없음",
            thumbnailName: "hangeureut3"
        ),
        RankingModel(
            id: 1,
            brandName: "백억보쌈제육...",
            rating: 5.0,
            reviewCount: "1,973",
            title: "(1인) 피자 + 사이드 Set",
            discountPercent: 20,
            price: 12_000,
            originalPrice: 16_000,
            minOrderText: "최소주문금액 없음",
            thumbnailName: "hangeureut4"
        )
    ]
}
