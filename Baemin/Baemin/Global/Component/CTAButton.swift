//
//  CTAButton.swift
//  Baemin
//
//  Created by sun on 10/27/25.
//

import UIKit

import SnapKit
import Then

final class CTAButton: UIButton {
    
    // MARK: - Types
    
    enum Size {
        case large
        case medium
        
        var font: UIFont {
            switch self {
            case .large:  return .pretendard(.semibold, size: 18)
            case .medium: return .pretendard(.regular,  size: 14)
            }
        }
        
        var verticalPadding: CGFloat { 14 }
        var horizontalPadding: CGFloat { 16 }
        var cornerRadius: CGFloat { 4 }
    }
    
    // MARK: - Stored Properties
    
    private(set) var isActive: Bool = true
    private(set) var ctaSize: Size = .large
    
    // MARK: - Init
    
    init(title: String, isActive: Bool = true, size: Size = .large) {
        self.isActive = isActive
        self.ctaSize = size
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton(title: currentTitle ?? "")
    }
    
    // MARK: - Setup
    
    private func setupButton(title: String) {
        clipsToBounds = true
        layer.cornerRadius = ctaSize.cornerRadius
        
        setTitle(title, for: .normal)
        titleLabel?.font = ctaSize.font
        titleLabel?.textAlignment = .center
        
        updateAppearance()
        
        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(titleLabel?.font.lineHeight ?? 0 + ctaSize.verticalPadding * 2)
        }
    }
    
    // MARK: - Configuration
    
    func setActive(_ active: Bool) {
        guard active != isActive else { return }
        isActive = active
        updateAppearance()
    }
    
    func setSize(_ size: Size) {
        ctaSize = size
        titleLabel?.font = size.font
        layer.cornerRadius = size.cornerRadius
        setNeedsLayout()
    }
    
    // MARK: - Private
    
    private func updateAppearance() {
        backgroundColor = isActive
        ? UIColor(named: "baemin-mint-500")
        : UIColor(named: "baemin-gray-200")
        
        setTitleColor(UIColor(named: "baemin-white"), for: .normal)
    }
    
    // MARK: - Animation
    
    override var isHighlighted: Bool {
        didSet { animatePress(isHighlighted) }
    }
    
    private func animatePress(_ pressed: Bool) {
        UIView.animate(withDuration: 0.08, delay: 0, options: [.curveEaseOut]) {
            self.transform = pressed ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            self.alpha = pressed ? 0.9 : 1.0
        }
    }
}
