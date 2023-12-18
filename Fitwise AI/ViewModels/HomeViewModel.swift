//
//  HomeViewModel.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/14/23.
//

import SwiftUI
import RealmSwift

public struct ExerciseViewDataModel: Identifiable {
    //TODO: this also needs to know certain info about the exercise to prepare the view such as isUnweighted or isCardio to strip out elements from the view (!)
    public let id =  UUID()
    public let name: String
    public let sets: [ExerciseSet]
}

public struct ExerciseSet: Identifiable {
    public let id =  UUID()
    public let targetWeight: Double?
    public let targetReps: Int?
}

class HomeViewModel: ObservableObject {
    
    
    @ObservedResults(ExerciseModel.self) var exerciseModel
    @ObservedResults(UserModel.self) var userModel
    
    
    //TODO: Create a Staleness detector func that replaces exercises
    
    // instead of writing here functions that predict exactly how much of something a user needs to do, why don't we just define
    func TotalSets() -> Int {
        return 20
    }
    
    func SetsPerMuscleGroup() -> Int {
        return 6
    }

    
    func getExercises(_ muscleGroup: MuscleGroupEnum) -> [ExerciseViewDataModel] {
        
        var exercises: [ExerciseViewDataModel] = []
        var setIndex = 1

        let filteredExercises = exerciseModel
            .filter("ANY primaryMuscleGroups.group = '\(muscleGroup.text)'")
            .sorted(byKeyPath: "\(getGender()!)BwRatio", ascending: false)
            .prefix(10)
        
        //TODO: Exercises with the highest BwRatio have very a high RSM & one can train them very hard. But it isn't smart to only return exercises with the highest BwRatio anytime getExercises() is called. Furthermore, if you're just going to rely on the same 3 exercises every single week - at some point, they are going to get stale, which means if the app algorithm doesn't switch them out, the progress is going to plateau hard. If the algorithm switches them out, the only option is to trade them with exercises with a lower RSM, because you picked the best ones first. So if the user needs 3 exercies, pick 2 with high BwRatio and 1 with low.
        
        //TODO: UserWeight, genderBwRatip, set count, rep count are hard coded.
        
        filteredExercises.forEach {
            print("\($0.name) @ \($0.maleBwRatio)")
            let numberOfSets = self.calcuateSets($0)
            var sets: [ExerciseSet] = []
            
            for _ in 1...numberOfSets {
                //TODO: What about warmup sets? Are we not doing those for every muscle group every workout?
                sets.append(ExerciseSet(targetWeight: calculateTargetWeight($0), targetReps: 10))
            }
            exercises.append(ExerciseViewDataModel(name: $0.name, sets: sets))
        }
        
        return exercises
    }
    
    
    func calculateReps(_ exercise: Slice<Results<ExerciseModel>>.Element) -> Int {
        // anything between 5-30 reps in a set close to failure is aboslutely effective for muslce growth
        return 10
    }
    
    
    func calcuateSets(_ exercise: Slice<Results<ExerciseModel>>.Element) -> Int {
        return 3
    }
    
    func calculateTargetWeight(_ exercise: Slice<Results<ExerciseModel>>.Element) -> Double? {
        
        //TODO: now this is tricky. Calculating target weight doesn't just mean you multiply Exercise's bw Ratio with weight and bob's your uncle. It's more than that! For one, most exercises don't have a bwRatio. Some exercises don't even need the target weight (i.e., cardio exercises) so it must be optional and handled rpretty well. But that's not it. the bw Target weight calculation is only useful if the user is doing the exercise for the first time. After which, the progressive overload per last weight lifted calculation takes over. As such, is it even useful to have a super-off bw weight calculation vs. just letter the user know that since it's their first time doing this exercise, they ought to select a wight with which they can do 10 reps. Once this has been done, the progession algorithm takes over and increments the weight each week. So if it's their first time doing this, maybe just show the weight as "learning"?
        
        let weight = userModel.last!.weight
        
        let bwRatio = userModel.last!.gender == .male ? exercise.maleBwRatio : exercise.femaleBwRatio
        
        var firstSessionWeight = 0.0
        
        //TODO: rounding off is horrible. Round to nearest plate weight not int.
        switch userModel.last!.experience {
        case .advanced:
            firstSessionWeight = (bwRatio * weight + (0.1 * bwRatio * weight)).rounded()
        case .beginner:
            firstSessionWeight = (bwRatio * weight - (0.1 * bwRatio * weight)).rounded()
        case .intermediate:
            firstSessionWeight = (bwRatio * weight).rounded()
        }
        
        if exercise.twoSidedMovement {
          firstSessionWeight = firstSessionWeight/2
        }

        return firstSessionWeight
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

    
    func getGender() -> String? {
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
