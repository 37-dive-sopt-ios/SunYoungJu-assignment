//
//  LoginViewModel.swift
//  Baemin
//
//  Created by sun on 12/3/25.
//

import Foundation

import Combine

final class LoginViewModel {

    enum InvalidField {
        case email
        case password
    }

    struct ValidationError {
        let message: String
        let field: InvalidField
    }

    enum Event {
        case showValidationError(ValidationError)
        case navigateToWelcome(email: String)
    }

    // MARK: - Input

    @Published var email: String = ""
    @Published var password: String = ""

    // MARK: - Output

    @Published private(set) var isLoginEnabled: Bool = false
    let event = PassthroughSubject<Event, Never>()

    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        Publishers.CombineLatest($email, $password)
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .removeDuplicates()
            .assign(to: &$isLoginEnabled)
    }

    // MARK: - Public

    func login() {
        let email = email
        let password = password

        guard !email.isEmpty, !password.isEmpty else { return }

        if let error = validateSubmission(email: email, password: password) {
            event.send(.showValidationError(error))
            return
        }

        event.send(.navigateToWelcome(email: email))
    }

    // MARK: - Private

    private func validateSubmission(email: String, password: String) -> ValidationError? {
        if !Validator.isValidEmail(email) {
            return ValidationError(
                message: "이메일 형식이 달라요",
                field: .email
            )
        }
        if !Validator.isValidPassword(password) {
            return ValidationError(
                message: "비밀번호 형식이 달라요",
                field: .password
            )
        }
        return nil
    }
}
