//
//  UIView+.swift
//  Baemin
//
//  Created by sun on 10/31/25.
//

import UIKit

public extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
