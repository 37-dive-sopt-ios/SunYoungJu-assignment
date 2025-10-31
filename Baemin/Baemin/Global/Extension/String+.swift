//
//  String+.swift
//  Baemin
//
//  Created by sun on 10/31/25.
//

import Foundation

extension String {

    var isValidEmail: Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@([A-Za-z0-9-]+\.)+[A-Za-z]{2,}$"#
        return self.range(of: pattern, options: .regularExpression) != nil
    }

    var isValidPassword: Bool {
        let pattern = #"^(?=.*[!_@$%^&+=])[A-Za-z0-9!_@$%^&+=]{8,12}$"#
        return self.range(of: pattern, options: .regularExpression) != nil
    }
}
