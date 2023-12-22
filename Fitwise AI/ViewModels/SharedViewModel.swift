//
//  SharedViewModel.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/20/23.
//

import Foundation
import RealmSwift

var absBucket = bucketSet(direct: 0, indirect: 0)
var bicepsBucket = bucketSet(direct: 0, indirect: 0)
var chestBucket = bucketSet(direct: 0, indirect: 0)
var shoulderBucket = bucketSet(direct: 0, indirect: 0)
var tricepBucket = bucketSet(direct: 0, indirect: 0)
var backBucket = bucketSet(direct: 0, indirect: 0)
var legsBucket = bucketSet(direct: 0, indirect: 0)

class SharedViewModel: ObservableObject {
    
    /// Realm Models
    @ObservedResults(UserModel.self) var userModel
    @ObservedResults(ExerciseModel.self) var exerciseModel
    
    /// An array of [RoutineDay] which includes muscleGroups and dayIndex
    var routineDays: [RoutineDay] {
        generateRoutine()
    }
    
    /// The number of days the user will train in a week
    var totalTrainingDays: Int {
        userModel.last!.workoutFrequency.int
    }
    
    /// The  number of sets the user should do per session
    //    var setsPerSession: Int { calculateSetsPerSession() }
    
    /// The number of total sets the user can perform in a week (for all muscle groups)
    //    var totalAvailableWeeklySets: Int { setsPerSession * totalTrainingDays }
    
    /// SPW  = Sets per week (allotted to each muscle)
    //    var localSPW: Int { volumePerWeekPerBodypart() }
    
    /// Total muscle groups. Chaning this will change the code!
    @Published var numMuscleGroups = 8
    
    /// (!) Todo: currentDay is hardcoded.
    @Published var currentDay = 1
    
    let SortOrder = ["Chest", "Back", "Legs", "Shoulders", "Triceps", "Biceps", "Abs"]
    
    @Published var allExercises: [ExerciseViewDataModel] = []
    @Published var removedExercises: [ExerciseViewDataModel] = []
    
    
    init() {
        start()
    }
    
    func removeAll() {
//        allExercises.removeAll()
        print(routineDays.first?.muscleGroup)
    }

    func start() {
        absBucket = bucketSet(direct: (volumePerWeekPerBodypart(muscle: .abs)), indirect: 0)
        bicepsBucket = bucketSet(direct: (volumePerWeekPerBodypart(muscle: .biceps)), indirect: 0)
        chestBucket = bucketSet(direct: (volumePerWeekPerBodypart(muscle: .chest)), indirect: 0)
        shoulderBucket = bucketSet(direct: (volumePerWeekPerBodypart(muscle: .shoulders)), indirect: 0)
        tricepBucket = bucketSet(direct: (volumePerWeekPerBodypart(muscle: .triceps)), indirect: 0)
        backBucket = bucketSet(direct: (volumePerWeekPerBodypart(muscle: .back)), indirect: 0)
        legsBucket = bucketSet(direct: (volumePerWeekPerBodypart(muscle: .legs)), indirect: 0)
        
        for routineDay in routineDays {
            if routineDay.dayIndex == currentDay {
                for muscleGroup in routineDay.muscleGroup {
                    addExercises(muscleGroup: muscleGroup)
                }
            }
        }
        removeSynergistics(allExercises)
        
        /// Custom exercise sort
        allExercises = allExercises.sorted {
            guard let index1 = SortOrder.firstIndex(of: $0.muscleGroup),
                  let index2 = SortOrder.firstIndex(of: $1.muscleGroup)
            else {
                return false
            }
            return index1 < index2
        }
        
        allExercises = allExercises
                
//
//        print("--------- FINAL ———————")
//        
//        for exercise in allExercises {
//            print(exercise.name + " - " + exercise.muscleGroup)
//            exercise.sets.forEach {
//                print("\(String(format: "%g", $0.targetWeight!)) x \($0.targetReps!)")
//            }
//        }
    }
    
    func getStats() -> [bucketSet] {
        return [absBucket, bicepsBucket, chestBucket, shoulderBucket, tricepBucket, backBucket, legsBucket]
    }
    
