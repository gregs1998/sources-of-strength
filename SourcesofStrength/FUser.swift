//
//  FUser.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 5/19/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import Foundation
import Firebase
import SwiftUI

class FUser: ObservableObject {
    
    var uid: String = "ABC"
    var displayName: String = "ERROR"
    var grade: String = "0"
    var school: String = "BEREA"
    @Published var goalMax: Int = 5
    
    var onboarding: Bool = false
    
    func getFUserFromFirebase(uid: String, completion: @escaping ()-> Void){
        if(self.uid != ""){
            FirebaseReference(.FUser).document(uid).getDocument { (snapshot, error) in
                guard let snapshot = snapshot else { return }
                
                if snapshot.exists{
                    let data = snapshot.data()
                    self.uid = data![kID] as! String
                    self.displayName = data![kDISPLAYNAME] as! String
                    self.grade = data![kGRADE] as! String
                    self.school = data![kSCHOOL] as! String
                    self.goalMax = data![kGOALMAX] as! Int
                    
                    self.onboarding = data![kONBOARDING] as! Bool
                }
                else{
                    self.uid = uid
                }
                completion()
            }
        }
    }
    
    func setFUserInFirebase(){
        FirebaseReference(.FUser).document(self.uid).setData([kID: self.uid,
                                                              kDISPLAYNAME: self.displayName,
                                                              kGRADE: self.grade,
                                                              kSCHOOL: self.school,
                                                              kGOALMAX: self.goalMax,
                                                              kONBOARDING: self.onboarding])
    }
}
