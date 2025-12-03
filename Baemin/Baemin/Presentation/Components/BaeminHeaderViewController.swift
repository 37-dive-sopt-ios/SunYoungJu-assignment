//
//  BaeminHeaderViewController.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

import SnapKit
import Then

final class BaeminHeaderViewController: BaseViewController {

    // MARK: - UI

    private let titleLabel = UILabel().then {
        $0.text = "우리집"
        $0.font = .head_b_16
        $0.textColor = .baeminBlack
    }

    private let chevronDownImageView = UIImageView().then {
        $0.image = UIImage(named: "polygon")?.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { $0.size.equalTo(8) }
    }

    private lazy var leftStackView = UIStackView().then {
        $0.addArrangedSubviews(titleLabel, chevronDownImageView)
        $0.configure(axis: .horizontal, spacing: 4, alignment: .center)
    }

    private let promoBadgeView = UIView().then {
        $0.snp.makeConstraints { $0.size.equalTo(24) }

        let percentImageView = UIImageView(
            image: UIImage(named: "percent")?.withRenderingMode(.alwaysOriginal)
        )
        percentImageView.contentMode = .scaleAspectFit

        $0.addSubviews(percentImageView)
        percentImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private let alarmButton = UIButton(type: .system).then {
        let image = UIImage(named: "alarm")?.withRenderingMode(.alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { $0.size.equalTo(24) }
    }

    private let cartButton = UIButton(type: .system).then {
        let image = UIImage(named: "cart")?.withRenderingMode(.alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { $0.size.equalTo(24) }
    }

    private lazy var rightStackView = UIStackView().then {
        $0.addArrangedSubviews(promoBadgeView, alarmButton, cartButton)
        $0.configure(axis: .horizontal, spacing: 12, alignment: .center)
    }

    private let headerView = UIView()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.backgroundColor = .baeminBackgroundWhite
        
        setupLayout()
    }

    // MARK: - Layout
    
    private func setupLayout() {
        view.addSubviews(headerView)
        headerView.addSubviews(leftStackView, rightStackView)

        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(34)
        }

        leftStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        rightStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
