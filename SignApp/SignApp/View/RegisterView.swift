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
    @State private var isTermsAccepted = false
    
    var body: some View {
        NavigationStack {
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
                    
                    //: Campos de Entrada
                    Group {
                        TextField("Fist Name", text: $viewModel.firstName)
                        TextField("Last Name", text: $viewModel.lastName)
                        TextField("E-mail Address", text: $viewModel.email)
                        SecureField("Password", text: $viewModel.password)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .cornerRadius(40)
                    .padding(.horizontal)
                    .shadow(color: .gray, radius: 10, x: 0, y: 8)
                    
                    //: Checkbox - Aceitar Termos
                    Toggle(isOn: $isTermsAccepted) {
                        Text("I accept all terms and conditions.")
                            .fontDesign(.none)
                            .foregroundColor(.black)
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .padding(.horizontal)
                    
                    
                    //: Botão Cadastrar
                    Button(action: {
                        viewModel.registerWithEmail(authViewModel: authViewModel)
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
                    .padding()
                    .disabled(!isTermsAccepted) // Desativa o botão se o checkbox não estiver marcado
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text("Atenção"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    
                    //MARK: - Navegação para tela principal
                    .navigationDestination(isPresented: $viewModel.isRegistered) {
                        ContentView()
                            .navigationBarBackButtonHidden(true)
                    }
                } //: VStack
                .padding()
            } //: ZStack
            .navigationBarBackButtonHidden(true)
        } //: NavigationStack
    }
}

//MARK: - Estilo Customizado para Checkbox
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(configuration.isOn ? .blue : .gray)
                    .padding(.leading, -35)
                
                
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel())
}
