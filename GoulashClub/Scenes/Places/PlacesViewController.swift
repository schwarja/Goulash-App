//
//  PlacesViewController.swift
//  GoulashClub
//
//  Created by Jan on 31/10/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController {
    private var tableView: UITableView!
    
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
        tableView = UITableView(frame: .zero, style: .plain)
        view.addSubview(tableView)
        tableView.attachToSuperview(useSafeArea: false)
    }
}
