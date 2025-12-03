//
//  WelcomeViewController.swift
//  Baemin
//
//  Created by sun on 10/27/25.
//

import UIKit

import Combine
import SnapKit
import Then

// MARK: - Delegate

protocol WelcomeViewControllerDelegate: AnyObject {
    func didTapBackButton(email: String)
}

// MARK: - WelcomeViewController

final class WelcomeViewController: BaseViewController {
    
    weak var delegate: WelcomeViewControllerDelegate?

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

    private let backButton = CTAButton(title: "배민으로 가기", isActive: true, size: .large)

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

    // MARK: - Properties

    private let viewModel: WelcomeViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        bindViewModel()
    }

    // MARK: - Bindings

    private func bindViewModel() {
        viewModel.$titleText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.titleLabel.text = text
            }
            .store(in: &cancellables)

        viewModel.$subtitleText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.subtitleLabel.text = text
            }
            .store(in: &cancellables)
    }

    // MARK: - Navigation

    private func goToBaeminTabBar() {
        let tabBarController = BaeminTabBarController()

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        } else {
            present(tabBarController, animated: true)
        }
    }

    // MARK: - Actions
    
    @objc private func didTapBackButtonAction() {
        delegate?.didTapBackButton(email: viewModel.email)
        goToBaeminTabBar()
    }

    private func notifyAndClose() {
        delegate?.didTapBackButton(email: viewModel.email)

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
