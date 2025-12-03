//
//  ListSection.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import Foundation

enum ListSection {
    case ranking([RankingModel])
    case recent([RecentModel])
    case discounted([DiscountModel])
    
    var itemCount: Int {
        switch self {
        case .ranking(let items):    return items.count
        case .recent(let items):     return items.count
        case .discounted(let items): return items.count
        }
    }

    var title: String {
        switch self {
        case .ranking:    return "우리 동네 한그릇 인기 랭킹"
        case .recent:     return "최근에 주문했어요"
        case .discounted: return "무조건 할인하는 가게"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .discounted: return "2천원 이상 또는 15% 이상 할인중"
        default: return nil
        }
    }
    
    var headerStyle: SectionHeaderStyle {
        switch self {
        case .ranking: return .ranking
        case .recent: return .recent
        case .discounted: return .discounted
        }
    }
}
