//
//  LoginView.swift
//  SignApp
//
//  Created by Hugo Rodrigues on 04/03/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        VStack(spacing: 20) {
            if authViewModel.user != nil {
                Text("Bem-vindo, \(authViewModel.user?.displayName ?? "Usuário")!")
            } else {
                Button("Entrar com Google") {
                    print("Login com Google pressionado")
                }
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
