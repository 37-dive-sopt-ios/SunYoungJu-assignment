//
//  BaeminTabBarController.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

import SnapKit
import Then

final class BaeminTabBarController: UITabBarController {

    // MARK: - UI Components

    private let tabBackgroundView = UIView().then {
        $0.backgroundColor = .white
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        setupTabBarAppearance()
        setupTabBackgroundView()
        setupTabBarViewControllers()
        updateTabBarBackgroundColor(for: selectedViewController)
    }
}

// MARK: - Setup

private extension BaeminTabBarController {

    func setupTabBarAppearance() {
        let itemAppearance = UITabBarItemAppearance().then {
            $0.normal.iconColor = .baeminGray700
            $0.selected.iconColor = .baeminBlack

            $0.normal.titleTextAttributes = [
                .font: UIFont.body_r_10,
                .foregroundColor: UIColor.baeminGray700
            ]
            $0.selected.titleTextAttributes = [
                .font: UIFont.body_r_10,
                .foregroundColor: UIColor.baeminBlack
            ]
        }

        let appearance = UITabBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .baeminWhite
            $0.stackedLayoutAppearance = itemAppearance
            $0.inlineLayoutAppearance = itemAppearance
            $0.compactInlineLayoutAppearance = itemAppearance
        }

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

    func setupTabBackgroundView() {
        view.insertSubview(tabBackgroundView, belowSubview: tabBar)

        tabBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top)
            make.height.equalTo(120)
        }
    }

    func setupTabBarViewControllers() {
        let homeViewController = BaeminTabContentViewController(kind: .home)
        let homeNavigationController = UINavigationController(rootViewController: homeViewController).then {
            $0.tabBarItem = UITabBarItem(
                title: "홈",
                image: UIImage(named: "home")?.withRenderingMode(.alwaysTemplate),
                tag: 0
            )
        }

        let shoppingViewController = BaeminTabContentViewController(kind: .shopping)
        let shoppingNavigationController = UINavigationController(rootViewController: shoppingViewController).then {
            $0.tabBarItem = UITabBarItem(
                title: "장보기·쇼핑",
                image: UIImage(named: "shopping")?.withRenderingMode(.alwaysTemplate),
                tag: 1
            )
        }

        let wishViewController = BaeminTabContentViewController(kind: .wish)
        let wishNavigationController = UINavigationController(rootViewController: wishViewController).then {
            $0.tabBarItem = UITabBarItem(
                title: "찜",
                image: UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate),
                tag: 2
            )
        }

        let ordersViewController = BaeminTabContentViewController(kind: .orders)
        let ordersNavigationController = UINavigationController(rootViewController: ordersViewController).then {
            $0.tabBarItem = UITabBarItem(
                title: "주문내역",
                image: UIImage(named: "order")?.withRenderingMode(.alwaysTemplate),
                tag: 3
            )
        }

        let myViewController = BaeminTabContentViewController(kind: .my)
        let myNavigationController = UINavigationController(rootViewController: myViewController).then {
            $0.tabBarItem = UITabBarItem(
                title: "마이배민",
                image: UIImage(named: "my")?.withRenderingMode(.alwaysTemplate),
                tag: 4
            )
        }

        viewControllers = [
            homeNavigationController,
            shoppingNavigationController,
            wishNavigationController,
            ordersNavigationController,
            myNavigationController
        ]

        selectedIndex = 0
    }
}

// MARK: - Update

private extension BaeminTabBarController {

    func updateTabBarBackgroundColor(for viewController: UIViewController?) {
        guard let viewController else {
            tabBackgroundView.backgroundColor = .white
            return
        }

        let baseViewController: UIViewController

        if let navigationController = viewController as? UINavigationController {
            baseViewController = navigationController.viewControllers.first ?? navigationController
        } else {
            baseViewController = viewController
        }

        if let contentViewController = baseViewController as? BaeminTabContentViewController {
            tabBackgroundView.backgroundColor = contentViewController.tabBackgroundColor
        } else {
            tabBackgroundView.backgroundColor = .white
        }
    }
}

// MARK: - Delegate

extension BaeminTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        updateTabBarBackgroundColor(for: viewController)
    }
}

// MARK: - Preview

#Preview {
    BaeminTabBarController()
}
