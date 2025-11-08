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

    var systemWeight: UIFont.Weight {
        switch self {
        case .regular:  return .regular
        case .semibold: return .semibold
        case .bold:     return .bold
        }
    }
}

extension UIFont {
    static func pretendard(_ weight: PretendardWeight = .regular, size: CGFloat) -> UIFont {
        let name = "Pretendard-\(weight.rawValue)"
        if let custom = UIFont(name: name, size: size) {
            return custom
        }
        return .systemFont(ofSize: size, weight: weight.systemWeight)
    }

    enum Pretendard {
        case head_b_24
        case head_b_18
        case title_sb_18
        case body_r_14
        case caption_r_10

        var weight: PretendardWeight {
            switch self {
            case .head_b_24, .head_b_18:  return .bold
            case .title_sb_18:            return .semibold
            case .body_r_14, .caption_r_10: return .regular
            }
        }

        var size: CGFloat {
            switch self {
            case .head_b_24:    return 24
            case .head_b_18:    return 18
            case .title_sb_18:  return 18
            case .body_r_14:    return 14
            case .caption_r_10: return 10
            }
        }

        var font: UIFont {
            .pretendard(weight, size: size)
        }

        var letterSpacingPercent: CGFloat {
            switch self {
            case .head_b_24, .head_b_18:      return -2
            case .title_sb_18:                return -3
            case .body_r_14, .caption_r_10:   return -4
            }
        }

        var lineHeightMultiple: CGFloat { 1.0 }
    }

    static var head_b_24: UIFont { Pretendard.head_b_24.font }
    static var head_b_18: UIFont { Pretendard.head_b_18.font }
    static var title_sb_18: UIFont { Pretendard.title_sb_18.font }
    static var body_r_14: UIFont { Pretendard.body_r_14.font }
    static var caption_r_10: UIFont { Pretendard.caption_r_10.font }
}

