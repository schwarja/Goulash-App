//
//  PlacesViewController.swift
//  GoulashClub
//
//  Created by Jan on 31/10/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController {
    // swiftlint:disable:next implicitly_unwrapped_optional
    private var tableView: UITableView!
    
    private let viewModel: PlacesViewModel
    private weak var coordinator: ListCoordinator?
    
    init(viewModel: PlacesViewModel, coordinator: ListCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: Table View Data Source
extension PlacesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaceCell = tableView.dequeueReusableCell(for: indexPath)
        
        let item = viewModel.item(at: indexPath.row)
        cell.configuare(with: item)
        
        return cell
    }
}

// MARK: Table View Delegate
extension PlacesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath.row)
        
        coordinator?.didSelect(place: item, in: self)
    }
}

// MARK: Table View Drag Delegate
extension PlacesViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let provider = viewModel.dragItemProvider(at: indexPath.row)
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
}

// MARK: View Model Delegate
extension PlacesViewController: PlacesViewModelDelegate {
    func didUpdateStatus(previous: DataStatus<[Place]>, new: DataStatus<[Place]>) {
        tableView.reloadData()
    }
}

// MARK: Private methods
private extension PlacesViewController {
    func setup() {
        viewModel.delegate = self

        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Goulash Places"
        
        tableView = UITableView(frame: .zero, style: .plain)
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorColor = .appSeparator
        tableView.attachToSuperview(useSafeArea: false)
        
        tableView.register(type: PlaceCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
    }
}
