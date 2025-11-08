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
        isEnabled = isActive

        if #available(iOS 15.0, *) {
            configuration = buildConfiguration(with: title)
        } else {
            setTitle(title, for: .normal)
            titleLabel?.adjustsFontForContentSizeCategory = true
            titleLabel?.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: ctaSize.font)
            titleLabel?.textAlignment = .center
            contentEdgeInsets = UIEdgeInsets(
                top: ctaSize.verticalPadding,
                left: ctaSize.horizontalPadding,
                bottom: ctaSize.verticalPadding,
                right: ctaSize.horizontalPadding
            )
            updateAppearanceLegacy()
        }
    }

    // MARK: - Configuration
    
    func setActive(_ active: Bool) {
        guard active != isActive else { return }
        isActive = active
        isEnabled = active
        if #available(iOS 15.0, *) {
            configuration = buildConfiguration(with: title(for: .normal) ?? "")
        } else {
            updateAppearanceLegacy()
        }
    }

    func setSize(_ size: Size) {
        ctaSize = size
        layer.cornerRadius = size.cornerRadius
        if #available(iOS 15.0, *) {
            configuration = buildConfiguration(with: title(for: .normal) ?? "")
        } else {
            titleLabel?.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: size.font)
            contentEdgeInsets = UIEdgeInsets(
                top: size.verticalPadding,
                left: size.horizontalPadding,
                bottom: size.verticalPadding,
                right: size.horizontalPadding
            )
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }

    // MARK: - Private
    
    @available(iOS 15.0, *)
    private func buildConfiguration(with title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = isActive ? .baeminMint500 : .baeminGray200
        config.baseForegroundColor = .baeminWhite
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
            style: ctaSize == .large ? .head_b_18 : .body_r_14,
            alignment: .center,
            isSingleLine: true
        )
        config.attributedTitle = AttributedString(styled)
        return config
    }

    private func updateAppearanceLegacy() {
        backgroundColor = isActive ? .baeminMint500 : .baeminGray200
        setTitleColor(.baeminWhite, for: .normal)
        setTitleColor(.baeminWhite.withAlphaComponent(0.6), for: .disabled)
        alpha = isEnabled ? 1.0 : 0.6
    }

    // MARK: - Animation
    override var isHighlighted: Bool {
        didSet { animatePress(isHighlighted) }
    }

    private func animatePress(_ pressed: Bool) {
        UIView.animate(
            withDuration: 0.08,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction, .beginFromCurrentState]
        ) {
            self.transform = pressed ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            self.alpha = pressed ? 0.9 : (self.isEnabled ? 1.0 : 0.6)
        }
    }
}


