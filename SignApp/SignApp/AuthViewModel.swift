//
//  AuthViewModel.swift
//  SignApp
//
//  Created by Hugo Rodrigues on 04/03/25.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore

class AuthViewModel: ObservableObject {
    @Published var user: User?
    
    init() { //: verifica se ha um usuario ja logado no Firebase.
        self.user = Auth.auth().currentUser
    }
    
    //Login com Google
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("Erro ao logar com Google:", error.localizedDescription)
                return
            }

            guard let authentication = result?.user, let idToken = authentication.idToken else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: authentication.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Erro ao autenticar no Firebase:", error.localizedDescription)
                    return
                }
                self.user = result?.user
            }
        }
    }
}
