//
//  RecentModel.swift
//  Baemin
//
//  Created by sun on 11/14/25.
//

import Foundation

struct RecentModel: Hashable {
    let id: Int
    let thumbnailName: String
    let recentOrderText: String?
    let name: String
    let rating: Double
    let reviewCount: Int
    let deliveryTimeText: String
    let deliveryFeeText: String
    let tags: [String]
}

extension RecentModel {
    static let mocks: [RecentModel] = [
        RecentModel(
            id: 0,
            thumbnailName: "store1",
            recentOrderText: "최근 1번 주문한 가게",
            name: "ASAP PIZZA 구로디지...",
            rating: 5.0,
            reviewCount: 123,
            deliveryTimeText: "31~46분",
            deliveryFeeText: "무료배달",
            tags: ["배민클럽", "픽업가능"]
        ),
        RecentModel(
            id: 1,
            thumbnailName: "store2",
            recentOrderText: "최근 1번 주문한 가게",
            name: "레전드 고기한상",
            rating: 4.9,
            reviewCount: 504,
            deliveryTimeText: "31~46분",
            deliveryFeeText: "무료배달",
            tags: ["배민클럽", "픽업가능", "예약가능"]
        ),
        RecentModel(
            id: 2,
            thumbnailName: "store3",
            recentOrderText: "최근 주문한 가게",
            name: "제육고전 신림본점",
            rating: 5.0,
            reviewCount: 2_851,
            deliveryTimeText: "31~46분",
            deliveryFeeText: "무료배달",
            tags: ["배민클럽", "소비쿠폰", "픽업가능"]
        ),
        RecentModel(
            id: 3,
            thumbnailName: "store4",
            recentOrderText: "최근 주문한 가게",
            name: "파스타에요 영등포...",
            rating: 5.0,
            reviewCount: 2_851,
            deliveryTimeText: "31~46분",
            deliveryFeeText: "무료배달",
            tags: ["배민클럽", "소비쿠폰", "픽업가능"]
        )
    ]
}
