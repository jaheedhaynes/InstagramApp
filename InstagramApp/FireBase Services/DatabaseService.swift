//
//  DatabaseService.swift
//  InstagramApp
//
//  Created by Jaheed Haynes on 3/7/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class DatabaseService {
   
    static let imageCollection = "images" 
    
    private let db = Firestore.firestore()
 
    
    public func createPhoto(photoName: String, userPostedName: String, completion: @escaping (Result<String, Error>) -> ()) {
       
        
        guard let user = Auth.auth().currentUser else { return }
        
       
        let documentRef = db.collection(DatabaseService.imageCollection).document()
        
        db.collection(DatabaseService.imageCollection).document(documentRef.documentID).setData(["photoName":photoName, "photoId":documentRef.documentID, "listedDate":Timestamp(date: Date()), "userPostedName":userPostedName, "userPostImage":user.uid]) {
            (error) in
            if let error = error {
               // print("error creating item: \(error)")
                completion(.failure(error))
            } else {
               // print("item was created \(documentRef.documentID)")
                completion(.success(documentRef.documentID))
            }
        }
    }
}
