//
//  NibNameIdentifiable.swift
//  STRV Project template
//
//  Created by Jan Kaltoun on 28/12/2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import UIKit

public protocol NibNameIdentifiable {}

public extension NibNameIdentifiable where Self: UIView {
    static var identifier: String {
        String(describing: Self.self)
    }
}
