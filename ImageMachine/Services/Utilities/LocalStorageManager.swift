//
//  LocalStorageManager.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 01/08/21.
//

/*
 The local storage is managed using Realm.
 This is a Realm Wrapper
 */

import Foundation
import RealmSwift

/// The storage supports using realm.
class LocalStorageManager {
    
    fileprivate static let realmInstance = RealmManager.realmInstance
    
}

extension LocalStorageManager : RealmOperations {
    /// Writes to Realm
    internal static func write<T: Object>(_ object: T? = nil, block: @escaping ((Realm, T?) -> Void)) {
        DispatchQueue(label: "realm").sync {
            autoreleasepool {
                let currentRealm = realmInstance
                if currentRealm.isInWriteTransaction {
                    return
                } else {
                    do {
                        try currentRealm.write {
                            block(currentRealm, object)
                        }
                    } catch {
                        return
                    }
                }
            }
        }
    }
    
    // MARK:- ADD functions
    /// adds an object to Realm
    static func add(_ object: Object) {
        Self.write { (realmInstance, _) in
            realmInstance.add(object, update: .all)
        }
    }
    
    /// adds a list of objects to Realm
    static func add<S: Sequence>(_ objects: S) where S.Iterator.Element: Object {
        Self.write { (realmInstance, _) in
            realmInstance.add(objects, update: .all)
        }
    }
    
    
    // MARK:- GET function
    static func get<R: Object>(fromEntity entity : R.Type, withPredicate predicate: NSPredicate? = nil, sortedByKey sortKey: String? = nil, inAscending isAscending: Bool = true) -> Results<R> {
        var objects = realmInstance.objects(entity)
        if predicate != nil {
            objects = objects.filter(predicate!)
        }
        if sortKey != nil {
            objects = objects.sorted(byKeyPath: sortKey!, ascending: isAscending)
        }
        
        return objects
    }
    
    // MARK:- DELETE functions
    static func delete(_ object: Object) {
        Self.write(object) { (realmInstance, newObject) in
            guard let newObject = newObject, !newObject.isInvalidated else {
                return
            }
            realmInstance.delete(newObject)
        }
    }
    
    /// deletes a list of elements from Realm
    static func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object {
        Self.write { (realmInstance, _) in
            realmInstance.delete(objects)
        }
    }
    
    /// deletes an Entity from Realm, a predicate can be given
    static func delete(fromEntity entity: Object.Type, withPredicate predicate: NSPredicate? = nil) {
        Self.delete(Self.get(fromEntity: entity, withPredicate: predicate))
    }
    
    // MARK:- UPDATE function
    static func update<T: Object>(_ object: T, block: @escaping ((T) -> Void)) {
        guard !object.isInvalidated else {
            return
        }
        
        Self.write(object) { (_, newObject) in
            guard let newObject = newObject, !newObject.isInvalidated else {
                return
            }
            block(newObject)
        }
    }
}