    func volumePerWeekPerBodypart(muscle: MuscleGroupEnum) -> Int {
        var volume = 0
        
        if userModel.last!.workoutFrequency.int <= 2 {
            switch userModel.last!.experience {
            case .beginner:
                volume = 6
            case .intermediate:
                volume = 6
            case .advanced:
                volume = 8
            }
            
        } else if userModel.last!.workoutFrequency.int == 3 {
            switch userModel.last!.experience {
            case .beginner:
                volume = 8
                /// Limiting. Intermediates should do 8 sets per body part per week but can't because the picked frequency `(<=3)` is too low for them.
            case .intermediate:
                volume = 10
                /// Limiting. Advanced should do 10 sets per body part per week but can't because the picked frequency `(<=3)` is too low for them.
            case .advanced:
                volume = 10
            }
            
        } else {
            switch userModel.last!.experience {
            case .beginner:
                volume = 10
            case .intermediate:
                volume = 12
            case .advanced:
                volume = 14
            }
        }
        
        muscle == .abs ? volume = volume - 2 : nil
        
        let frequency = calculateFrequencyForMuscleGroup(muscle)
        
        if frequency == 0 {
            return volume
        } else {
            /// weekly volume divided by no. of days that muscle is trained (so: daily volume)
            if muscle == .legs {
                return (volume/frequency)
            } else {
                return (volume/frequency) > 6 ? 6 : volume/frequency
            }
        }
    }
    
    /// localSPW is weekly volume per muscle. But we can't pass SPW to addExercises. It's going to eat the weekly volume in a day! So we divide the weekly volume of a muscle by the no. of time the user is going to train that muscle in a week to get a day's volume which we can pass to the addExercise function.
    func calculateFrequencyForMuscleGroup(_ muscle: MuscleGroupEnum) -> Int {
        var frequency = 0
        
        for day in routineDays {
            if day.muscleGroup.contains(muscle) {
                frequency += 1
            }
        }
        
        return frequency
    }
    
    func addExercises(muscleGroup: MuscleGroupEnum)  {
                
        print("From " + muscleGroup.text)
        /// A distribution: 17 sets → [4, 4, 3]
        /// So, 3 exercises -- the first two with 4 sets and the third one with 3
        //        let distribution = splitSetsIntoExercises(numOfSetsToSplit: calculateFrequencyForMuscleGroup(muscleGroup), roundOff: true)
        //        let distribution = [volumePerWeekPerBodypart(muscle: muscleGroup)]
        
        let distribution = distributeSets(volumePerWeekPerBodypart(muscle: muscleGroup))
        /// Realm Object. Not to be passed around to the view. Just for viewmodel ops. Doesn't include sets or reps. Just exercise data that was decoded from JSON and stored RAW in Realm.
        let exerciseObjects = getExerciseObject(muscleGroup: muscleGroup, distribution: distribution)
        
        let exercises = createExercisesFromExerciseObject(exerciseObjects, distribution: distribution)
        
        for exercise in exercises {
            
            var processedMuscleGroups: Set<String> = []
            
            ///TODO: Instead of just checking in `exercise.realmObj.muscleGroups` we should also check in `exercise.realmObj.primaryMuscleGroups` cause we can find synergictics there too i.e., bicep as a synergistic muscle for closed grip lat pulldowns will only be found in `primaryMuscleGroups` and not in `muscleGroups`
            for secondaryMuscleGroup in exercise.realmObj.muscleGroups {
                
                if (secondaryMuscleGroup.activation_percent >= 0.6) && (secondaryMuscleGroup.group != exercise.realmObj.primaryMuscleGroups.first!.group) &&
                    !processedMuscleGroups.contains(secondaryMuscleGroup.group) {
                    switch secondaryMuscleGroup.group {
                    case "Abs":
                        absBucket = bucketSet(direct: absBucket.direct, indirect: (absBucket.indirect + Int((Double(exercise.sets.count)*secondaryMuscleGroup.activation_percent).rounded())))
                        print("(abs Direct: \(absBucket.direct) Indirect: \(absBucket.indirect))")
                    case "Biceps":
                        bicepsBucket = bucketSet(direct: bicepsBucket.direct, indirect: (bicepsBucket.indirect + Int((Double(exercise.sets.count)*secondaryMuscleGroup.activation_percent).rounded())))
                        print("(biceps Direct: \(bicepsBucket.direct) Indirect: \(bicepsBucket.indirect))")
                    case "Triceps":
                        tricepBucket = bucketSet(direct: tricepBucket.direct, indirect: (tricepBucket.indirect + Int((Double(exercise.sets.count)*secondaryMuscleGroup.activation_percent).rounded())))
                        print("(triceps Direct: \(tricepBucket.direct) Indirect: \(tricepBucket.indirect))")
                    case "Shoulders":
                        shoulderBucket = bucketSet(direct: shoulderBucket.direct, indirect: (shoulderBucket.indirect + Int((Double(exercise.sets.count)*secondaryMuscleGroup.activation_percent).rounded())))
                        print("(shoulders Direct: \(shoulderBucket.direct) Indirect: \(shoulderBucket.indirect))")
                        
                        /// MARK: For now, only triceps, abs, biceps, and shoulders are eligible synergetics
                        //                    case "Back":
                        //                        backBucket = bucketSet(direct: backBucket.direct, indirect: (backBucket.indirect + Int((Double(exercise.sets.count)*secondaryMuscleGroup.activation_percent).rounded())))
                        //                            print("(back Direct: \(backBucket.direct) Indirect: \(backBucket.indirect))")
                        //                    case "Chest":
                        //                        chestBucket = bucketSet(direct: chestBucket.direct, indirect: (chestBucket.indirect + Int((Double(exercise.sets.count)*secondaryMuscleGroup.activation_percent).rounded())))
                        //                        print("(chest Direct: \(chestBucket.direct) Indirect: \(chestBucket.indirect))")
                        //                    case "Legs":
                        //                        legsBucket = bucketSet(direct: legsBucket.direct, indirect: (legsBucket.indirect + Int((Double(exercise.sets.count)*secondaryMuscleGroup.activation_percent).rounded())))
                        //                        print("(legs Direct: \(legsBucket.direct) Indirect: \(legsBucket.indirect))")
                    default:
                        break
                    }
                    processedMuscleGroups.insert(secondaryMuscleGroup.group)
                }
            }
        }
        
        allExercises.append(contentsOf: exercises)
        
    }
    
