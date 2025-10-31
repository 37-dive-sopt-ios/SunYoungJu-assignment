//
//  UILabel+.swift
//  Baemin
//
//  Created by sun on 10/27/25.
//

import UIKit

extension UILabel {
    
    func setText(
        _ text: String = " ",
        style: UIFont.Pretendard,
        color: UIColor = .black,
        isSingleLine: Bool = false,
        alignment: NSTextAlignment? = nil
    ) {
        let safe = text.isEmpty ? " " : text
        attributedText = .pretendardString(
            safe,
            style: style,
            alignment: alignment ?? textAlignment,
            isSingleLine: isSingleLine
        )
        textColor = color
        
        if isSingleLine {
            numberOfLines = 1
            lineBreakMode = .byTruncatingTail
        } else {
            numberOfLines = 0
            lineBreakMode = .byWordWrapping
        }
    }
}
