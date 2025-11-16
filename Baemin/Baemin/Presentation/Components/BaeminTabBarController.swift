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

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarAppearance()
        setupTabBarViewControllers()
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

    func setupTabBarViewControllers() {
        let home = UINavigationController(rootViewController: BaeminTabContentViewController(kind: .home)).then {
            $0.tabBarItem = UITabBarItem(
                title: "홈",
                image: UIImage(named: "home")?.withRenderingMode(.alwaysTemplate),
                tag: 0
            )
        }

        let shopping = UINavigationController(rootViewController: BaeminTabContentViewController(kind: .shopping)).then {
            $0.tabBarItem = UITabBarItem(
                title: "장보기·쇼핑",
                image: UIImage(named: "shopping")?.withRenderingMode(.alwaysTemplate),
                tag: 1
            )
        }

        let wish = UINavigationController(rootViewController: BaeminTabContentViewController(kind: .wish)).then {
            $0.tabBarItem = UITabBarItem(
                title: "찜",
                image: UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate),
                tag: 2
            )
        }

        let orders = UINavigationController(rootViewController: BaeminTabContentViewController(kind: .orders)).then {
            $0.tabBarItem = UITabBarItem(
                title: "주문내역",
                image: UIImage(named: "order")?.withRenderingMode(.alwaysTemplate),
                tag: 3
            )
        }

        let my = UINavigationController(rootViewController: BaeminTabContentViewController(kind: .my)).then {
            $0.tabBarItem = UITabBarItem(
                title: "마이배민",
                image: UIImage(named: "my")?.withRenderingMode(.alwaysTemplate),
                tag: 4
            )
        }

        viewControllers = [home, shopping, wish, orders, my]
        selectedIndex = 0
    }
}

// MARK: - Preview

#Preview {
    BaeminTabBarController()
}

