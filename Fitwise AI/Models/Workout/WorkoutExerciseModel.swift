//
//  SupportingModels.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/16/23.
//

import Foundation
import RealmSwift

class WorkoutExerciseModel: EmbeddedObject, RealmFetchable {
    @Persisted var sets: List<WorkoutSetModel>
    @Persisted var unweighted: Bool //to show weight entry or not
    @Persisted var cardio: Bool //to show time entry or not
    @Persisted var name: String
    
    convenience init(name: String, sets: List<WorkoutSetModel>, unweighted: Bool? = nil, cardio: Bool? = nil) {
        self.init()
        self.name = name
        self.sets = sets
    }
}
