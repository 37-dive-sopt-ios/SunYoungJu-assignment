//
//  LoginViewController.swift
//  Baemin
//
//  Created by sun on 10/27/25.
//

import UIKit

import SnapKit
import Then

final class LoginViewController: BaseViewController {
    
    // MARK: - UI
    
    private let navigationBar = NavigationBar()
    
    private let emailField = LoginTextField(
        type: .id,
        labelText: "이메일 아이디",
        placeholderText: "이메일을 입력해주세요"
    )
    
    private let passwordField = LoginTextField(
        type: .password,
        labelText: "비밀번호",
        placeholderText: "비밀번호를 입력해주세요"
    )
    
    private let loginButton = CTAButton(title: "로그인", isActive: false, size: .large)
    
    private let findAccountButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "chevron-right")
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.baseForegroundColor = .baeminBlack
        config.attributedTitle = AttributedString(
            NSAttributedString.pretendardString(
                "계정 찾기",
                style: .body_r_14,
                alignment: .center,
                isSingleLine: true
            )
        )
        $0.configuration = config
    }
    
    private let receivedLabel = UILabel().then {
        let color = UIColor.baeminBlack.withAlphaComponent(0.85)
        $0.setText(" ", style: .body_r_14, color: color, isSingleLine: true, alignment: .center)
        $0.isHidden = true
    }
    
    private let verticalStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 12
    }
    
    // MARK: - Lifecycle
    
    override func setUI() {
        view.addSubviews(navigationBar, verticalStack, findAccountButton, receivedLabel)
        
        navigationBar.setTitle("이메일 또는 아이디로 계속")
        
        verticalStack.addArrangedSubview(emailField)
        verticalStack.addArrangedSubview(passwordField)
        verticalStack.setCustomSpacing(24, after: passwordField)
        verticalStack.addArrangedSubview(loginButton)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(42)
        }
        
        verticalStack.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        loginButton.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        
        findAccountButton.snp.makeConstraints {
            $0.top.equalTo(verticalStack.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        receivedLabel.snp.makeConstraints {
            $0.top.equalTo(findAccountButton.snp.bottom).offset(8)
            $0.centerX.equalTo(findAccountButton)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    override func setAction() {
        let refresh = { [weak self] in
            guard let self else { return }
            self.loginButton.setActive(
                !self.emailField.text.isEmpty &&
                !self.passwordField.text.isEmpty
            )
        }
        
        emailField.onTextChanged = { _ in refresh() }
        passwordField.onTextChanged = { _ in refresh() }
        refresh()
        
        emailField.onReturn = { [weak self] in self?.passwordField.focus() }
        passwordField.onReturn = { [weak self] in
            guard let self else { return }
            self.view.endEditing(true)
            if self.loginButton.isActive { self.performLogin() }
        }
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        findAccountButton.addTarget(self, action: #selector(findAccountTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func loginButtonTapped() {
        performLogin()
    }
    
    private func performLogin() {
        let email = emailField.text
        let password = passwordField.text
        
        guard !email.isEmpty, !password.isEmpty else { return }
        
        if let invalid = validateSubmission(email: email, password: password) {
            ToastMessage.show(in: view, message: invalid.message)
            focus(for: invalid.field)
            return
        }
        
        let vc = WelcomeViewController()
        vc.email = email
        vc.delegate = self
        
        if let nav = navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }
    
    @objc private func findAccountTapped() {
        let sheet = LoginBottomSheetViewController()
        
        sheet.onConfirm = { [weak self] text in
            guard let self else { return }
            self.receivedLabel.setText(
                text,
                style: .body_r_14,
                color: self.receivedLabel.textColor,
                isSingleLine: true,
                alignment: .center
            )
            self.receivedLabel.isHidden = false
        }
        
        sheet.modalPresentationStyle = .pageSheet
        
        if let controller = sheet.sheetPresentationController {
            controller.detents = [.medium()]
            controller.prefersGrabberVisible = true
            controller.preferredCornerRadius = 20
        }
        
        present(sheet, animated: true)
    }
}

// MARK: - Validation

extension LoginViewController {
    
    private enum InvalidField { case email, password }
    
    private func validateSubmission(email: String, password: String)
        -> (message: String, field: InvalidField)?
    {
        if !Validator.isValidEmail(email) {
            return ("이메일 형식이 달라요", .email)
        }
        if !Validator.isValidPassword(password) {
            return ("비밀번호 형식이 달라요", .password)
        }
        return nil
    }
    
    private func focus(for field: InvalidField) {
        switch field {
        case .email: emailField.focus()
        case .password: passwordField.focus()
        }
    }
}

// MARK: - Welcome Delegate

extension LoginViewController: WelcomeViewControllerDelegate {
    func didTapBackButton(email: String) {
        emailField.setText(email)
    }
}

