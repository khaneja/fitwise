//
//  Equipment.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/13/23.
//

import Foundation
import RealmSwift

class EquipmentModel: Object {
    @Persisted var name: String
    @Persisted var group: String
    @Persisted var Sdescription: String
    
    convenience init(name: String, group: String, Sdescription: String) {
        self.init()
        self.name = name
        self.group = group
        self.Sdescription = Sdescription
    }
}

class PrimaryMuscleGroupModel: Object {
    @Persisted var activation_percent: Double
    @Persisted var male_priority: Int
    @Persisted var female_priority: Int
    @Persisted var Sdescription: String
    @Persisted var display_name: String
    @Persisted var group: String
    
    convenience init(activation_percent: Double, male_priority: Int, female_priority: Int, Sdescription: String, display_name: String, group: String) {
        self.init()
        self.activation_percent = activation_percent
        self.male_priority = male_priority
        self.female_priority = female_priority
        self.Sdescription = Sdescription
        self.display_name = display_name
        self.group = group
    }
}

class MuscleGroupModel: Object {
    @Persisted var activation_percent: Double
    @Persisted var male_priority: Int
    @Persisted var female_priority: Int
    @Persisted var Sdescription: String
    @Persisted var display_name: String
    @Persisted var group: String
    
    convenience init(activation_percent: Double, male_priority: Int, female_priority: Int, Sdescription: String, display_name: String, group: String) {
        self.init()
        self.activation_percent = activation_percent
        self.male_priority = male_priority
        self.female_priority = female_priority
        self.Sdescription = Sdescription
        self.display_name = display_name
        self.group = group
    }
}