    func calculateMuscleFrequency(for muscle: MuscleGroupEnum, in routineDays: [RoutineDay]) -> Int {
        var frequency = 0
        
        for day in routineDays {
            if day.muscleGroup.contains(muscle) {
                frequency += 1
            }
        }
        
        return frequency
    }
    
    func removeAndReAddExercise(muscleGroup: MuscleGroupEnum, newNumberOfSets: Int) {
        
        /// here we need to remove every item allExercises: [ExerciseViewDataModel] that has the muscleGroup of the muscleGroup.text that's passed into the function
        /// only keep/filter exercises that are not of the muscle group that was passed in
        removedExercises = allExercises.filter { $0.muscleGroup == muscleGroup.text }
        allExercises = allExercises.filter { $0.muscleGroup != muscleGroup.text }
        
        print("\nCutting: " + muscleGroup.text)
        
        removedExercises.forEach {
            print("Removed " + String($0.sets.count) + " sets of " + $0.name + " in "  + $0.muscleGroup)
        }
        
        /// A distribution: 11 sets → [4, 4, 3]
        /// So, 3 exercises -- the first two with 4 sets and the third one with 3
        //        let distribution = splitSetsIntoExercises(numOfSetsToSplit: numMuscleGroups, roundOff: false)
        
        let distribution = distributeSets(newNumberOfSets)
        
        /// Realm Object. Not to be passed around to the view. Just for viewmodel ops. Doesn't include sets or reps. Just exercise data that was decoded from JSON and stored RAW in Realm.
        let exerciseObjects = getExerciseObject(muscleGroup: muscleGroup, distribution: distribution)
        
        let exercises = createExercisesFromExerciseObject(exerciseObjects, distribution: distribution)
        
        print("Sets")
        
        exercises.forEach {
            print("count " + String($0.sets.count))
            
        }
        
        //only append if exercise. musclegroup == routineday.today.
        for exercise in exercises {
            if routineDays[currentDay-1].muscleGroup.contains(where: { $0.text == exercise.muscleGroup}) {
                allExercises.append(exercise)
            }
        }
        
        //        allExercises.append(contentsOf: exercises)
        
        //        for exercise in exercises {
        //
        //            print("Updated" + exercise.name)
        //
        //            allExercises.append(contentsOf: exercises)
        //
        //            for set in exercise.sets {
        //                print("\(String(format: "%g", set.targetWeight!)) x \(set.targetReps!)")
        //            }
        //        }
    }
    
    
    //    func calculateSetsPerSession() -> Int {
    //        let range = 15...25
    //
    //        switch userModel.last!.experience {
    //        case .beginner:
    //            if userModel.last!.workoutFrequency.int <= 4 {
    //                return 15
    //            } else {
    //                return 15
    //            }
    //        case .intermediate:
    //            if userModel.last!.workoutFrequency.int <= 4 {
    //                return 15
    //            } else {
    //                return 15
    //            }
    //        case .advanced:
    //            if userModel.last!.workoutFrequency.int <= 4 {
    //                return 15
    //            } else {
    //                return 15
    //            }
    //        }
    //    }
    
