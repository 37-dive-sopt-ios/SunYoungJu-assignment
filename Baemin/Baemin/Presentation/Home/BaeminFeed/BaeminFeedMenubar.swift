//
//  BaeminFeedMenubar.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

import SnapKit
import Then

protocol BaeminFeedMenubarDelegate: AnyObject {
    func menubar(didSelect index: Int)
}

final class BaeminFeedMenubar: UIView {

    // MARK: - Public

    weak var delegate: BaeminFeedMenubarDelegate?

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let underline = UIView()

    // MARK: - State

    private let titles: [String]
    private var buttons: [UIButton] = []
    private(set) var selectedIndex: Int = 0

    private var underlineLeading: Constraint?
    private var underlineWidth: Constraint?

    // MARK: - Init

    init(titles: [String] = ["음식배달","픽업","장보기·쇼핑","선물하기","혜택모아"]) {
        self.titles = titles
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .clear

        addSubview(scrollView)
        scrollView.do {
            $0.showsHorizontalScrollIndicator = false
            $0.contentInsetAdjustmentBehavior = .never
            $0.backgroundColor = .clear
        }
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }

        scrollView.addSubview(stackView)
        stackView.do {
            $0.configure(
                axis: .horizontal,
                spacing: 24,
                alignment: .center,
                distribution: .fill
            )
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.backgroundColor = .clear
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }

        titles.enumerated().forEach { idx, title in
            let button = UIButton(type: .system).then {
                $0.tag = idx
                $0.setTitle(title, for: .normal)
                $0.setContentHuggingPriority(.required, for: .horizontal)
                $0.setContentCompressionResistancePriority(.required, for: .horizontal)
                $0.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
            }
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        applyButtonStyles()

        addSubview(underline)
        underline.do {
            $0.backgroundColor = .baeminBlack
            $0.layer.cornerRadius = 1.5
        }
        underline.snp.makeConstraints {
            underlineLeading = $0.leading.equalToSuperview().constraint
            $0.bottom.equalToSuperview()
            underlineWidth = $0.width.equalTo(0).constraint
            $0.height.equalTo(3)
        }

        DispatchQueue.main.async { [weak self] in
            self?.setSelected(index: 0, animated: false)
        }
    }

    private func applyButtonStyles() {
        for (i, button) in buttons.enumerated() {
            if i == selectedIndex {
                button.setTitleColor(.baeminBlack, for: .normal)
                button.titleLabel?.font = .head_b_18
            } else {
                button.setTitleColor(.baeminGray300, for: .normal)
                button.titleLabel?.font = .title_sb_18
            }
        }
    }

    // MARK: - Actions

    @objc private func tap(_ sender: UIButton) {
        setSelected(index: sender.tag, animated: true)
        delegate?.menubar(didSelect: sender.tag)
    }

    // MARK: - Public API

    func setSelected(index: Int, animated: Bool) {
        guard index >= 0 && index < buttons.count else { return }
        selectedIndex = index
        applyButtonStyles()

        let button = buttons[index]
        let frame = convert(button.frame, from: stackView)
        underlineLeading?.update(offset: frame.minX)
        underlineWidth?.update(offset: frame.width)

        if animated {
            UIView.animate(withDuration: 0.22, delay: 0, options: .curveEaseInOut) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }

        scrollView.scrollRectToVisible(frame.insetBy(dx: -16, dy: 0), animated: animated)
    }

    func setUnderlineProgress(from: Int, to: Int, progress: CGFloat) {
        guard buttons.indices.contains(from), buttons.indices.contains(to) else { return }
        let fromFrame = convert(buttons[from].frame, from: stackView)
        let toFrame = convert(buttons[to].frame, from: stackView)

        let x = fromFrame.minX + (toFrame.minX - fromFrame.minX) * progress
        let w = fromFrame.width + (toFrame.width - fromFrame.width) * progress

        underlineLeading?.update(offset: x)
        underlineWidth?.update(offset: w)
        layoutIfNeeded()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
