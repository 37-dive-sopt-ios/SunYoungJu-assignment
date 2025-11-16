//
//  BannerViewController.swift
//  Baemin
//
//  Created by sun on 11/13/25.
//

import UIKit

import SnapKit
import Then

final class BannerViewController: UIViewController {

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let stackView  = UIStackView()

    // MARK: - Data

    private let imageNames: [String]

    // MARK: - Init

    init(imageNames: [String]) {
        self.imageNames = imageNames
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureImages()
    }

    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        scrollView.do {
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.clipsToBounds = true
        }

        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }

        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 0
        }
    }

    // MARK: - Config

    private func configureImages() {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for name in imageNames {
            let imageView = UIImageView().then {
                $0.image = UIImage(named: name)
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
            }

            stackView.addArrangedSubview(imageView)

            imageView.snp.makeConstraints {
                $0.width.equalTo(scrollView.snp.width)
            }
        }

        view.layoutIfNeeded()
    }
}
