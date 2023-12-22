//
//  HomeViewModel.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/14/23.
//

import SwiftUI
import RealmSwift

//public struct ExerciseViewDataModel: Identifiable {
//    //TODO: this also needs to know certain info about the exercise to prepare the view such as isUnweighted or isCardio to strip out elements from the view (!)
//    public let id =  UUID()
//    public let name: String
//    public let sets: [ExerciseSet]
//    let realmExerciseObject: Slice<Results<ExerciseModel>>.Element
//}
//
//public struct ExerciseSet: Identifiable {
//    public let id =  UUID()
//    public let targetWeight: Double?
//    public let targetReps: Int?
//}

class HomeViewModel: ObservableObject {
    //TODO: Right now, the current day is hardcoded and in multiple placec . Make it dynamic!
    let currentDay = 1
    
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

    
    func getExercises(_ muscleGroup: MuscleGroupEnum, _ totalSets: Int) -> [ExerciseViewDataModel] {
        var index = 0
        var exercises: [ExerciseViewDataModel] = []
        var splitSets = splitSets(totalSets)
        let filteredExercises = exerciseModel
            .filter("ANY primaryMuscleGroups.group = '\(muscleGroup.text)'")
            .sorted(byKeyPath: "\(getGender()!)BwRatio", ascending: false)
            .prefix(splitSets.count)
        
        
        //TODO: Exercises with the highest BwRatio have very a high RSM & one can train them very hard. But it isn't smart to only return exercises with the highest BwRatio anytime getExercises() is called. Furthermore, if you're just going to rely on the same 3 exercises every single week - at some point, they are going to get stale, which means if the app algorithm doesn't switch them out, the progress is going to plateau hard. If the algorithm switches them out, the only option is to trade them with exercises with a lower RSM, because you picked the best ones first. So if the user needs 3 exercies, pick 2 with high BwRatio and 1 with low.
        
        //TODO: UserWeight, genderBwRatip, set count, rep count are hard coded.
        filteredExercises.forEach {
            var sets: [ExerciseSet] = []
            for _ in 1...splitSets[index] {
                //TODO: What about warmup sets? Are we not doing those for every muscle group every workout?
                sets.append(ExerciseSet(targetWeight: calculateTargetWeight($0), targetReps: calculateReps($0)))
            }
            exercises.append(ExerciseViewDataModel(name: $0.name, sets: sets, muscleGroup: $0.primaryMuscleGroups.first!.group, realmObj: $0))
            index += 1

        }
        return exercises
    }
    
