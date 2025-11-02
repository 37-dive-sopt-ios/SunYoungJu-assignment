//
//  FloatingLabelBehavior.swift
//  Baemin
//
//  Created by sun on 11/1/25.
//

//
//  FloatingLabelBehavior.swift
//  Baemin
//
//  Created by sun on 11/1/25.
//

import UIKit

final class FloatingLabelBehavior {

    private weak var label: UILabel?
    private weak var labelBG: UIView?
    private weak var container: UIView?
    private weak var textField: UITextField?

    // MARK: - Design
    
    private let design: FloatingLabelDesign
    private var isRaised = false

    // MARK: - Init
    
    init(
        label: UILabel,
        labelBG: UIView,
        container: UIView,
        textField: UITextField,
        design: FloatingLabelDesign
    ) {
        self.label = label
        self.labelBG = labelBG
        self.container = container
        self.textField = textField
        self.design = design
    }

    // MARK: - Public
    
    func prepareInitialState() {
        guard let label, let labelBG else { return }
        isRaised = false
        label.alpha = 0
        labelBG.alpha = 0
        label.font = design.labelFont
        label.transform = .identity
        labelBG.transform = .identity
    }

    func applyPlaceholder(_ text: String, to textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .font: design.placeholderFont,
                .foregroundColor: design.placeholderColor
            ]
        )
    }

    func setRaised(_ raised: Bool, animated: Bool) {
        guard let label, let labelBG, let container, raised != isRaised else { return }

        isRaised = raised
        container.layoutIfNeeded()

        let changes = {
            if raised {
                label.font = self.design.labelRaisedFont

                let targetTopY: CGFloat = 0 - self.design.yOffset
                let dy = targetTopY - label.frame.minY

                label.transform = CGAffineTransform(translationX: 0, y: dy)
                labelBG.transform = CGAffineTransform(translationX: 0, y: dy)
                label.alpha = 1
                labelBG.alpha = 1
            } else {
                label.transform = .identity
                labelBG.transform = .identity
                label.font = self.design.labelFont
                label.alpha = 0
                labelBG.alpha = 0
            }
        }

        if animated {
            UIView.animate(withDuration: design.duration, animations: changes)
        } else {
            changes()
        }
    }

    func setFocused(_ focused: Bool) {
        container?.layer.borderColor = focused ? design.borderColorFocused : design.borderColorNormal
    }
}
