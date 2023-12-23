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
    @Persisted var startDate: Date
    @Persisted var isFinished: Bool //if it's not completed, then that means it is in cache.
    @Persisted var endDate: Date?
    @Persisted var exercises: List<WorkoutExerciseModel>
    
    convenience init(name: String, startDate: Date, exercises: List<WorkoutExerciseModel>) {
        self.init()
        self.name = name
        self.startDate = startDate
        self.isFinished = false
        self.exercises = exercises
    }
}

