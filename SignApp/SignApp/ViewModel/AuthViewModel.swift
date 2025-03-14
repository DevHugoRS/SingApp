//
//  AuthViewModel.swift
//  SignApp
//
//  Created by Hugo Rodrigues on 11/03/25.
//

import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = true
    
    init() {
        checkAuthentication()
    }
    
    func checkAuthentication() {
        self.isAuthenticated = Auth.auth().currentUser != nil
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            }
        }
    }
    
    func logout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isAuthenticated = false
        }
    }
}
