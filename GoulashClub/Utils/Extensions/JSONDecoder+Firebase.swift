//
//  JSONDecoder+Firebase.swift
//  GoulashClub
//
//  Created by Jan on 18/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation
import Firebase

extension JSONDecoder {
    func decode<T: Decodable>(snapshot: QuerySnapshot) throws -> [T] {
        return try snapshot.documents.map({ try self.decode(document: $0) })
    }
    
    func decode<T: Decodable>(document: QueryDocumentSnapshot) throws -> T {
        var json = document.data()
        json[Constants.Firebase.defaultIdAttributeName] = document.documentID
        
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        let object = try self.decode(T.self, from: data)
        
        return object
    }
}
