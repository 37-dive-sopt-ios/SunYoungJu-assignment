//
//  MockListSectionFactory.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import Foundation

struct MockListSectionFactory {

    func makeRanking(_ count: Int) -> [RankingModel] {
        Array(RankingModel.mocks.prefix(count))
    }

    func makeRecent(_ count: Int) -> [RecentModel] {
        Array(RecentModel.mocks.prefix(count))
    }

    func makeDiscounted(_ count: Int) -> [DiscountModel] {
        Array(DiscountModel.mocks.prefix(count))
    }
}
