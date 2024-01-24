//
//  LoginViewModel.swift
//  TaskSwift
//
//  Created by Phyo Thiengi  on 01/01/2024.
//

import Foundation
import AuthenticationServices

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
  
    
    @MainActor
    func login() async throws {
        try await AuthService.shared.login(withEmail: email,
                                      password: password)
    }
}
