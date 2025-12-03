//
//  WelcomeViewModel.swift
//  Baemin
//
//  Created by sun on 12/3/25.
//

import Foundation

import Combine

final class WelcomeViewModel {

    // MARK: - Input

    @Published var email: String

    // MARK: - Output

    @Published private(set) var titleText: String = "환영합니다"
    @Published private(set) var subtitleText: String = "반가워요!"

    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(email: String) {
        self.email = email

        $email
            .map { email in
                email.isEmpty ? "반가워요!" : "\(email)님 반가워요!"
            }
            .assign(to: &$subtitleText)
    }
}
