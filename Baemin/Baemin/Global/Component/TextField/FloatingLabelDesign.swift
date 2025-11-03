//
//  FloatingLabelDesign.swift
//  Baemin
//
//  Created by sun on 11/1/25.
//

import UIKit

struct FloatingLabelDesign {

    let yOffset: CGFloat
    let duration: TimeInterval

    let borderColorNormal: CGColor
    let borderColorFocused: CGColor
    let labelTextColor: UIColor
    let labelFont: UIFont
    let labelRaisedFont: UIFont
    let labelBackgroundColor: UIColor
    let placeholderColor: UIColor
    let placeholderFont: UIFont

    static var `default`: FloatingLabelDesign {
        .init(
            yOffset: 6,
            duration: 0.18,
            borderColorNormal: (UIColor(named: "baemin-gray-200") ?? .systemGray4).cgColor,
            borderColorFocused: (UIColor(named: "baemin-black") ?? .label).cgColor,
            labelTextColor: UIColor(named: "baemin-gray-500") ?? .lightGray,
            labelFont: UIFont.Pretendard.body_r_14.font,
            labelRaisedFont: UIFont.Pretendard.caption_r_10.font,
            labelBackgroundColor: UIColor(named: "baemin-white") ?? .white,
            placeholderColor: UIColor(named: "baemin-gray-700") ?? .gray,
            placeholderFont: UIFont.Pretendard.body_r_14.font
        )
    }
}
