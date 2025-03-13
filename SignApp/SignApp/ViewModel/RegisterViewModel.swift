//
//  RegisterViewModel.swift
//  SignApp
//
//  Created by Hugo Rodrigues on 13/03/25.
//
import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import AuthenticationServices

//MARK: - VIEWMODEL
class RegisterViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isRegistered = false
    
    func registerWithEmail(authViewModel: AuthViewModel) {
        guard !email.isEmpty, !password.isEmpty, !firstName.isEmpty, !lastName.isEmpty else {
            alertMessage = "Preencha todos os campos."
            showAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
            } else {
                self.alertMessage = "Cadastro bem-sucedido!"
                DispatchQueue.main.async {
                    authViewModel.isAuthenticated = true
                    self.isRegistered = true
                }
            }
            self.showAlert = true
        }
    }
}
