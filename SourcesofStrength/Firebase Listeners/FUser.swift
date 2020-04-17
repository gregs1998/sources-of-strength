////
////  FUser.swift
////  SourcesofStrength
////
////  Created by Greg Schloemer on 4/9/20.
////  Copyright © 2020 Berea Community Schools. All rights reserved.
////
//
//import Foundation
//import FirebaseAuth
//
//class FUser{
//
//    let id: String
//    var email: String
//    var displayName: String
//    var school: String
//    var grade: String
//    var position: String
//
//    var onBoarding: Bool
//
//    init(_id: String, _email: String, _displayName: String, _school: String, _grade: String, _position: String){
//
//        id = _id
//        email = _email
//        displayName = _displayName
//        school = _school
//        grade = _grade
//        position = _position
//        onBoarding = false
//    }
//
//    init(_ dictionary: NSDictionary){
//
//        id = dictionary[kID] as? String ?? ""
//        email = dictionary[kEMAIL] as? String ?? ""
//        displayName = dictionary[kDISPLAYNAME] as? String ?? ""
//        school = dictionary[kSCHOOL] as? String ?? ""
//        grade = dictionary[kGRADE] as? String ?? ""
//        position = dictionary[kPOSITION] as? String ?? ""
//        onBoarding = dictionary[kONBOARDING] as? Bool ?? false
//    }
//
//    class func currentId() -> String{
//        return Auth.auth().currentUser!.uid
//    }
//
//    class func currentUser() -> FUser?{
//
//        if Auth.auth().currentUser != nil {
//            if let dictionary = userDefaults.object(forKey: kCURRENTUSER){
//                return FUser.init(dictionary as! NSDictionary)
//            }
//        }
//
//        return nil
//    }
//
//    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
//
//        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
//
//            if error == nil {
//                if authDataResult!.user.isEmailVerified{
//
//                    downloadUserFromFirestore(userId: authDataResult!.user.uid, email: email) { (error) in
//
//                        completion(error, true)
//                    }
//                }else{
//                    completion(error, false)
//                }
//            } else{
//                completion(error, false)
//            }
//
//        }
//
//    }
//
//    class func registerUserWith(email: String, password: String, completion: @escaping(_ error: Error?) -> Void){
//        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
//            completion(error)
//            if error == nil{
//                authDataResult!.user.sendEmailVerification { (error) in
//                    print("verification email sent error is: ", error?.localizedDescription)
//
//                }
//            }
//        }
//    }
//}
//
//func downloadUserFromFirestore(userId: String, email: String, completion: @escaping (_ error: Error?) -> Void) {
//    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
//
//        guard let snapshot = snapshot else { return }
//        if snapshot.exists{
//
//            saveUserLocally(userDictionary: snapshot.data()! as NSDictionary)
//
//        } else{
//            let user = FUser(_id: userId, _email: email, _displayName: "", _school: "", _grade: "", _position: "")
//            saveUserLocally(userDictionary: userDictionaryFrom(user: user) as NSDictionary)
//            saveUserToFirestore(fUser: user)
//        }
//
//        completion(error)
//    }
//}
//
//func saveUserToFirestore(fUser: FUser){
//    FirebaseReference(.User).document(fUser.id).setData(userDictionaryFrom(user: fUser)) { (error) in
//        if error != nil {
//            print("Error creating fuser on object: ", error?.localizedDescription)
//        }
//    }
//}
//
//func saveUserLocally(userDictionary: NSDictionary){
//    userDefaults.set(userDictionary, forKey: kCURRENTUSER)
//    userDefaults.synchronize()
//}
//
//func userDictionaryFrom(user: FUser)->[String:Any]{
//
//    return NSDictionary(objects: [user.id,
//                                  user.email,
//                                  user.displayName,
//                                  user.school,
//                                  user.grade,
//                                  user.position,
//                                  user.onBoarding
//                                ],
//                                forKeys: [
//                                    kID as NSCopying,
//                                    kEMAIL as NSCopying,
//                                    kDISPLAYNAME as NSCopying,
//                                    kSCHOOL as NSCopying,
//                                    kGRADE as NSCopying,
//                                    kPOSITION as NSCopying,
//                                    kONBOARDING as NSCopying
//    ]) as! [String: Any]
//
//}
//
//func updateCurrentUser(withValues: [String: Any], completion: @escaping (_ error: Error?) -> Void){
//    if let dictionary = userDefaults.object(forKey: kCURRENTUSER){
//
//        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
//
//        userObject.setValuesForKeys(withValues)
//
//
//        FirebaseReference(.User).document(FUser.currentId()).updateData(withValues) { (error) in
//
//            completion(error)
//            if error == nil{
//                saveUserLocally(userDictionary: userObject)
//            }
//        }
//    }
//}
