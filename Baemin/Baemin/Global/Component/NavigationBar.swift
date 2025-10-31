//
//  NavigationBar.swift
//  Baemin
//
//  Created by sun on 10/31/25.
//

import UIKit

import SnapKit
import Then

final class NavigationBar: UIView {

    private let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let leftWrap = UIView()
    private let rightWrap = UIView()

    var onTapBack: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupLayout()
    }

    // MARK: - UI
    
    private func setupUI() {
        backgroundColor = .systemBackground

        backButton.do {
            $0.setImage(UIImage(named: "arrow-left"), for: .normal)
            $0.tintColor = UIColor(named: "baemin-black") ?? .label
            $0.contentMode = .scaleAspectFit
            $0.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        }

        titleLabel.setText(
            " ",
            style: .title_sb_18,
            color: UIColor(named: "baemin-black") ?? .label,
            isSingleLine: true,
            alignment: .center
        )
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 8
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }

        addSubview(stackView)
        stackView.addArrangedSubviews(leftWrap, titleLabel, rightWrap)

        leftWrap.addSubview(backButton)
    }

    // MARK: - Layout
    
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        rightWrap.snp.makeConstraints { make in
            make.width.equalTo(leftWrap.snp.width)
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(36)
        }
    }

    // MARK: - Public
    
    func setTitle(_ text: String) {
        titleLabel.setText(
            text,
            style: .title_sb_18,
            color: UIColor(named: "baemin-black") ?? .label,
            isSingleLine: true,
            alignment: .center
        )
    }

    // MARK: - Action
    
    @objc private func didTapBack() { onTapBack?() }
}
