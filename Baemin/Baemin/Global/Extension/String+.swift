//
//  String+.swift
//  Baemin
//
//  Created by sun on 10/31/25.
//

import Foundation

enum Validator {

    private static let emailRegex = try! NSRegularExpression(
        pattern: #"^[A-Z0-9a-z._%+-]+@([A-Za-z0-9-]+\.)+[A-Za-z]{2,}$"#
    )

    private static let passwordRegex = try! NSRegularExpression(
        pattern: #"^(?=.*[!_@$%^&+=])[A-Za-z0-9!_@$%^&+=]{8,12}$"#
    )

    static func isValidEmail(_ email: String) -> Bool {
        let range = NSRange(email.startIndex..., in: email)
        return emailRegex.firstMatch(in: email, range: range) != nil
    }

    static func isValidPassword(_ password: String) -> Bool {
        let range = NSRange(password.startIndex..., in: password)
        return passwordRegex.firstMatch(in: password, range: range) != nil
    }
}

