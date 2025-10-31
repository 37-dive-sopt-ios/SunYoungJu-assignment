//
//  LoginTextField.swift
//  Baemin
//
//  Created by sun on 10/31/25.
//

import UIKit

import SnapKit
import Then

// MARK: - Design

enum LoginFieldKind {
    case id
    case password

    var title: String {
        switch self {
        case .id: "아이디"
        case .password: "비밀번호"
        }
    }

    var keyboardType: UIKeyboardType { self == .id ? .emailAddress : .default }
    var returnKeyType: UIReturnKeyType { self == .id ? .next : .done }
    var isSecureByDefault: Bool { self == .password }
    var focusedBorderColor: UIColor { UIColor(named: "baemin-black") ?? .black }

    enum Accessory { case clear, eyeAndClear }
    var accessory: Accessory { self == .password ? .eyeAndClear : .clear }
}

// MARK: - Component

final class LoginTextField: UIView, UITextFieldDelegate, FloatingLabelAnimatable {

    enum Size { case large, medium }

    let kind: LoginFieldKind
    var text: String { textField.text ?? "" }
    var onTextChanged: ((String) -> Void)?
    var onReturn: (() -> Void)?

    init(
        type: LoginFieldKind,
        size: Size = .large,
        labelText: String? = nil,
        placeholderText: String? = nil
    ) {
        self.kind = type
        self.initialLabelText = labelText
        self.initialPlaceholderText = placeholderText
        super.init(frame: .zero)
        setupViewHierarchy()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func focus() { textField.becomeFirstResponder() }
    func clear() { textField.text = ""; textDidChange() }
    func setText(_ text: String) { textField.text = text; textDidChange() }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: UI
    private let containerView = UIView()
    let floatingLabel = UILabel()
    let labelBackgroundView = UIView()
    let textField = UITextField()
    let accessoryStackView = UIStackView()
    private var passwordToggleButton: UIButton?
    private var clearTextButton: UIButton?

    // MARK: Constraints
    private var labelCenterYConstraint: NSLayoutConstraint?
    private var labelBaselineConstraint: NSLayoutConstraint?
    private var textTrailingConstraint: Constraint?

    // MARK: Seeds
    private let initialLabelText: String?
    private let initialPlaceholderText: String?
    private lazy var basePlaceholderText: String = initialPlaceholderText ?? (initialLabelText ?? kind.title)

    // MARK: FloatingLabelAnimatable

    let contentInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
    let animationDuration: TimeInterval = 0.18
    let raisedScale: CGFloat = 0.86
    var isRaised: Bool = false
}

// MARK: - Setup

private extension LoginTextField {

    func setupViewHierarchy() {
        addSubview(containerView)
        containerView.do {
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = (UIColor(named: "baemin-gray-200") ?? .lightGray).cgColor
            $0.backgroundColor = .clear
            $0.isUserInteractionEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.greaterThanOrEqualTo(46)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(focusContainer))
        tapGesture.cancelsTouchesInView = false
        containerView.addGestureRecognizer(tapGesture)

        containerView.addSubview(labelBackgroundView)
        labelBackgroundView.do {
            $0.backgroundColor = UIColor(named: "baemin-white") ?? .white
            $0.isUserInteractionEnabled = false
            $0.layer.masksToBounds = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        containerView.addSubview(floatingLabel)
        floatingLabel.do {
            $0.font = UIFont.Pretendard.body_r_14.font
            $0.textColor = UIColor(named: "baemin-gray-500") ?? .gray
            $0.backgroundColor = UIColor(named: "baemin-white") ?? .white
            $0.text = initialLabelText ?? kind.title
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        labelCenterYConstraint = floatingLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        labelCenterYConstraint?.isActive = true
        floatingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: contentInsets.left).isActive = true

        NSLayoutConstraint.activate([
            labelBackgroundView.centerYAnchor.constraint(equalTo: floatingLabel.centerYAnchor),
            labelBackgroundView.leadingAnchor.constraint(equalTo: floatingLabel.leadingAnchor, constant: -6),
            labelBackgroundView.trailingAnchor.constraint(equalTo: floatingLabel.trailingAnchor, constant: 6),
            labelBackgroundView.topAnchor.constraint(equalTo: floatingLabel.topAnchor, constant: -2),
            labelBackgroundView.bottomAnchor.constraint(equalTo: floatingLabel.bottomAnchor, constant: 2)
        ])

        containerView.addSubview(textField)
        textField.do {
            $0.font = UIFont.Pretendard.body_r_14.font
            $0.textColor = .label
            $0.clearButtonMode = .never
            $0.delegate = self
            $0.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
            $0.adjustsFontSizeToFitWidth = false
            $0.backgroundColor = .clear
            $0.keyboardType = kind.keyboardType
            $0.returnKeyType = kind.returnKeyType
            $0.isSecureTextEntry = kind.isSecureByDefault
            $0.placeholder = nil
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: contentInsets.left),
            textField.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -(contentInsets.right + 24)),
            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: contentInsets.top),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -contentInsets.bottom)
        ])

        labelBaselineConstraint = floatingLabel.firstBaselineAnchor.constraint(equalTo: textField.firstBaselineAnchor, constant: -27)
        labelBaselineConstraint?.isActive = false

        containerView.addSubview(accessoryStackView)
        accessoryStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 8
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.alpha = 1
            $0.isUserInteractionEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            accessoryStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            accessoryStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -contentInsets.right)
        ])

        accessoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        switch kind.accessory {
        case .clear:
            accessoryStackView.addArrangedSubview(makeClearTextButton())
        case .eyeAndClear:
            accessoryStackView.addArrangedSubview(makeClearTextButton())
            accessoryStackView.addArrangedSubview(makePasswordToggleButton())
        }

        applyPlaceholder(basePlaceholderText, to: textField)

        floatingLabel.isHidden = true
        labelBackgroundView.isHidden = true
        floatingLabel.alpha = 0
        labelBackgroundView.alpha = 0
        isRaised = false

        updateAccessoryVisibility()
    }
}

