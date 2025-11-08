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
        $0.textColor = .baeminBlack
        $0.font = .pretendard(.bold, size: 24)
        $0.text = "환영합니다"
    }

    private let subtitleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .baeminBlack
        $0.font = .pretendard(.regular, size: 14)
        $0.text = "반가워요!"
    }

    private let backButton = CTAButton(title: "뒤로가기", isActive: true, size: .large)

    private let verticalStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 16
    }

    private let contentStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 24
    }

    // MARK: - Lifecycle
    
    override func setUI() {
        view.addSubviews(
            navigationBar,
            mainImageView,
            contentStack
        )

        navigationBar.setTitle("대체 뼈짐 누가 시켰어??")
        navigationBar.onTapBack = { [weak self] in self?.notifyAndClose() }

        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.setCustomSpacing(8, after: titleLabel)
        verticalStack.addArrangedSubview(subtitleLabel)
        verticalStack.addArrangedSubview(UIView())

        contentStack.addArrangedSubviews(
            verticalStack,
            backButton
        )

        backButton.addTarget(
            self,
            action: #selector(didTapBackButtonAction),
            for: .touchUpInside
        )
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(42)
        }

        mainImageView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(211)
        }

        contentStack.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }

        backButton.snp.makeConstraints {
            $0.height.equalTo(52)
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

        if let nav = navigationController {
            if nav.viewControllers.first == self {
                nav.dismiss(animated: true)
            } else {
                nav.popViewController(animated: true)
            }
        } else {
            dismiss(animated: true)
        }
    }
}


