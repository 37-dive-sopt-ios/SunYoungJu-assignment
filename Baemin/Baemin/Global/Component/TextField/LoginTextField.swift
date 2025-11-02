//
//  LoginTextField.swift
//  Baemin
//
//  Created by sun on 10/31/25.
//

import UIKit

import SnapKit
import Then

// MARK: - Type

enum LoginFieldType {
    case id, password
    var title: String { self == .id ? "아이디" : "비밀번호" }
    var secureDefault: Bool { self == .password }
    var needsEye: Bool { self == .password }
}

// MARK: - Component

final class LoginTextField: UIView, UITextFieldDelegate {

    // MARK: - Public
    
    var text: String { textField.text ?? "" }
    var onReturn: (() -> Void)?
    var onTextChanged: ((String) -> Void)?

    func focus() { textField.becomeFirstResponder() }
    func setText(_ text: String) { textField.text = text; textDidChange() }
    func clear() { textField.text = nil; textDidChange() }

    // MARK: - Private
    
    private let fieldType: LoginFieldType
    private let titleText: String
    private let placeholderText: String
    private let design: FloatingLabelDesign

    private let container = UIView()
    private let labelBG = UIView()
    private let label = UILabel()
    private let textField = UITextField()
    private let accessory = UIStackView()
    private var clearBtn: UIButton?
    private var eyeBtn: UIButton?

    private lazy var fl: FloatingLabelBehavior = .init(
        label: label,
        labelBG: labelBG,
        container: container,
        textField: textField,
        design: design
    )

    // MARK: - Init
    
    init(
        type: LoginFieldType,
        labelText: String? = nil,
        placeholderText: String? = nil,
        design: FloatingLabelDesign = .default
    ) {
        self.fieldType = type
        self.titleText = labelText ?? type.title
        self.placeholderText = placeholderText ?? (labelText ?? type.title)
        self.design = design
        super.init(frame: .zero)
        setupUI()
        fl.prepareInitialState()
        fl.applyPlaceholder(self.placeholderText, to: textField)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Setup
    
    private func setupUI() {
        addSubview(container)
        container.do {
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = design.borderColorNormal
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(focusContainer)))
            $0.isUserInteractionEnabled = true
        }
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.greaterThanOrEqualTo(46)
        }

        container.addSubviews(textField, accessory)

        textField.do {
            $0.backgroundColor = .clear
            $0.font = UIFont.Pretendard.body_r_14.font
            $0.textColor = .label
            $0.isSecureTextEntry = fieldType.secureDefault
            $0.clearButtonMode = .never
            $0.delegate = self
            $0.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
            $0.addLeftPadding(16)
            $0.addRightPadding(8)
        }
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(accessory.snp.leading).offset(-8)
            $0.top.bottom.equalToSuperview()
        }

        accessory.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 8
            $0.isLayoutMarginsRelativeArrangement = false
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        accessory.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(fieldType.needsEye ? 56 : 24)
        }

        if fieldType.needsEye {
            let clear = makeButton(image: "x-circle", action: #selector(clearTapped))
            let eye = makeButton(image: "eye-slash", action: #selector(eyeTapped))
            accessory.addArrangedSubview(clear)
            accessory.addArrangedSubview(eye)
            self.clearBtn = clear
            self.eyeBtn = eye
        } else {
            let clear = makeButton(image: "x-circle", action: #selector(clearTapped))
            accessory.addArrangedSubview(clear)
            self.clearBtn = clear
        }

        addSubviews(labelBG, label)

        labelBG.do {
            $0.backgroundColor = design.labelBackgroundColor
            $0.isUserInteractionEnabled = false
            $0.layer.masksToBounds = true
        }
        label.do {
            $0.text = titleText
            $0.font = design.labelFont
            $0.textColor = design.labelTextColor
            $0.isUserInteractionEnabled = false
        }

        label.snp.makeConstraints {
            $0.leading.equalTo(container.snp.leading).inset(16)
            $0.centerY.equalTo(container.snp.centerY)
        }
        labelBG.snp.makeConstraints {
            $0.edges.equalTo(label).inset(UIEdgeInsets(top: -2, left: -6, bottom: -2, right: -6))
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        labelBG.layer.cornerRadius = labelBG.bounds.height / 2
    }

    // MARK: - Actions
    
    @objc private func focusContainer() { textField.becomeFirstResponder() }

    @objc private func textDidChange() {
        let hasText = !(textField.text?.isEmpty ?? true)
        let shouldRaise = hasText || textField.isFirstResponder
        fl.setRaised(shouldRaise, animated: true)
        shouldRaise ? (textField.attributedPlaceholder = nil)
                    : fl.applyPlaceholder(placeholderText, to: textField)
        setAccessory(visible: hasText)
        onTextChanged?(text)
    }

    @objc private func clearTapped() {
        textField.text = nil
        textDidChange()
    }

    @objc private func eyeTapped() {
        textField.isSecureTextEntry.toggle()
        let next = textField.isSecureTextEntry ? "eye-slash" : "eye"
        eyeBtn?.setImage(UIImage(named: next), for: .normal)
        let text = textField.text; textField.text = nil; textField.text = text
    }

    // MARK: - Helpers
    
    private func setAccessory(visible: Bool) {
        UIView.animate(withDuration: 0.15) {
            self.clearBtn?.alpha = visible ? 1 : 0
            self.eyeBtn?.alpha = (self.fieldType.needsEye && visible) ? 1 : 0
        }
        clearBtn?.isUserInteractionEnabled = visible
        eyeBtn?.isUserInteractionEnabled = visible
    }

    private func makeButton(image: String, action: Selector) -> UIButton {
        UIButton(type: .system).then {
            $0.setImage(UIImage(named: image), for: .normal)
            $0.tintColor = UIColor(named: "baemin-gray-400") ?? .tertiaryLabel
            $0.alpha = 0
            $0.addTarget(self, action: action, for: .touchUpInside)
        }
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fl.setFocused(true)
        textDidChange()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        fl.setFocused(false)
        textDidChange()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn?()
        return true
    }
}
