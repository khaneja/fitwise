//
//  Migrator.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/13/23.
//

import Foundation
import RealmSwift

class Migrator  {
    init() {
        updateSchema()
    }
    
    //TODO: This might just the stupidest migrator out there.
    func updateSchema() {
        let config = Realm.Configuration(schemaVersion: 1) { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: ExerciseModel.className()) { oldObject, newObject in
                    newObject!["equipments"]
                }
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
        
        do {
            let _ = try Realm()
        } catch {
            print("Error opening default realm file", error.localizedDescription)
        }
    }
}
