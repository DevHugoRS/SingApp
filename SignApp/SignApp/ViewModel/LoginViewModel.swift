//
//  LoginViewModel.swift
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

// MARK: - VIEWMODEL
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isSecure: Bool = true
    @Published var shouldNavigate = false
    
    // Login com email.
    func loginWithEmail() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Preencha todos os campos."
            showAlert = true
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                } else {
                    self.alertMessage = "Login bem-sucedido!"
                    self.shouldNavigate = true
                }
            }
        }
    }
    
    // - Login com Google conta
    func loginWithGoogle() {
        guard (FirebaseApp.app()?.options.clientID) != nil else { return }
        
        guard let topViewController = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?
            .rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: topViewController) { signInResult, error in
            guard let signInResult = signInResult else {
                self.alertMessage = error?.localizedDescription ?? "Erro desconhecido"
                self.showAlert = true
                return
            }
            
            let user = signInResult.user
            guard let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.alertMessage = error.localizedDescription
                        self.showAlert = true
                    } else {
                        self.alertMessage = "Login com Google bem-sucedido!"
                        self.shouldNavigate = true
                    }
                }
            }
        }
    }
    
    //- Login com conta Apple
    func handleAppleSignIn(_ authResults: ASAuthorization) {
        guard let credential = authResults.credential as? ASAuthorizationAppleIDCredential else { return }
        
        let appleIDToken = credential.identityToken
        let appleIDTokenString = String(data: appleIDToken ?? Data(), encoding: .utf8)
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: appleIDTokenString ?? "", rawNonce: "")
        
        Auth.auth().signIn(with: firebaseCredential) { result, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
            } else {
                self.alertMessage = "Login com Apple bem-sucedido!"
            }
            self.showAlert = true
        }
    }
}
