//
//  WorkoutSetModel.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/16/23.
//

import Foundation
import RealmSwift

class WorkoutSetModel: EmbeddedObject {
    //TODO: the exercises.json has a big, big issue. It doesn't treat cardio exercises properly, just slaps a time_compatible property on them. This isn't how it should be. Cardio exercises should not only have their own group and search filters, but when the user selects a cardio exercise, the app shouldn't ask them for reps or weight! That is plan stupid. Ditto for bodyweight exercises. This is a lacking with the Fitness AI app. As shiny as it seems on the outside, it isn't that good from the inside - whether that be the weight algorithm they use or total non-support for cardio let alone have a special AI dedicated to it where if the user checks during onboarding that they're interested in cardio, the app suggests them, based on their goals, how they should do amalgamate it into their workout rotine & why.
    @Persisted var isWarmup: Bool
    @Persisted var isChecked: Bool
    @Persisted var reps: Int
    @Persisted var rpe: Double
    @Persisted var weight: Double
    
    convenience init(reps: Int, weight: Double) {
        self.init()
        self.isChecked = false
        self.isWarmup = false
        self.reps = reps
        self.weight = weight
    }
}
