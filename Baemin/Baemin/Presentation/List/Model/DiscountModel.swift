//
//  DiscountModel.swift
//  Baemin
//
//  Created by sun on 11/14/25.
//

import Foundation

struct DiscountModel: Hashable {
    let id: Int
    let thumbnailName: String
    let name: String
    let rating: Double
    let reviewCount: Int
    let deliveryTimeText: String
    let deliveryFeeText: String
    let tags: [String]
}

extension DiscountModel {
    static let mocks: [DiscountModel] = [
        DiscountModel(
            id: 0,
            thumbnailName: "store4",
            name: "제육고집 신림본점",
            rating: 5.0,
            reviewCount: 2_851,
            deliveryTimeText: "31~46분",
            deliveryFeeText: "무료배달",
            tags: ["배민클럽", "소비쿠폰", "픽업가능", "위생인증"]
        ),
        DiscountModel(
            id: 1,
            thumbnailName: "store3",
            name: "파스타에요 영등포...",
            rating: 5.0,
            reviewCount: 1_245,
            deliveryTimeText: "31~46분",
            deliveryFeeText: "무료배달",
            tags: ["배민클럽", "소비쿠폰", "픽업가능"]
        ),
        DiscountModel(
            id: 2,
            thumbnailName: "store2",
            name: "레전드 고기한상",
            rating: 4.9,
            reviewCount: 504,
            deliveryTimeText: "31~46분",
            deliveryFeeText: "무료배달",
            tags: ["배민클럽", "픽업가능", "위생인증"]
        ),
        DiscountModel(
            id: 3,
            thumbnailName: "store1",
            name: "ASAP PIZZA 구로디지...",
            rating: 5.0,
            reviewCount: 123,
            deliveryTimeText: "31~46분",
            deliveryFeeText: "무료배달",
            tags: ["배민클럽", "소비쿠폰"]
        )
    ]
}
