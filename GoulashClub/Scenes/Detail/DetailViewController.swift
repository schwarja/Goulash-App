//
//  DetailViewController.swift
//  GoulashClub
//
//  Created by Jan on 04/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // swiftlint:disable implicitly_unwrapped_optional
    private var titleLabel: UILabel!
    private var newWindowButton: UIButton!
    
    private let viewModel: DetailViewModel
    private weak var coordinator: DetailCoordinator?
    
    init(viewModel: DetailViewModel, coordinator: DetailCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: View Model Delegate
extension DetailViewController: DetailViewModelDelegate {
    func didUpdateStatus(previous: DataStatus<Place>, new: DataStatus<Place>) {
        configureUI()
    }
}

// MARK: Actions
private extension DetailViewController {
    @objc func newWindowTapped() {
        coordinator?.didSelectOpenInNewWindow(in: self)
    }
}

// MARK: Private methods
private extension DetailViewController {
    func setup() {
        viewModel.delegate = self
        
        setupUI()
    }
    
    func setupUI() {
        titleLabel = UILabel()
        titleLabel.text = "Detail"
        titleLabel.textColor = .yellow
        view.addSubview(titleLabel)
        
        titleLabel.attachToSafeArea(left: ">=20", top: 20, right: ">=20")
        titleLabel.attach(centerX: 0)
        
        newWindowButton = UIButton(type: .system)
        newWindowButton.setTitle("Open in new window", for: .normal)
        newWindowButton.addTarget(self, action: #selector(self.newWindowTapped), for: .touchUpInside)
        view.addSubview(newWindowButton)
        
        newWindowButton.attachToSafeArea(left: ">=20", right: ">=20")
        newWindowButton.attach(toView: titleLabel, top: 40)
        newWindowButton.attach(centerX: 0)
        
        configureUI()
    }
    
    func configureUI() {
        switch viewModel.place {
        case .initial:
            titleLabel.text = "No Place"
        case .loading:
            titleLabel.text = "Loading"
        case .error(let error):
            titleLabel.text = error.localizedDescription
        case .ready(let place):
            titleLabel.text = place.name
        }
    }
}
