//
//  BaeminFeedViewController.swift
//  Baemin
//
//  Created by sun on 11/11/25.
//

import UIKit

import SnapKit
import Then

final class BaeminFeedViewController: BaseViewController,
                                      BaeminFeedMenubarDelegate,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegate,
                                      UICollectionViewDelegateFlowLayout {

    // MARK: - Data
    
    private let topTitles = ["음식배달", "픽업", "장보기·쇼핑", "선물하기", "혜택모아보기"]
    private let categories = BaeminFeed.categories

    // MARK: - UI
    
    private let gradientView = UIView()

    private let bannerContainer = UIView()
    private let bmartRow = UIStackView()
    private let bmartIcon = UIImageView(
        image: UIImage(named: "bmart")?.withRenderingMode(.alwaysOriginal)
    )

    private let promoContentStackView = UIStackView()
    private let promoLabel = UILabel()
    private let promoChevron = UIImageView(
        image: UIImage(named: "chevron-right")?.withRenderingMode(.alwaysOriginal)
    )

    private let topContainer = UIView()
    private let topMintBorder = UIView()
    private lazy var menubar = BaeminFeedMenubar(titles: topTitles)

    private let menuDivider = UIView()

    private let bottomDivider = UIView()
    private let moreButton = UIButton(type: .system)

    private let contentCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addMintGradient(to: gradientView)
    }

    // MARK: - Setup
    
    private func setupUI() {
        view.addSubviews(
            gradientView,
            bannerContainer,
            topContainer,
            menuDivider,
            moreButton,
            bottomDivider,
            contentCollection
        )

        gradientView.isUserInteractionEnabled = false
        gradientView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(140)
        }

        bannerContainer.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(-5)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        bannerContainer.addSubviews(bmartRow, promoContentStackView)

        bmartRow.do {
            $0.configure(
                axis: .horizontal,
                spacing: 0,
                alignment: .center,
                distribution: .fill
            )
        }
        bmartRow.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        bmartIcon.contentMode = .scaleAspectFit
        bmartIcon.snp.remakeConstraints {
            $0.height.equalTo(20)
        }

        let bmartSpacer = UIView().then {
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        bmartRow.addArrangedSubviews(bmartIcon, bmartSpacer)

        promoContentStackView.do {
            $0.configure(
                axis: .horizontal,
                spacing: 2,
                alignment: .center,
                distribution: .fillProportionally
            )
        }
        promoContentStackView.snp.makeConstraints {
            $0.top.equalTo(bmartRow.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        promoLabel.do {
            $0.text = "전상품 쿠폰팩 + 60%특가"
            $0.font = .head_b_16
            $0.textColor = .baeminBlack
            $0.lineBreakMode = .byTruncatingTail
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }

        promoChevron.do {
            $0.contentMode = .scaleAspectFit
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        promoChevron.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }

        promoContentStackView.addArrangedSubviews(promoLabel, promoChevron)

        topContainer.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 0
        }
        topContainer.snp.makeConstraints {
            $0.top.equalTo(promoContentStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        topContainer.addSubviews(topMintBorder, menubar)

        topMintBorder.do {
            $0.backgroundColor = UIColor.baeminMint300.withAlphaComponent(0.5)
        }
        topMintBorder.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }

        menubar.delegate = self
        menubar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }

        view.sendSubviewToBack(gradientView)

        menuDivider.backgroundColor = .baeminGray200
        menuDivider.snp.makeConstraints {
            $0.top.equalTo(topContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }

        moreButton.do {
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = AttributedString(makeMoreTitle())
            configuration.image = UIImage(named: "chevron-right")?.withRenderingMode(.alwaysOriginal)
            configuration.imagePlacement = .trailing
            configuration.imagePadding = 4
            configuration.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

            $0.configuration = configuration
            $0.contentHorizontalAlignment = .center
            $0.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
        }
        moreButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        bottomDivider.backgroundColor = UIColor.baeminBackgroundWhite
        bottomDivider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalTo(moreButton.snp.top)
        }

        contentCollection.dataSource = self
        contentCollection.delegate = self
        contentCollection.register(PageCell.self, forCellWithReuseIdentifier: PageCell.reuseID)
        contentCollection.snp.makeConstraints {
            $0.top.equalTo(menuDivider.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomDivider.snp.top)
        }

        menubar.setSelected(index: 0, animated: false)
    }

    // MARK: - Action
    @objc private func didTapMore() {
        print("더보기 탭")
    }

    // MARK: - Menubar Delegate
    func menubar(didSelect index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        contentCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        topTitles.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PageCell.reuseID,
            for: indexPath
        ) as! PageCell

        if indexPath.item == 0 {
            cell.configureAsCategoryGrid(categories: categories)
            cell.onSelectCategory = { [weak self] _ in
                self?.showEmptyAlert()
            }
        } else {
            cell.configureAsPlaceholder(title: topTitles[indexPath.item])
            cell.onSelectCategory = { [weak self] _ in
                self?.showEmptyAlert()
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }

    // MARK: - Scroll Sync
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == contentCollection else { return }
        let width = scrollView.bounds.width
        guard width > 0 else { return }

        let rawValue = scrollView.contentOffset.x / width
        let fromIndex = Int(floor(rawValue))
        let toIndex = Int(ceil(rawValue))
        let progress = rawValue - CGFloat(fromIndex)

        if fromIndex >= 0, toIndex < topTitles.count {
            menubar.setUnderlineProgress(from: fromIndex, to: toIndex, progress: progress)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        syncMenuSelection(with: scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        syncMenuSelection(with: scrollView)
    }

    private func syncMenuSelection(with scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        let page = Int(round(scrollView.contentOffset.x / width))
        menubar.setSelected(index: page, animated: true)
    }

    private func showEmptyAlert() {
        let alert = UIAlertController(title: nil, message: "아무것도 없지롱", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Helpers
    
    private func addMintGradient(to view: UIView) {
        view.backgroundColor = .baeminBackgroundWhite
        view.layer.sublayers?.filter { $0.name == "mintGradient" }.forEach { $0.removeFromSuperlayer() }

        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "mintGradient"
        gradientLayer.colors = [
            UIColor.baeminMint300.withAlphaComponent(0.0).cgColor,
            UIColor.baeminMint300.withAlphaComponent(0.8).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.2, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.2, y: 1.0)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func makeMoreTitle() -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(
            NSAttributedString(
                string: "음식배달",
                attributes: [
                    .font: UIFont.head_b_14,
                    .foregroundColor: UIColor.baeminBlack,
                    .kern: -0.56
                ]
            )
        )
        attributedString.append(
            NSAttributedString(
                string: "에서 더보기  ",
                attributes: [
                    .font: UIFont.body_r_14,
                    .foregroundColor: UIColor.baeminBlack,
                    .kern: -0.56
                ]
            )
        )
        return attributedString
    }
}

// MARK: - PageCell

private final class PageCell: UICollectionViewCell,
                              UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout {

    // MARK: - Static
    
    static let reuseID = "PageCell"

    // MARK: - Data
    
    private var categories: [BaeminCategory] = []
    var onSelectCategory: ((Int) -> Void)?

    // MARK: - UI
    
    private let gridCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    private let placeholderLabel = UILabel()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubviews(gridCollectionView, placeholderLabel)

        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        gridCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseID)
        gridCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16))
        }

        placeholderLabel.do {
            $0.textAlignment = .center
            $0.textColor = .baeminGray300
            $0.font = .title_sb_18
            $0.isHidden = true
        }
        placeholderLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Config
    
    func configureAsCategoryGrid(categories: [BaeminCategory]) {
        self.categories = categories
        gridCollectionView.isHidden = false
        placeholderLabel.isHidden = true
        gridCollectionView.reloadData()
    }

    func configureAsPlaceholder(title: String) {
        gridCollectionView.isHidden = true
        placeholderLabel.isHidden = false
        placeholderLabel.text = "\(title) 페이지"
    }

    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 5
        let spacing: CGFloat = 12
        let totalSpacing = spacing * (columns - 1)
        let width = floor((collectionView.bounds.width - totalSpacing) / columns)
        let height: CGFloat = 58 + 6 + 18
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCell.reuseID,
            for: indexPath
        ) as! CategoryCell
        let item = categories[indexPath.item]
        cell.configure(title: item.title, image: item.image)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectCategory?(indexPath.item)
    }
}
