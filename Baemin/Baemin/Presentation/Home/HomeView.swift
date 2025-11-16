//
//  HomeView.swift
//  Baemin
//
//  Created by sun on 11/14/25.
//

import UIKit

import SnapKit
import Then

final class HomeView: UIView {

    // MARK: - UI

    let scrollView = UIScrollView()
    private let contentView = UIView()

    let headerContainerView = UIView()
    let searchBarContainerView = UIView()
    let feedContainerView = UIView()
    let marketContainerView = UIView()
    let bannerContainerView = UIView()
    let listView = ListView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    // MARK: - Layout

    private func setupLayout() {
        backgroundColor = .white

        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }

        contentView.addSubviews(
            headerContainerView,
            searchBarContainerView,
            feedContainerView,
            marketContainerView,
            bannerContainerView,
            listView
        )

        headerContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(34)
        }

        searchBarContainerView.snp.makeConstraints {
            $0.top.equalTo(headerContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(55)
        }

        feedContainerView.snp.makeConstraints {
            $0.top.equalTo(searchBarContainerView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(380)
        }

        marketContainerView.snp.makeConstraints {
            $0.top.equalTo(feedContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }

        bannerContainerView.snp.makeConstraints {
            $0.top.equalTo(marketContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(160)
        }

        listView.snp.makeConstraints {
            $0.top.equalTo(bannerContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1050)
            $0.bottom.equalToSuperview()
        }
    }
}
