//
//  RegistrationViewModel.swift
//  TaskSwift
//
//  Created by Phyo Thiengi  on 01/01/2024.
//

import Foundation
import AuthenticationServices

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var username = ""
    
    @MainActor
    func createUser() async throws {
        try await AuthService.shared.createUser(withEmail: email,
                                      password: password,
                                      fullname: fullname,
                                      username: username)
    }
}
