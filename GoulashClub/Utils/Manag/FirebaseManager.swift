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
    
    enum ChangeType {
        case added
        case modified
        case deleted
    }
    typealias PlaceChange = (type: ChangeType, placeId: String, index: Int)
    
    let database = Firestore.firestore()
    let decoder = JSONDecoder()
    
    private(set) var places: DataStatus<[Place]> = .initial {
        didSet {
            informListeners()
        }
    }
    
    private var placesListeners: [WRO<NSObject>] = [] {
        didSet {
            listenersUpdated()
        }
    }
    private var placeListeners: [String: [WRO<NSObject>]] = [:] {
        didSet {
            listenersUpdated()
        }
    }
    private var placesListenerRegistration: ListenerRegistration?
}

// MARK: Database Managing
extension FirebaseManager: DatabaseManaging {
    func register<Listener>(placesListener: Listener) where Listener: NSObject, Listener: PlacesDatabaseListener {
        clearReleasedListeners()
        let wro = WRO<NSObject>(object: placesListener)
        placesListeners.append(wro)
        inform(placesListener: wro)
    }
    
    func register<Listener>(placeListener: Listener, for id: String) where Listener: NSObject, Listener: PlaceDatabaseListener {
        clearReleasedListeners()
        let wro = WRO<NSObject>(object: placeListener)
        var listeners = placeListeners[id] ?? [WRO<NSObject>]()
        listeners.append(wro)
        placeListeners[id] = listeners
        inform(placeListener: wro, placeId: id)
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
        
        placesListenerRegistration = database.collection(Path.places.rawValue).addSnapshotListener(includeMetadataChanges: false) { [weak self] (snapshot, error) in
            if let snapshot = snapshot, let self = self {
                do {
                    let places = try self.deserialize(snapshot: snapshot)
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
        
        self.places = .loading
    }
    
    func stopListeningToPlaces() {
        placesListenerRegistration?.remove()
    }
    
    func deserialize(snapshot: QuerySnapshot) throws -> [Place] {
        let newPlaces: [Place]
        if case .ready(var places) = self.places {
            for change in snapshot.documentChanges {
                switch change.type {
                case .added:
                    let place: Place = try self.decoder.decode(document: change.document)
                    places.insert(place, at: Int(change.newIndex))
                case .modified:
                    places.remove(at: Int(change.oldIndex))
                    let place: Place = try self.decoder.decode(document: change.document)
                    places.insert(place, at: Int(change.newIndex))
                case .removed:
                    places.remove(at: Int(change.oldIndex))
                }
            }
            newPlaces = places
        } else {
            newPlaces = try decoder.decode(snapshot: snapshot)
        }
        return newPlaces
    }
    
    func informListeners() {
        for wro in placesListeners {
            inform(placesListener: wro)
        }
        
        for (identifier, listeners) in placeListeners {
            for wro in listeners {
                inform(placeListener: wro, placeId: identifier)
            }
        }
    }
    
    func inform(placesListener: WRO<NSObject>) {
        if let listener = placesListener.object as? PlacesDatabaseListener {
            listener.didUpdatePlaces(places)
        }
    }
    
    func inform(placeListener: WRO<NSObject>, placeId: String) {
        if let listener = placeListener.object as? PlaceDatabaseListener {
            switch places {
            case .initial:
                listener.didUpdatePlace(with: placeId, place: .initial)
            case .loading:
                listener.didUpdatePlace(with: placeId, place: .loading)
            case .error(let error):
                listener.didUpdatePlace(with: placeId, place: .error(error: error))
            case .ready(let places):
                if let place = places.first(where: { $0.id == placeId }) {
                    listener.didUpdatePlace(with: placeId, place: .ready(data: place))
                } else {
                    listener.didUpdatePlace(with: placeId, place: .error(error: DatabaseError.notExist))
                }
            }
        }
    }
    
    func clearReleasedListeners() {
        placesListeners = placesListeners.filter({ $0.object != nil })
        for (identifier, listeners) in placeListeners {
            let newListeners = listeners.filter({ $0.object != nil })
            placeListeners[identifier] = newListeners
        }
    }
}
