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
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "chevron-right")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        configuration.baseForegroundColor = UIColor(named: "baemin-black") ?? .label
        configuration.attributedTitle = AttributedString(
            NSAttributedString.pretendardString(
                "계정 찾기",
                style: .body_r_14,
                alignment: .center,
                isSingleLine: true
            )
        )
        $0.configuration = configuration
    }
    
    private let receivedLabel = UILabel().then {
        let color = (UIColor(named: "baemin-black") ?? .label).withAlphaComponent(0.85)
        $0.setText(" ", style: .body_r_14, color: color, isSingleLine: true, alignment: .center)
    }
    
    private let verticalStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 12
        $0.isLayoutMarginsRelativeArrangement = false
    }
    
    // MARK: - Lifecycle
    
    override func setUI() {
        view.addSubviews(navigationBar, verticalStack, findAccountButton, receivedLabel)
        
        navigationBar.setTitle("이메일 또는 아이디로 계속")
        
        verticalStack.addArrangedSubview(emailField)
        verticalStack.addArrangedSubview(passwordField)
        verticalStack.setCustomSpacing(24, after: passwordField)
        verticalStack.addArrangedSubview(loginButton)
        loginButton.snp.makeConstraints { $0.height.equalTo(52) }
        
        receivedLabel.isHidden = true
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(42)
        }
        
        verticalStack.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(24)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        findAccountButton.snp.makeConstraints { make in
            make.top.equalTo(verticalStack.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        receivedLabel.snp.makeConstraints { make in
            make.top.equalTo(findAccountButton.snp.bottom).offset(8)
            make.centerX.equalTo(findAccountButton)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    override func setAction() {
        let refreshLoginButtonEnabled: () -> Void = { [weak self] in
            guard let self else { return }
            let isEnabled = !self.emailField.text.isEmpty && !self.passwordField.text.isEmpty
            self.loginButton.setActive(isEnabled)
        }
        
        emailField.onTextChanged = { (_: String) in refreshLoginButtonEnabled() }
        passwordField.onTextChanged = { (_: String) in refreshLoginButtonEnabled() }
        
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
    
    @objc private func loginButtonTapped() { performLogin() }
    
    private func performLogin() {
        let email = emailField.text
        let password = passwordField.text
        guard !email.isEmpty, !password.isEmpty else { return }
        
        if let invalid = validateSubmission(email: email, password: password) {
            ToastMessage.show(in: view, message: invalid.message)
            focus(for: invalid.field)
            return
        }
        
        let welcomeViewController = WelcomeViewController()
        welcomeViewController.email = email
        welcomeViewController.delegate = self
        if let navigation = navigationController {
            navigation.pushViewController(welcomeViewController, animated: true)
        } else {
            let navigation = UINavigationController(rootViewController: welcomeViewController)
            navigation.modalPresentationStyle = .fullScreen
            present(navigation, animated: true)
        }
    }
    
    @objc private func findAccountTapped() {
        let bottomSheetVC = LoginBottomSheetViewController()
        bottomSheetVC.onConfirm = { [weak self] text in
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

        bottomSheetVC.modalPresentationStyle = .pageSheet

        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }

        present(bottomSheetVC, animated: true)
    }
}

// MARK: - Validation

extension LoginViewController {

    private enum InvalidField { case email, password }

    private func validateSubmission(email: String, password: String) -> (message: String, field: InvalidField)? {
        if !email.isValidEmail {
            return ("이메일 형식이 달라요", .email)
        }
        if !password.isValidPassword {
            return ("비밀번호 형식이 달라요", .password)
        }
        return nil
    }

    private func focus(for field: InvalidField) {
        switch field {
        case .email:
            emailField.focus()
        case .password:
            passwordField.focus()
        }
    }
}

// MARK: - Welcome Delegate

extension LoginViewController: WelcomeViewControllerDelegate {
    func didTapBackButton(email: String) {
        emailField.setText(email)
    }
}
