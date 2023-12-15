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
    
    
    func hhfd()   {
        let routineDays = generateRoutine()
        
        for routineDay in routineDays {
            print(routineDay.dayIndex)
            for muscleGroup in routineDay.muscleGroup {
                print("-- \(muscleGroup.text)")
                let exercises = getExercises(muscleGroup, 3)
                exercises.forEach {
                    print("----  \($0.name)")
                }
            }
        }
    }
    
    
    
    func getExercises(_ muscleGroup: MuscleGroupEnum, _ count: Int) -> Slice<Results<ExerciseModel>> {
        let filteredExercises = exerciseModel
            .filter("ANY primaryMuscleGroups.group = '\(muscleGroup.text)'")
            .sorted(byKeyPath: "\(readGender()!)BwRatio", ascending: false)
            .prefix(count)
        
        //TODO: Exercises with the highest BwRatio have very a high RSM & one can train them very hard. But it isn't smart to only return exercises with the highest BwRatio anytime getExercises() is called. Furthermore, if you're just going to rely on the same 3 exercises every single week - at some point, they are going to get stale, which means if the app algorithm doesn't switch them out, the progress is going to plateau hard. If the algorithm switches them out, the only option is to trade them with exercises with a lower RSM, because you picked the best ones first. So if the user needs 3 exercies, pick 2 with high BwRatio and 1 with low. 
        return filteredExercises
    }
    
    func generateExerciseSequence(totalExercises: Int, numMuscleGroups: Int) -> [Int] {
        let exercisesPerGroup = totalExercises / numMuscleGroups
        let extraExercises = totalExercises % numMuscleGroups
        
        var exerciseSequence: [Int] = []
        
        for _ in 0..<extraExercises {
            exerciseSequence.append(exercisesPerGroup + 1)
        }
        
        for _ in extraExercises..<numMuscleGroups {
            exerciseSequence.append(exercisesPerGroup)
        }
        
        return exerciseSequence
    }

    //TODO: This rounds to the nearest weight in imperial units. Adapt it to metric as well
    func roundToNearestWeight(_ number: Double) -> Double {
        let roundedValue = 5 * round(number / 5)
        return roundedValue
    }
    
    func readGender() -> String? {
        let realm = try! Realm()
        if let user = realm.objects(UserModel.self).last {
            let gender = user.gender == .male ? "male" : "female"
            return gender
        } else {
            return nil
        }
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
