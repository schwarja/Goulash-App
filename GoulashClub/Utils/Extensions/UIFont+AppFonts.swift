//
//  UIFont+AppFonts.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 23/12/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

extension UIFont {
    static func appBold(ofSize size: CGFloat) -> UIFont {
        // swiftlint:disable:next force_unwrapping
        return UIFont(name: "SFProDisplay-Bold", size: size)!
    }
    
    static func appSemibold(ofSize size: CGFloat) -> UIFont {
        // swiftlint:disable:next force_unwrapping
        return UIFont(name: "SFProDisplay-Semibold", size: size)!
    }
    
    static func appRegular(ofSize size: CGFloat) -> UIFont {
        // swiftlint:disable:next force_unwrapping
        return UIFont(name: "SFProDisplay-Regular", size: size)!
    }

    static let appTitle = appBold(ofSize: 32)
    static let appSubtitle = appBold(ofSize: 24)
    static let appHeading = appBold(ofSize: 18)
    
    static let appText = appRegular(ofSize: 16)
    static let appTextSmall = appRegular(ofSize: 14)
    
    static let appButton = appSemibold(ofSize: 18)
}
