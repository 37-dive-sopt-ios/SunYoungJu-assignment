//
//  CTAButton.swift
//  Baemin
//
//  Created by sun on 10/27/25.
//

import UIKit

final class CTAButton: UIButton {
    
    enum Size {
        case large
        case medium

        var pretendardStyle: UIFont.Pretendard {
            switch self {
            case .large:  return .head_b_18
            case .medium: return .body_r_14
            }
        }

        var verticalPadding: CGFloat { 14 }
        var horizontalPadding: CGFloat { 16 }
        var cornerRadius: CGFloat { 4 }
    }

    private(set) var isActive: Bool = true
    private(set) var ctaSize: Size = .large

    // MARK: - Init
    
    init(title: String, isActive: Bool = true, size: Size = .large) {
        self.isActive = isActive
        self.ctaSize = size
        super.init(frame: .zero)
        commonInit()
        setTitle(title,  for: .normal)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        let text = title(for: .normal) ?? currentTitle ?? ""
        setTitle(text, for: .normal)
    }

    // MARK: - Setters
    
    func setActive(_ active: Bool) {
        guard active != isActive else { return }
        isActive = active
        isEnabled = active
        refreshConfiguration()
    }

    func setSize(_ size: Size) {
        guard size != ctaSize else { return }
        ctaSize = size
        refreshConfiguration()
        invalidateIntrinsicContentSize()
    }

    // MARK: - Override
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        if state == .normal { apply(title: title ?? "") }
    }

    override var isHighlighted: Bool {
        didSet { animatePress(isHighlighted) }
    }

    // MARK: - Setup
    
    private func commonInit() {
        clipsToBounds = true
        layer.cornerRadius = ctaSize.cornerRadius
        isEnabled = isActive
    }

    private func apply(title: String) {
        configuration = buildConfiguration(title: title)
    }

    private func refreshConfiguration() {
        let text = title(for: .normal) ?? ""
        configuration = buildConfiguration(title: text)
    }

    // MARK: - Configuration
    
    private func buildConfiguration(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = isActive ? .baeminMint500 : .baeminGray200
        config.cornerStyle = .fixed
        config.background.cornerRadius = ctaSize.cornerRadius
        config.contentInsets = NSDirectionalEdgeInsets(
            top: ctaSize.verticalPadding,
            leading: ctaSize.horizontalPadding,
            bottom: ctaSize.verticalPadding,
            trailing: ctaSize.horizontalPadding
        )
        
        let styled = NSAttributedString.pretendardString(
            title,
            style: ctaSize.pretendardStyle,
            alignment: .center,
            isSingleLine: true
        )

        let mutable = NSMutableAttributedString(attributedString: styled)
        mutable.addAttribute(
            .foregroundColor,
            value: UIColor.baeminWhite,
            range: NSRange(location: 0, length: mutable.length)
        )

        config.attributedTitle = AttributedString(mutable)

        return config
    }

    // MARK: - Animation
    
    private func animatePress(_ pressed: Bool) {
        UIView.animate(
            withDuration: 0.08,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction, .beginFromCurrentState]
        ) {
            self.transform = pressed
                ? CGAffineTransform(scaleX: 0.98, y: 0.98)
                : .identity
            self.alpha = pressed ? 0.9 : (self.isEnabled ? 1.0 : 0.6)
        }
    }
}
