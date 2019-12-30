//
//  Place.swift
//  GoulashClub
//
//  Created by Jan on 06/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

struct Place: Decodable {
    let id: String
    let name: String
    let description: String
    let address: String
    let imageStorageUrl: String?
}
