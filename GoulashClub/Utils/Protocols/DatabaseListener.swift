//
//  DatabaseListener.swift
//  GoulashClub
//
//  Created by Jan on 15/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

protocol DatabaseListener: AnyObject {}

protocol PlacesDatabaseListener: DatabaseListener {
    func didUpdatePlaces(_ places: DataStatus<[Place]>)
}

protocol PlaceDatabaseListener: DatabaseListener {
    func didUpdatePlace(with id: String, place: DataStatus<Place>)
}
