//
//  HomeViewModel.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/14/23.
//

import RealmSwift
import Foundation

class HomeViewModel: ObservableObject {
    
    @ObservedResults(WorkoutModel.self) var workoutModel
    @Published var showWorkoutView = false

    
    func startWorkout(_ exercises: [ExerciseViewDataModel]) {
        
        /// Only run this func and add exercises to the Workoutview is there's no workout to recover. If there is a workout to recover -- we won't add exercises and the Workoutview will just read from the last entry in WorkoutModel class (Realm)
        if !recoverWorkout() {
            
            let workoutExerciseArray = List<WorkoutExerciseModel>()
            
            for exercise in exercises {
                /// FOR WORKOUT SETS:
                let workoutSetArray = List<WorkoutSetModel>()
                
                exercise.sets.forEach {
                    let workoutSet = WorkoutSetModel(reps: $0.targetReps!, weight: $0.targetWeight!)
                    workoutSetArray.append(workoutSet)
                }
                
                let workoutExercise = WorkoutExerciseModel(name: exercise.name, sets: workoutSetArray)
                workoutExerciseArray.append(workoutExercise)
            }
            
            let workout = WorkoutModel(name: "Midnight Workout", startDate: Date(), exercises: workoutExerciseArray)
            $workoutModel.append(workout)
            
            showWorkoutView = true
        }
    }
    
    func recoverWorkout() -> Bool {
        if let last = workoutModel.last {
            if !last.isFinished {
                showWorkoutView = true
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
