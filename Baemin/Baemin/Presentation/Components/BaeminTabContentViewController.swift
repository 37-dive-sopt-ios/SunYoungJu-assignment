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
    
    private let homeView = HomeView()
    
    private let headerViewController = BaeminHeaderViewController()
    private let searchBarView = BaeminSearchBar()
    private let feedViewController = BaeminFeedViewController()
    private let marketViewController = BaeminMarketViewController()
    
    private let bannerViewController = BannerViewController(
            imageNames: ["banner1", "banner2", "banner3"]
        )
    
    // MARK: - Tab
    
    let kind: BaeminTabKind
    
    // MARK: - List
    
    private let listFactory = MockListSectionFactory()
    private var listData: [ListSection] = []
    
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
        switch kind {
        case .home:
            view = homeView
        case .shopping, .wish, .orders, .my:
            view = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch kind {
        case .home:
            setupHome()
        case .shopping:
            setupPlaceholder(title: "장보기·쇼핑")
        case .wish:
            setupPlaceholder(title: "찜")
        case .orders:
            setupPlaceholder(title: "주문내역")
        case .my:
            setupPlaceholder(title: "마이배민")
        }
    }
    
    // MARK: - Home Layout
    
    private func setupHome() {
        homeView.backgroundColor = .baeminBackgroundWhite
        
        setupHeaderLayout()
        setupSearchBarLayout()
        setupContentLayout()
        setupList()
    }
    
    private func setupHeaderLayout() {
        addChild(headerViewController)
        homeView.headerContainerView.addSubview(headerViewController.view)
        
        headerViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerViewController.didMove(toParent: self)
    }
    
    private func setupSearchBarLayout() {
        homeView.searchBarContainerView.addSubview(searchBarView)
        
        searchBarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().offset(-6)
        }
    }
    
    private func setupContentLayout() {
        setupCommonContent()
        setupBannerLayout()
    }
    
    private func setupCommonContent() {
        addChild(feedViewController)
        homeView.feedContainerView.addSubview(feedViewController.view)
        
        feedViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        feedViewController.didMove(toParent: self)
        
        addChild(marketViewController)
        homeView.marketContainerView.addSubview(marketViewController.view)
        
        marketViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        marketViewController.didMove(toParent: self)
    }
    
    private func setupBannerLayout() {
        addChild(bannerViewController)
        homeView.bannerContainerView.addSubview(bannerViewController.view)

        bannerViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        bannerViewController.didMove(toParent: self)
    }
    
    // MARK: - List Setup
    
    private func setupList() {
        configureListData()
        let collectionView = homeView.listView.collectionView
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.isScrollEnabled = false
        collectionView.reloadData()
    }
    
    private func configureListData() {
        listData = [
            .ranking(listFactory.makeRanking(4)),
            .recent(listFactory.makeRecent(4)),
            .discounted(listFactory.makeDiscounted(4))
        ]
    }
    
    // MARK: - Placeholder Layout
    
    private func setupPlaceholder(title: String) {
        view.backgroundColor = .baeminBackgroundWhite
        
        let label = UILabel()
        label.text = "\(title) 탭"
        label.font = .title_sb_18
        label.textColor = .baeminGray700
        label.textAlignment = .center
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - CollectionView

extension BaeminTabContentViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        listData[section].itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        ListCellFactory.makeCell(
            for: listData[indexPath.section],
            at: indexPath,
            in: collectionView
        )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        SupplementaryViewFactory.make(
            kind: kind,
            at: indexPath,
            in: collectionView,
            sections: listData
        )
    }
}

extension BaeminTabContentViewController: UICollectionViewDelegate {}
