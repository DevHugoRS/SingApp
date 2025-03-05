//
//  LoginView.swift
//  SignApp
//
//  Created by Hugo Rodrigues on 04/03/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

// MARK: - ViewModel
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    // Login com email.
    func loginWithEmail() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Preencha todos os campos."
            showAlert = true
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
            } else {
                self.alertMessage = "Login bem-sucedido!"
            }
            self.showAlert = true
        }
    }
    
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
                if let error = error {
                    self.alertMessage = error.localizedDescription
                } else {
                    self.alertMessage = "Login com Google bem-sucedido!"
                }
                self.showAlert = true
            }
        }
    }
    
}

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 20) {
            
//            MARK: - Email
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 40) //: Forma da Borda
                        .stroke(Color.black, lineWidth: 3) //:Cor e expessura da Borda
                )
                .cornerRadius(40)
                .padding(.horizontal)
            
//            MARK: - Senha
            SecureField("Senha", text: $viewModel.password)
                .padding()
                .background(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 40) //: Forma da Borda
                        .stroke(Color.black, lineWidth: 3) //:Cor e expessura da Borda
                )
                .cornerRadius(40)
                .padding(.horizontal)
            
//            MARK: - Button Login
            Button("Login") {
                viewModel.loginWithEmail()
            }
            .frame(width: 100, height: 50)
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(40)
            .padding(.horizontal)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Atenção"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            
//            MARK: - Login Google
            
            Button("Login com Google") {
                viewModel.loginWithGoogle()
            }
            
            
        
        } //:VStack
        .padding()
    }
}

#Preview {
    LoginView()
}
