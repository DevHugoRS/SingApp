//
//  LoginView.swift
//  SignApp
//
//  Created by Hugo Rodrigues on 04/03/25.
//

import SwiftUI
import AuthenticationServices
    
//MARK: - VIEW
struct LoginView: View {
    @State private var navigateToRegister = false
    @State private var showSheet = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
                ZStack {
                    //: BackGround
                    Rectangle()
                        .foregroundStyle(
                            LinearGradient(colors: [.pink, .white, .white], startPoint: .top, endPoint: .bottom)
                        )
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Hello")
                                .font(.system(size: 80, weight: .bold))
                            
                            Text("Sign In to your account")
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, -140)
                        
                        //            MARK: - Email
                        TextField("E-mail Address", text: $viewModel.email)
                            .padding()
                            .background(Color(.systemGray6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 40) //: Forma da Borda
                                    .stroke(Color.black, lineWidth: 3) //:Cor e expessura da Borda
                            )
                            .cornerRadius(40)
                            .padding(.horizontal)
                            .shadow(color: .gray, radius: 10, x: 0, y: 8)
                        
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
                        .shadow(color: .gray, radius: 10, x: 0, y: 8)
                        
                        //: Forgot Your Password
                        HStack {
                            Spacer()
                            HStack {
                                Button("Forgot your Password?") {
                                    showSheet.toggle()
                                }
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.black)
                            } //: HStack
                            .padding(.trailing, 25)
                            .sheet(isPresented: $showSheet, content: {
                                RegisterView()
                            })
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
                        // MARK: - Navegação para outra tela
                        .navigationDestination(isPresented: $viewModel.shouldNavigate) {
                            ContentView()
                                .navigationBarBackButtonHidden(true) //:Remove botão de voltar
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
                    
                } //: ZStack
                .navigationBarBackButtonHidden(true) //:Remove botão de voltar
            } //: Nav.Stack
        }
    }

#Preview {
    LoginView()   
}
