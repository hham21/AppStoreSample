//
//  AuthService.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/19.
//

import Foundation

enum AuthStatus {
    case signedIn
    case signedOut
}

protocol AuthService {
    var currentStatus: AuthStatus { get }
    
    func signIn()
    func signOut()
}

final class AuthServiceImpl: AuthService {
    enum Const {
        static let didSignIn = "did_Sign_In"
    }
    
    var currentStatus: AuthStatus {
        let didSignIn = UserDefaults.standard.bool(forKey: Const.didSignIn)
        return didSignIn ? .signedIn : .signedOut
    }
    
    func signIn() {
        UserDefaults.standard.setValue(true, forKey: Const.didSignIn)
    }
    
    func signOut() {
        UserDefaults.standard.setValue(false, forKey: Const.didSignIn)
    }
}
