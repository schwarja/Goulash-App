//
//  PlacesViewController.swift
//  GoulashClub
//
//  Created by Jan on 31/10/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: Private methods
private extension PlacesViewController {
    func setup() {
        let label = UILabel(frame: CGRect(x: 40, y: 100, width: 50, height: 30))
        label.text = "Hello"
        label.textColor = .red
        view.addSubview(label)
    }
}
