//
//  RegisterView.swift
//  SignApp
//
//  Created by Hugo Rodrigues on 09/03/25.
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
                }
            }
            self.showAlert = true
        }
    }
}

//MARK: - VIEW
struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing:  20) {
            
            //: Fist Name
            TextField("Nome", text: $viewModel.firstName)
                .padding()
                .background(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 40) //: Forma da Borda
                        .stroke(Color.black, lineWidth: 3) //:Cor e expessura da Borda
                )
                .cornerRadius(40)
                .padding(.horizontal)
            
            //: Last Name
            TextField("Sobrenome", text: $viewModel.lastName)
                .padding()
                .background(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 40) //: Forma da Borda
                        .stroke(Color.black, lineWidth: 3) //:Cor e expessura da Borda
                )
                .cornerRadius(40)
                .padding(.horizontal)
            
            //: E-mail
            TextField("E-mail", text: $viewModel.email)
                .padding()
                .background(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 40) //: Forma da Borda
                        .stroke(Color.black, lineWidth: 3) //:Cor e expessura da Borda
                )
                .cornerRadius(40)
                .padding(.horizontal)
            
            //: Password
            TextField("Senha", text: $viewModel.password)
                .padding()
                .background(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 40) //: Forma da Borda
                        .stroke(Color.black, lineWidth: 3) //:Cor e expessura da Borda
                )
                .cornerRadius(40)
                .padding(.horizontal)
            
            Button(action: {
                viewModel.registerWithEmail(authViewModel: authViewModel)
            }) {
                Text("Cadastrar")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(40)
                    .padding(.horizontal, 100)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Atenção"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            
        } //: VStack
        .padding()
    }
}

#Preview {
    RegisterView()
}
