//
//  DataStatus.swift
//  GoulashClub
//
//  Created by Jan on 06/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

enum DataStatus<T, E> {
    case initialized
    case loading
    case error(error: E)
    case ready(data: T)
}
