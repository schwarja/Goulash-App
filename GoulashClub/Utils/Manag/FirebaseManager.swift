//
//  FirebaseManager.swift
//  GoulashClub
//
//  Created by Jan on 06/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    let database = Firestore.firestore()
    
    private(set) var places: DataStatus<Place, Error> = .initialized
    
    func startListeningToPlaces() {
        database.collection("places").getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            } else if let err = error {
                print("Error getting documents: \(err)")
            } else {
                print("Unknown error")
            }
        }
    }
}
