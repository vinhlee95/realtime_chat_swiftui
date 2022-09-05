//
//  FirebaseManager.swift
//  realtime_chat
//
//  Created by Vinh Le on 5.9.2022.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class FirebaseManager: NSObject {
    // shared singleton
    static let shared = FirebaseManager()
    
    let auth: Auth
    let storage: Storage
    let database: Firestore
    
    // Using private so that consumers can use the singleton only
    private override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.database = Firestore.firestore()
        
        super.init()
    }
}
