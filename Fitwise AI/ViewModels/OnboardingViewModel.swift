//
//  OnboardingViewModel.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/2/23.
//

import SwiftUI
import RealmSwift

final class OnboardingViewModel: ObservableObject {
    @ObservedResults(UserModel.self) var userModel
    let exerciseModel = ExerciseModel()
    
    @Published var totalOnboardingStates: Int
    @Published var onboardingState: Int = 2
    @Published var transition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    @Published var slider: Int = 3
    
    lazy var exercises = decodeJSON()
    
    //User
    @Published var gender: UserGenderEnum = .male
    @Published var name: String = ""
    @Published var weightString: String = ""
    @Published var bodyType: UserBodyTypeEnum = .fat
    @Published var experience: UserExperienceEnum = .beginner
    @Published var goal: UserGoalEnum = .loseWeight
    @Published var workoutDuration: UserWorkoutDurationEnum = .min45
    @Published var workoutFrequency: UserWorkoutFrequencyEnum = .threetimes
    @Published var workoutDays: UserWorkoutDayEnum = .monday
    @Published var tempArray: [UserWorkoutDayEnum] = []
    
    var weight: Double {
        return Double(weightString) ?? 50
    }
    
    init(totalOnboardingStates: Int) {
        self.totalOnboardingStates = totalOnboardingStates
    }
    
    //Functions
    func next() {
        transition = .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
        
        if onboardingState != totalOnboardingStates {
            withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                onboardingState += 1
            }
        } else if onboardingState == totalOnboardingStates {
            saveUser()
        }
    }
    
    func previous() {
        transition = .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
        
        if onboardingState != 0 {
            withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                onboardingState -= 1
            }
        }
    }
    
    func sliderFrequencyIntToUserWorkoutFrequencyEnum() -> UserWorkoutFrequencyEnum {
        return UserWorkoutFrequencyEnum(rawValue: Int((slider-2))) ?? .threetimes
    }
    
    
    func saveUser() {
        let newUser = UserModel(name: name, gender: gender, workoutFrequency: workoutFrequency, goal: goal, bodyType: bodyType, weight: weight, experience: experience, workoutDuration: workoutDuration, workoutDays: tempArray)
        newUser.isUserOnboarded = true
        $userModel.append(newUser)
    }
    
    
    func toggleSelection(for day: UserWorkoutDayEnum, isSelected: Bool) {
        if isSelected {
            tempArray.append(day)
        } else if let index = tempArray.firstIndex(of: day) {
            tempArray.remove(at: index)
        }
    }
    
    func seedAppData() {
        
        let realm = try! Realm()

        do {
            try realm.write {
                // Delete existing ExerciseModel objects (if any) and append fresh data to exerciseModel
                
                realm.delete(realm.objects(ExerciseModel.self))
                
                for exercise in exercises {
                    let newExercise = ExerciseModel(name: exercise.name, maleBwRatio: exercise.male_bw_ratio, femaleBwRatio: exercise.female_bw_ratio, aggressiveOverload: exercise.aggressive_overload, idJSON: exercise.id, paceCompatible: exercise.pace_compatible, repCompatible: exercise.rep_compatible, appIdJSON: exercise.app_id, powerLift: exercise.power_lift, hiitCompatible: exercise.hiit_compatible, notes: exercise.notes, highRepMovement: exercise.high_rep_movement, unweighted: exercise.unweighted, timeCompatible: exercise.time_compatible, twoSidedMovement: exercise.two_sided_movement)
                    newExercise.steps.append(objectsIn: exercise.steps)
                    
                    for equipment in exercise.equipment {
                        let equipment = EquipmentModel(name: equipment.name, group: equipment.group, Sdescription: equipment.description)
                        
                        newExercise.equipments.append(equipment)
                    }
                    
                    for primary_muscle_group in exercise.primary_muscle_groups {
                        let group = PrimaryMuscleGroupModel(activation_percent: primary_muscle_group.activation_percent, male_priority: primary_muscle_group.male_priority, female_priority: primary_muscle_group.female_priority, Sdescription: primary_muscle_group.description, display_name: primary_muscle_group.display_name, group: primary_muscle_group.group)
                        
                        newExercise.primaryMuscleGroups.append(group)
                    }
                    
                    for muscle_group in exercise.muscle_groups {
                        let group = MuscleGroupModel(activation_percent: muscle_group.activation_percent, male_priority: muscle_group.male_priority, female_priority: muscle_group.female_priority, Sdescription: muscle_group.description, display_name: muscle_group.display_name, group: muscle_group.group)
                        
                        newExercise.muscleGroups.append(group)
                    }
                    
                    realm.add(newExercise)
                }
            }
        } catch {
            fatalError("Error saving to Realm: \(error.localizedDescription)")
        }
    }
}

