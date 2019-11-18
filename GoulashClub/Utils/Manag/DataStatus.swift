//
//  DataStatus.swift
//  GoulashClub
//
//  Created by Jan on 06/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

enum DataStatus<T> {
    case initial
    case loading
    case error(error: Error)
    case ready(data: T)
}
