//
//  PlaceCell.swift
//  GoulashClub
//
//  Created by Jan on 18/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell, NibNameIdentifiable {
    private let horizontalMargin: CGFloat = 24
    private let verticalMargin: CGFloat = 16
    
    // swiftlint:disable implicitly_unwrapped_optional
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var placeImageView: UIImageView!
    // swiftlint:enable implicitly_unwrapped_optional

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeImageView.layer.cornerRadius = (contentView.frame.height - 2*verticalMargin) / 2
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = highlighted ? UIColor.appTint.withAlphaComponent(0.1) : .clear
    }
    
    func configuare(with place: Place) {
        titleLabel.text = place.name
        descriptionLabel.text = place.address
        placeImageView.setStorageImage(from: place.imageStorageUrl, placeholder: .placePlaceholder)
    }
}

// MARK: Private methods
private extension PlaceCell {
    func setupUI() {
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        
        placeImageView = UIImageView()
        placeImageView.translatesAutoresizingMaskIntoConstraints = false
        placeImageView.clipsToBounds = true
        placeImageView.contentMode = .scaleAspectFill
        contentView.addSubview(placeImageView)
        
        placeImageView.constraint(toAspectRatio: 1)
        placeImageView.attach(centerY: 0)
        placeImageView.attach(left: horizontalMargin)
        placeImageView.attach(top: verticalMargin, bottom: verticalMargin, priority: 900)
        
        let labelsView = UIView()
        labelsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelsView)
        
        labelsView.attach(centerY: 0)
        labelsView.attach(right: 0)
        labelsView.next(toView: placeImageView, constant: verticalMargin)
        labelsView.attach(top: ">=\(verticalMargin)", bottom: ">=\(verticalMargin)")
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .appText
        titleLabel.font = .appHeading
        labelsView.addSubview(titleLabel)
        
        titleLabel.attach(left: 0, top: 0, right: ">=0")
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .appTextDimmed
        descriptionLabel.font = .appText
        labelsView.addSubview(descriptionLabel)
        
        descriptionLabel.attach(left: 0, right: ">=0", bottom: 0)
        descriptionLabel.below(view: titleLabel, constant: 8)
    }
}
