//
//  AuthService.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/09/03.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    static let shared = AuthService()
    
    func signUp(email: String, pass: String, completion: @escaping(Error?) -> Void) {
        
        if !Reachabilty.HasConnection() {
            let error = CustomError.notConnection
            completion(error)
        }
        Auth.auth().createUser(withEmail: email, password: pass) { (result, error) in
            
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
        
        if !Reachabilty.HasConnection() {
            let error = CustomError.notConnection
            completion(error)
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if let error = error {
                completion(error)
            }
        }
    }
    
    func resendValificationEmail(email: String, completion: @escaping(Error?) -> Void) {
        
        if !Reachabilty.HasConnection() {
            let error = CustomError.notConnection
            completion(error)
        }
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
        
        if !Reachabilty.HasConnection() {
            let error = CustomError.notConnection
            completion(error)
        }
        do{
            UserDefaults.standard.removeObject(forKey: kUserLocalData)
            try Auth.auth().signOut()
            completion(nil)
            
        }catch{
            let error = CustomError.logOut
           completion(error)
        }
    }
    
    func login(email: String, pass: String, completion: @escaping(Error?) -> Void) {
        
        if !Reachabilty.HasConnection() {
            let error = CustomError.notConnection
            completion(error)
        }
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            
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
    
    func saveUser(user: User, completion: @escaping(Error?) -> Void) {
    
        if !Reachabilty.HasConnection() {
            let error = CustomError.notConnection
            completion(error)
        }
        FirebaseCollectionRef(.User).document(user.id).setData(userDictionaryFrom(user: user) as! [String : Any]) { (error) in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }
    
    func fetchUser(uid:String, completion: @escaping(_ error: Error?,_ user: User?) -> Void) {
        
        kUser_Reference.document(uid).getDocument { (snapShot, error) in
            if let error = error {
                completion(error, nil)
            }
            guard let snapShot = snapShot else { return }
            if snapShot.exists {
                let user = User(_dictionary: snapShot.data()! as NSDictionary)
                completion(nil,user)
            }else{
                completion(nil, nil)
            }
        }
    }
}
