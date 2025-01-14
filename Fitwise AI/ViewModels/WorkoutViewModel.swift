//
//  WorkoutViewModel.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/23/23.
//

import RealmSwift
import SwiftUI

class WorkoutViewModel: ObservableObject {
    
    @ObservedResults(WorkoutModel.self) var workoutModel
    
    let realm = try! Realm()

    func discardWorkout() {
        let workout = self.realm.objects(WorkoutModel.self).last!
        try! self.realm.write {
            self.realm.delete(workout)
        }
        print("discarded!")
    }
    
    /// TODO: Alert the user if they're trying to finish without having completed all the sets. Don't let them finish if the workout is empty.
    func finishWorkout() {
        /// Not writing to workoutModel because it's a frozen object? I don't know what the heck that means but the app crashes if I do it with the property wrapper var
        let workout = self.realm.objects(WorkoutModel.self).last!
        
        try! self.realm.write {
            workout.isFinished = true
        }
    }
    
    
    func markSetCompleted(forExerciseAtIndex: Int, forSetAtIndex: Int, weight: Double, reps: Int) {
        try! Realm().write {
            workoutModel.thaw()?.last!.exercises[forExerciseAtIndex].sets[forSetAtIndex].isChecked.toggle()
            workoutModel.thaw()?.last!.exercises[forExerciseAtIndex].sets[forSetAtIndex].weight = weight
            workoutModel.thaw()?.last!.exercises[forExerciseAtIndex].sets[forSetAtIndex].reps = reps
        }
    }
}
