//
//  NSAttributedString+.swift
//  Baemin
//
//  Created by sun on 10/27/25.
//

import UIKit

extension NSAttributedString {
    static func pretendardString(
        _ text: String,
        style: UIFont.Pretendard,
        alignment: NSTextAlignment? = nil,
        isSingleLine: Bool = false
    ) -> NSAttributedString {
        let font = style.font
        let paragraph = NSMutableParagraphStyle()
        if let alignment { paragraph.alignment = alignment }

        if !isSingleLine {
            let lineHeight = font.pointSize * style.lineHeightMultiple
            paragraph.minimumLineHeight = lineHeight
            paragraph.maximumLineHeight = lineHeight
        }

        let kern = (style.letterSpacingPercent / 100.0) * font.pointSize

        return NSAttributedString(string: text, attributes: [
            .font: font,
            .kern: kern,
            .paragraphStyle: paragraph
        ])
    }
}
