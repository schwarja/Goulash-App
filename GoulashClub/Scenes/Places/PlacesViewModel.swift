//
//  PlacesViewModel.swift
//  GoulashClub
//
//  Created by Jan on 18/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

protocol PlacesViewModelDelegate: class {
    func didUpdateStatus(previous: DataStatus<[Place]>, new: DataStatus<[Place]>)
}

class PlacesViewModel: NSObject {
    let databaseManager: DatabaseManaging
    weak var delegate: PlacesViewModelDelegate?
    
    private(set) var places: DataStatus<[Place]> = .initial {
        didSet {
            delegate?.didUpdateStatus(previous: oldValue, new: places)
        }
    }
    
    init(database: DatabaseManaging) {
        self.databaseManager = database
        
        super.init()
        
        self.databaseManager.register(placesListener: self)
    }
    
    func numberOfItems() -> Int {
        switch places {
        case let .ready(data):
            return data.count
        case .initial, .loading, .error:
            return 0
        }
    }
    
    func item(at row: Int) -> Place {
        guard case let .ready(data) = places else {
            fatalError("No data available")
        }
        
        return data[row]
    }
}

// MARK: PlacesListener
extension PlacesViewModel: PlacesDatabaseListener {
    func didUpdatePlaces(_ places: DataStatus<[Place]>) {
        self.places = places
    }
}
