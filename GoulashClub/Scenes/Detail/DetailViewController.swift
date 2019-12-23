//
//  DetailViewController.swift
//  GoulashClub
//
//  Created by Jan on 04/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    struct Dependency {
        let viewModel: DetailViewModel
        weak var coordinator: DetailCoordinator?
        
        let canRequestNewWindow: Bool
        let canBeDismissed: Bool
    }
    
    // swiftlint:disable implicitly_unwrapped_optional
    private var titleLabel: UILabel!
    private var newWindowButton: UIButton?
    private var closeButton: UIBarButtonItem?
    // swiftlint:enable implicitly_unwrapped_optional

    private let dependency: Dependency
    private var viewModel: DetailViewModel {
        dependency.viewModel
    }
    private var coordinator: DetailCoordinator? {
        dependency.coordinator
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
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
    
    @objc func closeTapped() {
        coordinator?.didSelectClose(in: self)
    }
}

// MARK: Private methods
private extension DetailViewController {
    func setup() {
        viewModel.delegate = self
        
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .appBackground
        
        titleLabel = UILabel()
        titleLabel.font = .appTitle
        titleLabel.textColor = .appText
        view.addSubview(titleLabel)
        
        titleLabel.attachToSafeArea(left: ">=20", top: 20, right: ">=20")
        titleLabel.attach(centerX: 0)
        
        if dependency.canRequestNewWindow {
            let newWindowButton = UIButton()
            newWindowButton.setTitleColor(.appText, for: .normal)
            newWindowButton.titleLabel?.font = .appButton
            newWindowButton.setTitle("Open in new window", for: .normal)
            newWindowButton.addTarget(self, action: #selector(self.newWindowTapped), for: .touchUpInside)
            view.addSubview(newWindowButton)
            
            newWindowButton.attachToSafeArea(left: ">=20", right: ">=20")
            newWindowButton.attach(toView: titleLabel, top: 40)
            newWindowButton.attach(centerX: 0)
            
            self.newWindowButton = newWindowButton
        }
        
        if dependency.canBeDismissed {
            closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.closeTapped))
            navigationItem.rightBarButtonItem = closeButton
        }
        
        configureUI()
    }
    
    func configureUI() {
        switch viewModel.place {
        case .initial:
            navigationItem.title = ""
            titleLabel.text = "No Place"
        case .loading:
            navigationItem.title = ""
            titleLabel.text = "Loading"
        case .error(let error):
            navigationItem.title = ""
            titleLabel.text = error.localizedDescription
        case .ready(let place):
            navigationItem.title = place.name
            titleLabel.text = ""
        }
    }
}
