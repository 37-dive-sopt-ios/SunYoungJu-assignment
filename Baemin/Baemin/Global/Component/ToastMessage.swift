//
//  ToastMessage.swift
//  Baemin
//
//  Created by sun on 10/31/25.
//

import UIKit

import SnapKit
import Then

final class ToastMessage: UIView {

    // MARK: - UI Components
    
    private let messageLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.Pretendard.body_r_14.font
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    // MARK: - Initializer
    
    init(message: String) {
        super.init(frame: .zero)
        configureUI(with: message)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Configuration
    
    private func configureUI(with message: String) {
        backgroundColor = UIColor(named: "baemin-gray-700") ?? UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        layer.cornerRadius = 16
        layer.masksToBounds = true

        addSubview(messageLabel)
        messageLabel.text = message

        messageLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
    }

    // MARK: - Presentation
    
    static func show(in parentView: UIView, message: String) {
        let toastView = ToastMessage(message: message)
        parentView.addSubview(toastView)

        toastView.alpha = 0
        toastView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(parentView.safeAreaLayoutGuide).inset(24)
            $0.width.lessThanOrEqualTo(parentView.snp.width).multipliedBy(0.8)
        }

        UIView.animate(withDuration: 0.25) {
            toastView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 1.5, options: .curveEaseInOut) {
                toastView.alpha = 0
            } completion: { _ in
                toastView.removeFromSuperview()
            }
        }
    }
}
