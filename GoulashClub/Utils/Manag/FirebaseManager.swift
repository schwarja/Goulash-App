//
//  FirebaseManager.swift
//  GoulashClub
//
//  Created by Jan on 06/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    enum Path: String {
        case places
    }
    
    let database = Firestore.firestore()
    let decoder = JSONDecoder()
    
    private(set) var places: DataStatus<[Place]> = .initial {
        didSet {
            informListeners()
        }
    }
    
    private var placesListeners: Set<WRO<NSObject>> = [] {
        didSet {
            listenersUpdated()
        }
    }
    private var placeListeners: [String: Set<WRO<NSObject>>] = [:] {
        didSet {
            listenersUpdated()
        }
    }
    private var placesListenerRegistration: ListenerRegistration?
}

// MARK: Database Managing
extension FirebaseManager: DatabaseManaging {
    func register<Listener>(placesListener: Listener) where Listener: NSObject, Listener: PlacesDatabaseListener {
        let wro = WRO<NSObject>(object: placesListener)
        placesListeners.insert(wro)
    }
    
    func register<Listener>(placeListener: Listener, for id: String) where Listener: NSObject, Listener: PlaceDatabaseListener {
        let wro = WRO<NSObject>(object: placeListener)
        var listeners = placeListeners[id] ?? Set<WRO<NSObject>>()
        listeners.insert(wro)
        placeListeners[id] = listeners
    }
}

// MARK: Private
private extension FirebaseManager {
    func listenersUpdated() {
        if placesListeners.isEmpty && placeListeners.isEmpty {
            stopListeningToPlaces()
        } else {
            startListeningToPlaces()
        }
    }
        
    func startListeningToPlaces() {
        guard placesListenerRegistration == nil else {
            return
        }
        
        self.places = .loading
        placesListenerRegistration = database.collection(Path.places.rawValue).addSnapshotListener(includeMetadataChanges: false) { [weak self] (snapshot, error) in
            if let snapshot = snapshot, let self = self {
                do {
                    let places: [Place] = try self.decoder.decode(snapshot: snapshot)
                    self.places = .ready(data: places)
                } catch {
                    self.places = .error(error: DatabaseError.serialization(error: error))
                }
            } else if let err = error {
                self?.places = .error(error: DatabaseError.internal(error: err))
            } else {
                self?.places = .error(error: DatabaseError.unknown)
            }
        }
    }
    
    func stopListeningToPlaces() {
        placesListenerRegistration?.remove()
    }
    
    func informListeners() {
        for wro in placesListeners {
            if let listener = wro.object as? PlacesDatabaseListener {
                listener.didUpdatePlaces(places)
            }
        }
    }
}
