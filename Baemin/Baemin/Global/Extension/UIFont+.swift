//
//  UIFont+.swift
//  Baemin
//
//  Created by sun on 10/27/25.
//

import UIKit

enum PretendardWeight: String {
    case regular = "Regular"
    case semibold = "SemiBold"
    case bold = "Bold"
}

extension UIFont {
    static func pretendard(_ weight: PretendardWeight = .regular, size: CGFloat) -> UIFont {
        let name = "Pretendard-\(weight.rawValue)"
        return UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: {
            switch weight {
            case .regular: return .regular
            case .semibold: return .semibold
            case .bold:     return .bold
            }
        }())
    }

    enum Pretendard {
        case head_b_24
        case head_b_18
        case title_sb_18
        case body_r_14
        case caption_r_10

        var font: UIFont {
            switch self {
            case .head_b_24:     return .pretendard(.bold, size: 24)
            case .head_b_18:     return .pretendard(.bold, size: 18)
            case .title_sb_18:   return .pretendard(.semibold, size: 18)
            case .body_r_14:     return .pretendard(.regular, size: 14)
            case .caption_r_10:  return .pretendard(.regular, size: 10)
            }
        }

        var letterSpacingPercent: CGFloat {
            switch self {
            case .head_b_24, .head_b_18: return -2
            case .title_sb_18:           return -3
            case .body_r_14, .caption_r_10: return -4
            }
        }

        var lineHeightMultiple: CGFloat { 1.0 }
    }
}
