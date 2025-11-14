//
//  BaeminTabContentViewController.swift
//  Baemin
//
//  Created by sun on 11/14/25.
//

import UIKit

import SnapKit
import Then

enum BaeminTabKind {
    case home
    case shopping
    case wish
    case orders
    case my
}

final class BaeminTabContentViewController: BaseViewController {
    
    // MARK: - UI
    
    let tabRootView = HomeView()
    
    private let headerViewController = BaeminHeaderViewController()
    private let searchBarView = BaeminSearchBar()
    private let feedViewController = BaeminFeedViewController()
    private let marketViewController = BaeminMarketViewController()
    
    // MARK: - Tab
    
    let kind: BaeminTabKind
    
    var tabBackgroundColor: UIColor {
        switch kind {
        case .home:
            return .clear
        case .shopping:
            return .systemPurple.withAlphaComponent(0.3)
        case .wish:
            return .systemPink.withAlphaComponent(0.3)
        case .orders:
            return .systemGreen.withAlphaComponent(0.3)
        case .my:
            return .systemOrange.withAlphaComponent(0.3)
        }
    }
    
    // MARK: - Init
    
    init(kind: BaeminTabKind) {
        self.kind = kind
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = tabRootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabRootView.backgroundColor = .baeminBackgroundWhite
        
        setupHeaderLayout()
        setupSearchBarLayout()
        setupContentLayout()
    }
    
    // MARK: - Layout
    
    private func setupHeaderLayout() {
        addChild(headerViewController)
        tabRootView.headerContainerView.addSubview(headerViewController.view)
        
        headerViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerViewController.didMove(toParent: self)
    }
    
    private func setupSearchBarLayout() {
        tabRootView.searchBarContainerView.addSubview(searchBarView)
        
        searchBarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().offset(-6)
            $0.height.equalTo(10)
        }
    }
    
    private func setupContentLayout() {
        setupCommonContent()
    }
    
    private func setupCommonContent() {
        addChild(feedViewController)
        tabRootView.feedContainerView.addSubview(feedViewController.view)
        
        feedViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        feedViewController.didMove(toParent: self)
        
        
        addChild(marketViewController)
        tabRootView.marketContainerView.addSubview(marketViewController.view)
        
        marketViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        marketViewController.didMove(toParent: self)
    }
}
