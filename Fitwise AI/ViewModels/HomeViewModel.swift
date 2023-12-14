//
//  HomeViewModel.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/14/23.
//

import SwiftUI
import RealmSwift

// I need to output only a few exercises based on how much time does the user have.
// 20 minutes on a pull day? You're only gonna do Pulldowns, Curls and an ab exercise

final class HomeViewModel: ObservableObject {
    @ObservedResults(ExerciseModel.self) var exerciseModel
    
    func pickExercises() {
        //Example of a routine day — RoutineDay(dayIndex: 1, muscleGroup: [.legs, .abs])
        let routineDays = routineGenerator()
        
        for routineDay in routineDays { print("├── Day \(routineDay.dayIndex)")
            
            for muscleGroup in routineDay.muscleGroup {
                
                let filteredExercises = exerciseModel
                    .filter("ANY primaryMuscleGroups.group = '\(muscleGroup.text)'")
                //TODO: Just sorting by male ratio. make it dynamic so it sorts by female ratio too
                    .sorted(byKeyPath: "maleBwRatio", ascending: false)
                
                
                print("│   ├── \(muscleGroup.text)")
                
                filteredExercises.forEach {
                    print("│   │   │   ├── \($0.name)")
                    print("│   │   │   │   └── BwRatio: \($0.maleBwRatio)")
                    print("│   │   │   │   └── Lift weight: \(roundToNearestWeight(Double($0.maleBwRatio * 146.0)))")
                    
                    
                    $0.primaryMuscleGroups.forEach {
                        print("│   │   │   │   ├── Primary Muscle Group")
                        print("│   │   │   │   │   ├── Name: \($0.display_name)")
                        print("│   │   │   │   │   └── Group: \($0.group)")
                        print("│   │   │   │   │   └── Priority: \($0.male_priority)")
                    }
                }
            }
        }
    }
    
    //TODO: This rounds to the nearest weight in imperial units. Adapt it to metric as well
    func roundToNearestWeight(_ number: Double) -> Double {
        let roundedValue = 5 * round(number / 5)
        return roundedValue
    }
    
    //    func pickExercises() {
    //        //Example of a routine day — RoutineDay(dayIndex: 1, muscleGroup: [.legs, .abs])
    //        let routineDays = routineGenerator()
    //
    //        for routineDay in routineDays { print("├── Day \(routineDay.dayIndex)")
    //
    //            for muscleGroup in routineDay.muscleGroup {
    //
    //                let filteredExercises = exerciseModel
    //                    .filter("ANY primaryMuscleGroups.group = '\(muscleGroup.text)'")
    //                //TODO: Just sorting by male ratio. make it dynamic so it sorts by female ratio too
    //                    .sorted(byKeyPath: "maleBwRatio", ascending: false)
    //
    //
    //                print("│   ├── \(muscleGroup.text)")
    //
    //                filteredExercises.forEach {
    //                    print("│   │   │   ├── \($0.name)")
    //                    print("│   │   │   │   └── BwRatio: \($0.maleBwRatio)")
    //                    print("│   │   │   │   └── Lift weight: \(roundToNearestWeight(Double($0.maleBwRatio * 146.0)))")
    //
    //
    //                    $0.primaryMuscleGroups.forEach {
    //                        print("│   │   │   │   ├── Primary Muscle Group")
    //                        print("│   │   │   │   │   ├── Name: \($0.display_name)")
    //                        print("│   │   │   │   │   └── Group: \($0.group)")
    //                        print("│   │   │   │   │   └── Priority: \($0.male_priority)")
    //                    }
    //                }
    //            }
    //        }
    //    }
}
