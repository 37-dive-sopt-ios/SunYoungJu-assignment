//
//  LoginBottomSheetViewController.swift
//  Baemin
//
//  Created by sun on 10/31/25.
//

import UIKit

import SnapKit
import Then

final class LoginBottomSheetViewController: UIViewController {

    var onConfirm: ((String) -> Void)?

    // MARK: - UI

    private let titleLabel = UILabel().then {
        $0.setText(
            "아이디를 입력해주세요",
            style: .head_b_18,
            color: UIColor(named: "baemin-black") ?? .label,
            isSingleLine: true,
            alignment: .left
        )
    }

    private let textField = UITextField().then {
        $0.placeholder = "아이디를 입력해주세요"
        $0.font = UIFont.Pretendard.body_r_14.font
        $0.textColor = UIColor(named: "baemin-black") ?? .label
        $0.borderStyle = .roundedRect
        $0.returnKeyType = .done
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
    }

    private let confirmButton = CTAButton(title: "확인", isActive: false, size: .large)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "baemin-gray-300") ?? .gray

        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(confirmButton)

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(44)
        }

        confirmButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(textField.snp.bottom).offset(122)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(52)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }

        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.delegate = self

        confirmButton.setActive(false)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func textChanged() {
        let hasText = !(textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        confirmButton.setActive(hasText)
    }

    @objc private func confirmTapped() {
        let text = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        onConfirm?(text)
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginBottomSheetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if confirmButton.isActive {
            confirmTapped()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
}
