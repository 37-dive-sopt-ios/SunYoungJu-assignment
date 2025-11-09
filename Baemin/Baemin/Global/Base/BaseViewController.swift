//
//  BaseViewController.swift
//  Baemin
//
//  Created by sun on 10/27/25.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUI()
        setLayout()
        setAction()
        setDelegate()
        hideKeyboardWhenDidTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK: - Setup Methods
    
    /// UI 요소 생성 및 구성
    func setUI() {}
    
    /// 오토레이아웃 설정
    func setLayout() {}
    
    /// 버튼 등 액션 연결
    func setAction() {}
    
    /// Delegate, DataSource 설정
    func setDelegate() {}

    // MARK: - Keyboard Dismiss
    
    func hideKeyboardWhenDidTap() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
}
