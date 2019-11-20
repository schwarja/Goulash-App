//
//  DetailViewModel.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 19/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

protocol DetailViewModelDelegate: class {
    func didUpdateStatus(previous: DataStatus<Place>, new: DataStatus<Place>)
}

class DetailViewModel: NSObject {
    let placeId: String
    let databaseManager: DatabaseManaging
    
    weak var delegate: DetailViewModelDelegate?
    
    private(set) var place: DataStatus<Place> = .initial {
        didSet {
            delegate?.didUpdateStatus(previous: oldValue, new: place)
        }
    }
    
    init(placeId: String, database: DatabaseManaging) {
        self.placeId = placeId
        self.databaseManager = database
        
        super.init()
        
        self.databaseManager.register(placeListener: self, for: placeId)
    }
}

// MARK: Database listener
extension DetailViewModel: PlaceDatabaseListener {
    func didUpdatePlace(with id: String, place: DataStatus<Place>) {
        self.place = place
    }
}
