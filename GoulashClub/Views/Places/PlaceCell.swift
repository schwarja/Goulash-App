//
//  PlaceCell.swift
//  GoulashClub
//
//  Created by Jan on 18/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell, NibNameIdentifiable {
    // swiftlint:disable:next implicitly_unwrapped_optional
    private var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    func configuare(with place: Place) {
        titleLabel.text = place.name
    }
}

// MARK: Private methods
private extension PlaceCell {
    func setupUI() {
        titleLabel = UILabel()
        titleLabel.textColor = .appText
        titleLabel.font = .appHeading
        contentView.addSubview(titleLabel)
        
        titleLabel.attach(centerY: 0)
        titleLabel.attach(left: 24)
    }
}
