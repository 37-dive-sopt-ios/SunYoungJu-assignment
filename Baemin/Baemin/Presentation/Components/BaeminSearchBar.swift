
//
// BaeminSearchBar.swift
// Baemin
//
// Created by sun on 11/10/25.
//

import UIKit

import SnapKit
import Then

final class BaeminSearchBar: UIControl {
    private let textField = UITextField()
    private let iconButton = UIButton(type: .system)
    private let contentStack = UIStackView()

    struct Style {
        static let borderWidth: CGFloat = 1
        static let background = UIColor.baeminWhite
        static let border = UIColor.baeminBlack
        static let placeholder = UIColor.baeminGray300
        static let text = UIColor.baeminBlack
        static let iconTint = UIColor.baeminGray700
        static let font: UIFont = .body_r_14
        static let kern: CGFloat = -0.56
        static let lineHeightMultiple: CGFloat = 0.84
        static let horizontalPadding: CGFloat = 16
        static let spacing: CGFloat = 8
        static let iconSize: CGFloat = 18
    }

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    var onSearch: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
    }

    private func setupUI() {
        layer.do {
            $0.borderWidth = Style.borderWidth
            $0.borderColor = Style.border.cgColor
            $0.masksToBounds = true
        }

        backgroundColor = .baeminWhite

        contentStack.do {
            $0.configure(
                axis: .horizontal,
                spacing: Style.spacing,
                alignment: .center,
                distribution: .fill
            )
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = .init(
                top: 0,
                left: Style.horizontalPadding,
                bottom: 0,
                right: Style.horizontalPadding
            )
        }

        textField.do {
            $0.borderStyle = .none
            $0.backgroundColor = .clear
            $0.textColor = Style.text
            $0.font = Style.font
            $0.clearButtonMode = .never
            $0.returnKeyType = .search
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            $0.attributedPlaceholder = Self.makePlaceholder("찾아라! 맛있는 음식과 맛집")
            $0.addRightPadding(8)
        }

        iconButton.do {
            let image = UIImage(named: "search") ?? UIImage(systemName: "magnifyingglass")
            $0.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = Style.iconTint
            $0.imageView?.contentMode = .scaleAspectFit
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        addSubview(contentStack)
        contentStack.addArrangedSubviews(textField, iconButton)

        contentStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        iconButton.snp.makeConstraints {
            $0.width.height.equalTo(max(Style.iconSize, 24))
        }
    }

    private func setupActions() {
        textField.delegate = self
        iconButton.addTarget(self, action: #selector(didTapIcon), for: .touchUpInside)
    }

    @objc private func didTapIcon() {
        onSearch?(textField.text ?? "")
        sendActions(for: .primaryActionTriggered)
    }

    private static func makePlaceholder(_ text: String) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = Style.lineHeightMultiple
        return NSAttributedString(
            string: text,
            attributes: [
                .font: Style.font,
                .foregroundColor: Style.placeholder,
                .kern: Style.kern,
                .paragraphStyle: paragraph
            ]
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

extension BaeminSearchBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapIcon()
        return true
    }
}
