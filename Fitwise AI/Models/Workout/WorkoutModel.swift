//
//  WorkoutModel.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/16/23.
//

import Foundation
import RealmSwift

class WorkoutModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = "New Workout"
    @Persisted var stateDate: Date
    @Persisted var isCompleted: Bool //if it's not completed, then that means it is in cache
    @Persisted var endDate: Date?
    @Persisted var exercises: WorkoutExerciseModel?
    
    //for func getstared
}

