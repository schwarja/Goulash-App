//
//  UIColor+AppColors.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 23/12/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

extension UIColor {
    static var appBackground: UIColor {
        // swiftlint:disable:next force_unwrapping
        return UIColor(named: "BackgroundColor")!
    }

    static var appBackgroundAccented: UIColor {
        // swiftlint:disable:next force_unwrapping
        return UIColor(named: "BackgroundAccentColor")!
    }

    static var appText: UIColor {
        // swiftlint:disable:next force_unwrapping
        return UIColor(named: "TextColor")!
    }

    static var appTextDimmed: UIColor {
        // swiftlint:disable:next force_unwrapping
        return UIColor(named: "SeparatorColor")!
    }

    static var appSeparator: UIColor {
        // swiftlint:disable:next force_unwrapping
        return UIColor(named: "SeparatorColor")!
    }

    static var appTint: UIColor {
        // swiftlint:disable:next force_unwrapping
        return UIColor(named: "TintColor")!
    }
}
