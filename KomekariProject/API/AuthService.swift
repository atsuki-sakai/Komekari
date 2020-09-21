//
//  AuthService.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/09/03.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase
import UIKit

struct AuthCredential {
    
    var email: String
    var password: String
}

class AuthService {
    
    static let shared = AuthService()
    
    func signUp(credential: AuthCredential, completion: @escaping(Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: credential.email, password: credential.password) { (result, error) in
            
            if let error = error {
                completion(error)
            }
            guard let result = result else { return }
            result.user.sendEmailVerification(completion: { (error) in
                
                if let error = error {
                    completion(error)
                }
            })
            
            completion(nil)
        }
    }
    
    func resetPassword(email: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if let error = error {
                completion(error)
            }
        }
    }
    
    func resendValificationEmail(email: String, completion: @escaping(Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            if let error = error {
                completion(error)
            }
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                if let error = error {
                    completion(error)
                }
                completion(nil)
            })
        })
    }
    
    func signOut(completion: @escaping(Error?) -> Void) {
        
        do{
            try Auth.auth().signOut()
            completion(nil)
            
        }catch{
            let error = CustomError.logOut
           completion(error)
        }
    }
    
    func login(credential: AuthCredential, completion: @escaping(Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: credential.email, password: credential.password) { (result, error) in
            
            if let error = error {
                completion(error)
            }
            guard let result = result else { return }
            if result.user.isEmailVerified {
                completion(nil)
            }else{
                let error = CustomError.emailValid
                completion(error)
            }
        }
    }
    
    static func currentnUid() -> String?{
        return Auth.auth().currentUser?.uid
    }
    
    func fetchUser(uid:String, completion: @escaping(User) -> Void){
        
        KUSER_DB_REF.child(uid).observeSingleEvent(of: .value) { (snapShot) in
            guard let dictionary = snapShot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func saveUser(user: User, completion: @escaping(Error?) -> Void) {
    
        let values = [
            "uid": user.id as String,
            "email": user.email as String,
            "userName": user.userName as String,
            "icon": user.icon as Any,
            "createdAt": user.createdAt as String,
            "accountType": user.accountType.rawValue as Int
        ] as [String: Any]
        KUSER_DB_REF.child(user.id).updateChildValues(values) { (error, ref) in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
        
    }

}