    func getExerciseObject(muscleGroup: MuscleGroupEnum, distribution:  [Int]) -> Array<Slice<Results<ExerciseModel>>.Element>.SubSequence {
        
        let exercises = exerciseModel
            .filter("ANY primaryMuscleGroups.group = '\(muscleGroup.text)'")
            .sorted(byKeyPath: (userModel.last!.gender == .male ? "maleBwRatio" : "femaleBwRatio"), ascending: false)
        ///TODO BRING BACK THE +3
            .prefix(distribution.count+3)
        
        let exerciseArray = Array(exercises).shuffled()
        
        let exerciseShuffled = exerciseArray.prefix(distribution.count)
        
        return exerciseShuffled
    }
    
    /// Creates Exercise (includes reps, sets) from exercise data Realm Oject
    func createExercisesFromExerciseObject(_ object: Array<Slice<Results<ExerciseModel>>.Element>.SubSequence, distribution: [Int]) ->  [ExerciseViewDataModel] {
        
        var exercises: [ExerciseViewDataModel] = []
        
        
        object.enumerated().forEach { (index, object) in
            var sets: [ExerciseSet] = []
            for _ in 1...distribution[index] {
                sets.append(ExerciseSet(targetWeight: 75, targetReps: getTargetReps(object)))
            }
            
            exercises.append(ExerciseViewDataModel(name: object.name, sets: sets, muscleGroup: object.muscleGroups.first!.group, realmObj: object))
        }
        
        return exercises
    }
    
    func getTargetReps(_ object: Slice<Results<ExerciseModel>>.Element) -> Int {
        if object.powerLift {
            return 8
        } else if object.highRepMovement {
            return 12
        } else {
            return 10
        }
    }
    
    func distributeSets(_ totalSets: Int) -> [Int] {
        
        var sets = totalSets
        var result = [Int]()
        
        while sets > 0 {
            
            if sets >= 6 {
                result.append(3)
                result.append(3)
                sets -= 6
            } else if sets >= 4 {
                result.append(4)
                sets -= 4
            } else if sets >= 3 {
                result.append(3)
                sets -= 3
            } else if sets >= 2 {
                result.append(2)
                sets = 0
            } else {
                sets = 0
            }
            
        }
        
        return result
        
    }
    
    func removeSynergistics(_ exercises: [ExerciseViewDataModel]) {
        /// Same as:
        /// if tricepsSPW.indirect > 0 {
        ///     let numberOfSets = tricepsSPW.direct - tricepsSPW.indirect
        ///     removeAndReAddExercise(muscleGroup: .triceps, newNumberOfSets: (numberOfSets < 0 ? 2 : numberOfSets))
        /// }
        
        muscleGroupData.allCases.forEach {
            if $0.bucket.indirect > 0 {
                /// look for Screen Recording 2023-12-22 at 8.34.52 PM for explaination
                let numberOfSets = $0.bucket.direct - $0.bucket.indirect
                removeAndReAddExercise(muscleGroup: $0.enumValue, newNumberOfSets: (numberOfSets >= 3 ? numberOfSets : 2))
            }
        }
    }
}

enum muscleGroupData: String, CaseIterable {
    case abs, biceps, triceps, shoulders, chest, legs, back
    
    var bucket: bucketSet {
        switch self {
        case .triceps:
            return tricepBucket
        case .biceps:
            return bicepsBucket
        case .shoulders:
            return shoulderBucket
        case .abs:
            return absBucket
        case .chest:
            return chestBucket
        case .legs:
            return legsBucket
        case .back:
            return backBucket
        }
    }
    
    var enumValue: MuscleGroupEnum {
        switch self {
        case .triceps:
            return .triceps
        case .biceps:
            return .biceps
        case .shoulders:
            return .shoulders
        case .abs:
            return .abs
        case .chest:
            return .chest
        case .legs:
            return .legs
        case .back:
            return .back
        }
    }
}

struct ExerciseViewDataModel: Identifiable {
    
    /// (!) Todo: this also needs to know certain info about the exercise to prepare the view such as isUnweighted or isCardio to strip out elements from the view
    public let id =  UUID()
    let name: String
    let sets: [ExerciseSet]
    let muscleGroup: String
    let realmObj: Slice<Results<ExerciseModel>>.Element
}

struct ExerciseSet: Identifiable {
    public let id =  UUID()
    let targetWeight: Double?
    let targetReps: Int?
}

struct bucketSet {
    let direct: Int
    let indirect: Int
}
