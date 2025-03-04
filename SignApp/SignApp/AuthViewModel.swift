//
//  AuthViewModel.swift
//  SignApp
//
//  Created by Hugo Rodrigues on 04/03/25.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User?
    
    init() { //: verifica se ha um usuario ja logado no Firebase.
        self.user = Auth.auth().currentUser
    }
}
