//
//  DatabaseManaging.swift
//  GoulashClub
//
//  Created by Jan on 15/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

protocol DatabaseManaging {
    func register<Listener: NSObject>(placesListener: Listener) where Listener: PlacesDatabaseListener
    func register<Listener: NSObject>(placeListener: Listener, for id: String) where Listener: PlaceDatabaseListener
}