    func main() {
        
        //TODO: THIS FUNC IS WRITTEN ASSUMING THE USER IS A BEGINNER
        let setsPerSessionRange = 16...24
        let routineDays = generateRoutine()
        let totalTrainingDays = routineDays.count
        let SPW = (setsPerSessionRange.lowerBound * totalTrainingDays)
        //TODO: HARD DIVIDE BY 7. WHAT IF THE USER DOESN'T WANNA TRAIN ABS?
        let totalMuscleGroups = 7.0
        let globalSPMG: Double = (Double(SPW) / Double(totalMuscleGroups)).rounded()
        
        var chestTank = 8
        var tricepsTank = 8
        var shoulderTank = 8
        var absTank = 8/3
    
        print("Running main func! Total training days are \(totalTrainingDays). The optimimum set range is \(setsPerSessionRange) but we're taking \(setsPerSessionRange.lowerBound) as the input and assuming the user is a beginner and they want to work out all \(totalMuscleGroups) muscle groups. Calculated SPW is \(SPW) and weeklySPMG is \(globalSPMG). Do week need to fill all the sets in 1 day becoz we're not repeating muscle group targeting? YES")
        
        for routineDay in routineDays {
            if routineDay.dayIndex == currentDay {
                            
                for muscleGroup in routineDay.muscleGroup {
                    print("\n" + muscleGroup.text)
                    
                    func requestExercises(_ muscleGroup: MuscleGroupEnum) -> [ExerciseViewDataModel]? {
                        if muscleGroup == .abs {
                            let exercises = getExercises(muscleGroup, (absTank <= 0 ? 4 : absTank))
                            return exercises
                        } else  if muscleGroup == .chest {
                            let exercises = getExercises(muscleGroup, (chestTank <= 0 ?  4 : chestTank))
                            return exercises
                        } else if muscleGroup == .triceps {
                            let exercises = getExercises(muscleGroup, (tricepsTank <= 0 ?  4 : tricepsTank))
                            return exercises
                        } else if muscleGroup == .shoulders {
                            let exercises = getExercises(muscleGroup, (shoulderTank <= 0 ?  4 : shoulderTank))
                            return exercises
                        } else {
                            return nil
                        }
                    }
                    
                    let exercises = requestExercises(muscleGroup)!
                    
                    for exercise in exercises {
                        
                        let synergisticMuscleGroups = exercise.realmObj.muscleGroups

                        for synergisticMuscleGroup in synergisticMuscleGroups {
                            // if the activation is over 80% AND it's not the main muscle group
                            if (synergisticMuscleGroup.activation_percent >= 0.8) && (synergisticMuscleGroup.group != exercise.realmObj.primaryMuscleGroups.first!.group) {
                                    let numToMinusD = (Double(exercise.sets.count)/* * pmg.activation_percent*/)
                                    let numToMinus = Int(numToMinusD.rounded())
                                    switch synergisticMuscleGroup.group {
                                    case "Abs":
                                        absTank = (absTank - numToMinus)
                                    case "Chest":
                                        chestTank = (chestTank - numToMinus)
                                    case "Triceps":
                                        tricepsTank = (tricepsTank - numToMinus)
                                    case "Shoulders":
                                        shoulderTank = (shoulderTank - numToMinus)
                                    default:
                                        break
                                }
                            }
                        }
                        
                        print(exercise.name)
                        for set in exercise.sets {
                            print("\(String(format: "%g", set.targetWeight!)) x \(set.targetReps!)")
                        }
                    }
                }
                
                
                print("chest volume: \(chestTank <= 0 ? 4 : chestTank)")
                print("triceps volume: \(tricepsTank <= 0 ? 4 : tricepsTank)")
                print("shoulder volume: \(shoulderTank <= 0 ? 4 : shoulderTank)")
                print("abs volume: \(absTank <= 0 ? 4 : absTank)")

            }
        }
        
    }
    func splitSets(_ totalSets: Int) -> [Int] {
        //https://chat.openai.com/c/fb94309e-9572-4abd-98e9-d8da49ce3949
        var setsDistribution: [Int] = []
        var remainingSets = totalSets
        //Here, we declare two variables: setsDistribution will store the result (the distribution of sets among exercises), and remainingSets initially holds the total number of sets.
        
        while remainingSets > 0 {
            //This is a while loop that continues executing as long as there are remaining sets to distribute (remainingSets > 0).
            if remainingSets >= 4 {
                setsDistribution.append(4)
                remainingSets -= 4
            } else {
                setsDistribution.append(3)
                remainingSets -= 3
            }
            //Inside the loop, it checks whether there are at least 4 sets remaining. If true, it adds a set of size 4 to the distribution and subtracts 4 from remainingSets. If not, it adds a set of size 3 and subtracts 3 from remainingSets.
        }
        
        return setsDistribution
    }

    func calculateReps(_ exercise: Slice<Results<ExerciseModel>>.Element) -> Int {
        // anything between 5-30 reps in a set taken close to failure is aboslutely effective for muscle growth
        if exercise.highRepMovement {
            return 14
        } else if exercise.powerLift {
            return 8
        } else {
            return 10
        }
    }
    
        //TODO: THIS FUNC BELOW
//    func calcuateSets() -> Int {
//        let target = userModel.last?.workoutFrequency
//        
//    }
    
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
