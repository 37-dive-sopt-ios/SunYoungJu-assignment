//
//  LoginBottomSheetViewController.swift
//  Baemin
//
//  Created by sun on 10/31/25.
//

import UIKit

import SnapKit
import Then

final class LoginBottomSheetViewController: BaseViewController {

    var onConfirm: ((String) -> Void)?

    // MARK: - UI

    private let titleLabel = UILabel().then {
        $0.setText(
            "아이디를 입력해주세요",
            style: .head_b_18,
            color: .baeminBlack,
            isSingleLine: true,
            alignment: .left
        )
    }

    private let textField = UITextField().then {
        $0.placeholder = "아이디를 입력해주세요"
        $0.font = .body_r_14
        $0.textColor = .baeminBlack
        $0.borderStyle = .roundedRect
        $0.returnKeyType = .done
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
    }

    private let confirmButton = CTAButton(title: "확인", isActive: false, size: .large)

    private let stackView = UIStackView().then {
        $0.configure(axis: .vertical, spacing: 16)
    }

    private let contentStack = UIStackView().then {
        $0.configure(axis: .vertical, spacing: 122)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baeminGray300
        setupUI()
        setupActions()
    }
}

private extension LoginBottomSheetViewController {

    // MARK: - Setup UI

    func setupUI() {
        stackView.addArrangedSubviews(titleLabel, textField)
        contentStack.addArrangedSubviews(stackView, confirmButton)
        view.addSubviews(contentStack)

        contentStack.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }

        textField.snp.makeConstraints { $0.height.equalTo(44) }
        confirmButton.snp.makeConstraints { $0.height.equalTo(52) }
    }

    // MARK: - Setup Actions

    func setupActions() {
        textField.addTarget(self, action: #selector(textChanged), for: UIControl.Event.editingChanged)
        textField.delegate = self
        confirmButton.setActive(false)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }
}

private extension LoginBottomSheetViewController {

    // MARK: - Actions

    @objc func textChanged() {
        let hasText = !(textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        confirmButton.setActive(hasText)
    }

    @objc func confirmTapped() {
        let text = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        onConfirm?(text)
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginBottomSheetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if confirmButton.isActive { confirmTapped() }
        else { textField.resignFirstResponder() }
        return true
    }
}
