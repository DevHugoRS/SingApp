//
//  HomeView.swift
//  SignApp
//
//  Created by Hugo Rodrigues on 14/03/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    authViewModel.logout()
                }) {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                            .imageScale(.large)
                        Text("Restart")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                    }
                } //: BUTTON
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
            }
            .onReceive(authViewModel.$isAuthenticated) { isAuthenticated in
                if !isAuthenticated {
                    navigateToLogin = true
                }
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel()) // Para garantir a injeção do AuthViewModel
}
