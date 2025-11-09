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
            borderColorNormal: UIColor.baeminGray200.cgColor,
            borderColorFocused: UIColor.baeminBlack.cgColor,
            labelTextColor: .baeminGray300,
            labelFont: .body_r_14,
            labelRaisedFont: .caption_r_10,
            labelBackgroundColor: .baeminWhite,
            placeholderColor: .baeminGray700,
            placeholderFont: .body_r_14
        )
    }
}

