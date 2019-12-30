//
//  StorageManager.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 30/12/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage()
    
    func getDownloadUrl(for resource: String, completion: @escaping (URL?) -> Void) {
        let ref = storage.reference(forURL: resource)
        
        ref.downloadURL { (url, _) in
            completion(url)
        }
    }
}
