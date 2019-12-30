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
    private var scrollView: UIScrollView!
    private var imageView: GradientImageView!
    private var addressLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var newWindowButton: UIBarButtonItem?
    private var closeButton: UIBarButtonItem?
    // swiftlint:enable implicitly_unwrapped_optional
    
    private let margin: CGFloat = 16

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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            imageView.refresh()
        }
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
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.attachToSafeArea(left: 0, right: 0)
        scrollView.attach(top: 0, bottom: 0)
        
        imageView = GradientImageView(withDirection: .bottomToTop, fraction: 0.5, startColor: UIColor.appBackground, endColor: UIColor.appBackground.withAlphaComponent(0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        scrollView.addSubview(imageView)
        
        imageView.constraint(toAspectRatio: 1, priority: 900)
        imageView.constraint(toView: scrollView, heightMultiplier: "<=0.5")
        imageView.attach(left: 0, top: 0, right: 0)
        imageView.constraint(width: 0, toView: scrollView)
        
        addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.textColor = .appTextDimmed
        addressLabel.font = .appText
        scrollView.addSubview(addressLabel)
        
        addressLabel.attach(left: margin, right: ">=\(margin)")
        addressLabel.attach(toView: imageView, bottom: margin)

        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .appText
        descriptionLabel.textColor = .appText
        descriptionLabel.numberOfLines = 0
        scrollView.addSubview(descriptionLabel)
        
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        descriptionLabel.attach(left: margin, right: margin, bottom: margin, priority: 900)
        descriptionLabel.below(view: imageView, constant: margin)

        if dependency.canRequestNewWindow {
            newWindowButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.newWindowTapped))
            navigationItem.rightBarButtonItem = newWindowButton
        }
        
        if dependency.canBeDismissed {
            closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.closeTapped))
            navigationItem.leftBarButtonItem = closeButton
        }
        
        configureUI()
    }
    
    func configureUI() {
        switch viewModel.place {
        case .initial, .loading, .error:
            navigationItem.title = ""
            imageView.image = .placePlaceholder
            descriptionLabel.text = ""
            addressLabel.text = ""
        case .ready(let place):
            navigationItem.title = place.name
            imageView.setStorageImage(from: place.imageStorageUrl, placeholder: .placePlaceholder)
            descriptionLabel.text = place.description
            addressLabel.text = place.address
        }
    }
}
