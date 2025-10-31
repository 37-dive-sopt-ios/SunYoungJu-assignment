//
//  WelcomeViewController.swift
//  Baemin
//
//  Created by sun on 10/27/25.
//

import UIKit

import SnapKit
import Then

// MARK: - Delegate

protocol WelcomeViewControllerDelegate: AnyObject {
    func didTapBackButton(email: String)
}

// MARK: - WelcomeViewController

final class WelcomeViewController: BaseViewController {

    // MARK: - Public
    
    weak var delegate: WelcomeViewControllerDelegate?
    var email: String = ""

    // MARK: - UI
    
    private let navigationBar = NavigationBar()

    private let mainImageView = UIImageView().then {
        $0.image = UIImage(named: "beamin")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "baemin-black") ?? .label
        $0.font = UIFont.Pretendard.head_b_24.font
        $0.text = "환영합니다"
    }

    private let subtitleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "baemin-black") ?? .secondaryLabel
        $0.font = UIFont.Pretendard.body_r_14.font
        $0.text = "반가워요!"
    }

    private let backButton = CTAButton(title: "뒤로가기", isActive: true, size: .large)

    private let verticalStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 16
    }

    // MARK: - Lifecycle
    
    override func setUI() {
        view.addSubviews(navigationBar, mainImageView, verticalStack, backButton)

        navigationBar.setTitle("대체 뼈짐 누가 시켰어??")
        navigationBar.onTapBack = { [weak self] in self?.notifyAndClose() }

        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.setCustomSpacing(8, after: titleLabel)
        verticalStack.addArrangedSubview(subtitleLabel)
        verticalStack.addArrangedSubview(UIView())

        backButton.addTarget(self, action: #selector(didTapBackButtonAction), for: .touchUpInside)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(42)
        }

        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(211)
        }

        verticalStack.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        backButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(52)
            make.top.greaterThanOrEqualTo(verticalStack.snp.bottom).offset(24)
        }
    }

    override func setAction() {
        if !email.isEmpty {
            subtitleLabel.text = "\(email)님 반가워요!"
        }
    }

    // MARK: - Actions
    
    @objc private func didTapBackButtonAction() {
        notifyAndClose()
    }

    private func notifyAndClose() {
        delegate?.didTapBackButton(email: email)

        if let navigation = navigationController {
            if navigation.viewControllers.first == self {
                navigation.dismiss(animated: true)
            } else {
                navigation.popViewController(animated: true)
            }
        } else {
            dismiss(animated: true)
        }
    }
}
