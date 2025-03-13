//
//  RegisterView.swift
//  SignApp
//
//  Created by Hugo Rodrigues on 09/03/25.
//

import SwiftUI
import AuthenticationServices

//MARK: - VIEW
struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var profileImage: UIImage?
    @State private var isShowingImagePicker = false
    
    var body: some View {
        ZStack {
            //: BackGround
            Rectangle()
                .foregroundStyle(
                    LinearGradient(colors: [.pink, .white, .white], startPoint: .top, endPoint: .bottom)
                )
                .ignoresSafeArea()
            
            VStack(spacing:  20) {
                //: Foto de Perfil
                Button(action: {
                    isShowingImagePicker = true
                }) {
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 3))
                    } else {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.white, .secondary)
                        
                    }
                }
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(image: $profileImage)
                }
                
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
                
                //: Botão Cadastrar
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
                .padding()
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Atenção"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
                
                //: Navegação para tela principal
                NavigationLink(destination: ContentView(), isActive: $viewModel.isRegistered) {
                    EmptyView()
                }
                .hidden()
                
            } //: VStack
            .padding()
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel())
}