// MARK: - Actions

private extension LoginTextField {
    @objc func focusContainer() { textField.becomeFirstResponder() }

    @objc func textDidChange() {
        let hasText = !(textField.text?.isEmpty ?? true)
        let shouldShow = hasText || textField.isFirstResponder
        if shouldShow != isRaised {
            setFloatingLabelRaised(shouldShow, animated: false)
            setLabelPositionRaised(shouldShow, animated: false)
            if shouldShow {
                textField.attributedPlaceholder = nil
            } else {
                applyPlaceholder(basePlaceholderText, to: textField)
            }
        }
        updateAccessoryVisibility()
        onTextChanged?(text)
    }

    func setLabelPositionRaised(_ raised: Bool, animated: Bool) {
        labelCenterYConstraint?.isActive = !raised
        labelBaselineConstraint?.isActive = raised
        let changes = { self.layoutIfNeeded() }
        animated ? UIView.animate(withDuration: animationDuration, animations: changes) : changes()
    }

    @objc func toggleSecureEntry() {
        textField.isSecureTextEntry.toggle()
        let current = textField.text
        textField.text = nil
        textField.text = current
        let imageName = textField.isSecureTextEntry ? "eye-slash" : "eye"
        passwordToggleButton?.setImage(UIImage(named: imageName), for: .normal)
    }

    @objc func clearTextTapped() { clear() }

    func updateAccessoryVisibility() {
        let hasText = !(textField.text?.isEmpty ?? true)
        clearTextButton?.isHidden = !hasText
        passwordToggleButton?.isHidden = !hasText
    }

    func makePasswordToggleButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: textField.isSecureTextEntry ? "eye-slash" : "eye"), for: .normal)
        button.tintColor = UIColor(named: "baemin-gray-400") ?? .tertiaryLabel
        button.addTarget(self, action: #selector(toggleSecureEntry), for: .touchUpInside)
        passwordToggleButton = button
        passwordToggleButton?.isHidden = true
        return button
    }

    func makeClearTextButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "x-circle"), for: .normal)
        button.tintColor = UIColor(named: "baemin-gray-400") ?? .tertiaryLabel
        button.addTarget(self, action: #selector(clearTextTapped), for: .touchUpInside)
        clearTextButton = button
        clearTextButton?.isHidden = true
        return button
    }
}

// MARK: - UITextFieldDelegate

extension LoginTextField {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        containerView.layer.borderColor = kind.focusedBorderColor.cgColor
        if !isRaised {
            setFloatingLabelRaised(true, animated: false)
            setLabelPositionRaised(true, animated: false)
            textField.attributedPlaceholder = nil
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        containerView.layer.borderColor = (UIColor(named: "baemin-gray-200") ?? .lightGray).cgColor
        let isEmpty = textField.text?.isEmpty ?? true
        let shouldShow = !isEmpty
        if shouldShow != isRaised {
            setFloatingLabelRaised(shouldShow, animated: false)
            setLabelPositionRaised(shouldShow, animated: false)
        }
        if isEmpty {
            applyPlaceholder(basePlaceholderText, to: textField)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn?()
        return true
    }
}
