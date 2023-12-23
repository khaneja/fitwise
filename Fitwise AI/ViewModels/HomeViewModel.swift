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
    
    func startWorkout(_ exercises: [ExerciseViewDataModel]) {
        
        print("gay shit")
        
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
    }
}
