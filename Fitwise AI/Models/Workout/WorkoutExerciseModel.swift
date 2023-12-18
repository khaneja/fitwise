//
//  SupportingModels.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/16/23.
//

import Foundation
import RealmSwift

class WorkoutExerciseModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var sets: WorkoutSetModel?
    @Persisted var unweighted: Bool //to show weight entry or not
    @Persisted var cardio: Bool //to show time entry or not
}
