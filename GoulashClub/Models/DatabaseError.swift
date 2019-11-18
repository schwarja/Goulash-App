//
//  DatabaseError.swift
//  GoulashClub
//
//  Created by Jan on 18/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

enum DatabaseError: Error {
    case serialization(error: Error)
    case `internal`(error: Error)
    case unknown
}
