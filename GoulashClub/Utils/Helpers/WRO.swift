//
//  WRO.swift
//  GoulashClub
//
//  Created by Jan on 18/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

class WRO<T: AnyObject> where T: Hashable {
    private(set) weak var object: T?
    
    init(object: T) {
        self.object = object
    }
}

extension WRO: Hashable {
    static func == (lhs: WRO<T>, rhs: WRO<T>) -> Bool {
        return lhs.object == rhs.object
    }

    func hash(into hasher: inout Hasher) {
        object?.hash(into: &hasher)
    }
}
