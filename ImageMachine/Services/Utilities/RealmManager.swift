//
//  RealmManager.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 01/08/21.
//

import Foundation
import RealmSwift

protocol RealmOperations {
    /// write operation
    static func write<T: Object>(_ object: T?, block: @escaping ((Realm, T?) -> Void))
    ///
    /// adds a single object to Realm
    static func add(_ object: Object)
    /// adds a list of objects to Realm
    static func add<S: Sequence>(_ objects: S) where S.Iterator.Element: Object
    
    /// gets objects from Realm that satisfy the given predicate
    static func get<R: Object>(fromEntity entity : R.Type, withPredicate predicate: NSPredicate?, sortedByKey sortKey: String?, inAscending isAscending: Bool) -> Results<R>
    
    /// deletes a single object from Realm
    static func delete(_ object: Object)
    
    /// deletes a list of object from Realm
    static func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object
    
    /// deletes an Entity from Realm based  on the given predicate
    static func delete(fromEntity entity: Object.Type, withPredicate predicate: NSPredicate?)
    
    /// updates and overwrites a Realm object
    static func update<T: Object>(_ object: T, block: @escaping ((T) -> Void))
}

class RealmManager {
    
    static var realmConfiguration : Realm.Configuration {
        get {
            return Realm.Configuration.defaultConfiguration
        }
    }
    
    static var realmInstance : Realm {
        do {
            let newRealm = try Realm(configuration: realmConfiguration)
            return newRealm
        } catch {
            print(error)
            fatalError(error.localizedDescription)
        }
    }
    
}
