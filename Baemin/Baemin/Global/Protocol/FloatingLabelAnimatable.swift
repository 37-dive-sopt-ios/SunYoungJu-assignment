//
//  FloatingLabelAnimatable.swift
//  Baemin
//
//  Created by sun on 10/31/25.
//

import UIKit

protocol FloatingLabelAnimatable: AnyObject {
    var floatingLabel: UILabel { get }
    var labelBackgroundView: UIView { get }
    var accessoryStackView: UIStackView { get }
    var animationDuration: TimeInterval { get }
    var raisedScale: CGFloat { get }
    var isRaised: Bool { get set }
    var contentInsets: UIEdgeInsets { get }

    var raisedYOffset: CGFloat { get }

    func setFloatingLabelRaised(_ raised: Bool, animated: Bool)

    func prepareFloatingLabelInitialState()

    func updateFloatingLabelVisibility(for textField: UITextField, isEditing: Bool)

    func applyPlaceholder(_ text: String, to textField: UITextField)
    func updateFloatingLabelFont(isRaised: Bool)
}

// MARK: - Default

extension FloatingLabelAnimatable {

    var raisedYOffset: CGFloat { 5 }

    func prepareFloatingLabelInitialState() {
        isRaised = false
        floatingLabel.isHidden = true
        floatingLabel.alpha = 0
        labelBackgroundView.isHidden = true
        labelBackgroundView.alpha = 0
        accessoryStackView.alpha = 0
        accessoryStackView.isUserInteractionEnabled = false
        
        floatingLabel.transform = .identity
        labelBackgroundView.transform = .identity
        updateFloatingLabelFont(isRaised: false)
    }

    func updateFloatingLabelVisibility(for textField: UITextField, isEditing: Bool) {
        let hasText = !(textField.text ?? "").isEmpty
        let shouldShow = isEditing || hasText
        setFloatingLabelRaised(shouldShow, animated: false)
        if shouldShow {
            textField.attributedPlaceholder = nil
        }
    }

    func setFloatingLabelRaised(_ raised: Bool, animated: Bool) {
        guard raised != isRaised else { return }
        isRaised = raised

        floatingLabel.superview?.layoutIfNeeded()

        if raised {
            let topY = contentInsets.top
            let currentMinY = floatingLabel.frame.minY
            let deltaToTop = topY - currentMinY
            let translationY = deltaToTop + raisedYOffset

            let scale = raisedScale
            let fixedTransform = CGAffineTransform.identity
                .translatedBy(x: 0, y: translationY)
                .scaledBy(x: scale, y: scale)

            floatingLabel.transform = fixedTransform
            labelBackgroundView.transform = fixedTransform

            updateFloatingLabelFont(isRaised: true)

            floatingLabel.isHidden = false
            labelBackgroundView.isHidden = false
            floatingLabel.alpha = 1
            labelBackgroundView.alpha = 1
            accessoryStackView.alpha = 1
            accessoryStackView.isUserInteractionEnabled = true
        } else {
            floatingLabel.isHidden = true
            labelBackgroundView.isHidden = true
            floatingLabel.alpha = 0
            labelBackgroundView.alpha = 0
            accessoryStackView.alpha = 0
            accessoryStackView.isUserInteractionEnabled = false

            floatingLabel.transform = .identity
            labelBackgroundView.transform = .identity
            updateFloatingLabelFont(isRaised: false)
        }
    }

    func applyPlaceholder(_ text: String, to textField: UITextField) {
        let font = UIFont.Pretendard.body_r_14.font
        let color = UIColor(named: "baemin-gray-700") ?? .tertiaryLabel
        textField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [.font: font, .foregroundColor: color]
        )
    }

    func updateFloatingLabelFont(isRaised: Bool) {
        let font = isRaised
        ? UIFont.Pretendard.caption_r_10.font
        : UIFont.Pretendard.body_r_14.font
        floatingLabel.font = font
    }
}
