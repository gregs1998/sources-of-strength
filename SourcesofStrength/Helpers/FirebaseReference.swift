//
//  FirebaseReference.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/9/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Activity
    case LoggedActivity
    case Goals
    case FUser
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference{
    
    
    
    return Firestore.firestore().collection(collectionReference.rawValue)
    
}
