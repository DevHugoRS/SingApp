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
    
//MARK: - VIEW
struct LoginView: View {
    @State private var navigateToRegister = false
    @State private var showSheet = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
            NavigationView {
                ZStack {
                    //: BackGround
                    Rectangle()
                        .foregroundStyle(
                            LinearGradient(colors: [.pink, .white, .white], startPoint: .top, endPoint: .bottom)
                        )
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        
                        VStack(alignment: .leading) {
                            Text("Hello")
                                .font(.system(size: 80, weight: .bold))
                            
                            Text("Sign In to your account")
                                .foregroundColor(.gray)
                        }
                        .offset(x: -70, y: 0)
                        
                        
                        
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
                        
                        HStack {
                            if viewModel.isSecure {
                                SecureField("Password", text: $viewModel.password)
                            } else {
                                TextField("Password", text: $viewModel.password)
                            }
                            Button(action: { viewModel.isSecure.toggle()}) {
                                Image(systemName: viewModel.isSecure ? "eye.slash" : "eye")
                            }
                            .foregroundColor(.gray)
                            
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 40) //: Forma da Borda
                                .stroke(Color.black, lineWidth: 3) //:Cor e expessura da Borda
                        )
                        .cornerRadius(40)
                        .padding(.horizontal)
                        
                        HStack {
                            Spacer()
                            Text("Forgot your Password?")
                                .foregroundColor(.gray)
                                .font(.footnote)
                                .padding(.trailing, 25)
                        }
                        
                        //            MARK: - Button Login
                        Button(action: {
                            viewModel.loginWithEmail()
                        }) {
                            Text("Sign In")
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
                        .padding(.bottom, 10)
                        
                        HStack {
                            //            MARK: - Login Google
                            
                            Button(action: {
                                viewModel.loginWithGoogle()
                            }) {
                                Image("google")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                            }
                            .padding()
                            
                            //            MARK: - Login Apple
                            
                            Button(action: {
                                let request = ASAuthorizationAppleIDProvider().createRequest()
                                request.requestedScopes = [.fullName, .email]
                                
                                let controller = ASAuthorizationController(authorizationRequests: [request])
                                controller.performRequests()
                            }) {
                                Image(systemName: "apple.logo")
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                                    .frame(width: 50, height: 50) // Tamanho do ícone
                                    .foregroundColor(.foreground) // Cor da logo
                                    .background(Circle().fill(.colorBack))
                                
                            }
                            .padding()
                            
                        } //: HStack
                        
                        NavigationLink(destination: ContentView(), isActive: $viewModel.shouldNavigate) {
                            EmptyView()
                        }
                        
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.black)
                            Button("Create") {
                                showSheet.toggle()
                            }
                            .bold()
                        } //: HStack
                        .padding()
                        .sheet(isPresented: $showSheet, content: {
                            RegisterView()
                        })
                        
                        
                    }
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text("Atenção"),
                              message: Text(viewModel.alertMessage),
                              dismissButton: .default(Text("OK"))
                        )
                    }//:VStack
                    .padding()
                }
            } //: Nav.View
        }
    }

#Preview {
    LoginView()
        
}
