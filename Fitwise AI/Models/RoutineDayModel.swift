//
//  WorkoutModel.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/5/23.
//

import Foundation
import RealmSwift

class RoutineDay: Object, ObjectKeyIdentifiable {
    @Persisted var dayIndex: Int
    @Persisted var _muscleGroup = List<Int>()
    
    convenience init(dayIndex: Int, muscleGroup: [MuscleGroupEnum]) {
        self.init()
        self.dayIndex = dayIndex
        self.muscleGroup = muscleGroup
    }
}

extension RoutineDay {
    var muscleGroup: [MuscleGroupEnum] {
        get {
            return _muscleGroup
                .compactMap { MuscleGroupEnum(rawValue: $0) }
                .sorted { $0.rawValue < $1.rawValue }
        }
        
        set {
            _muscleGroup.removeAll()
            let intValues = newValue.map { $0.rawValue }.sorted()
            _muscleGroup.append(objectsIn: intValues)
        }
    }
}

enum MuscleGroupEnum: Int, PersistableEnum {
    case back, biceps, chest, triceps, legs, shoulders, abs, bodyweight, cardio, forearm
    
    var text: String {
        switch self {
        case .abs: return "Abs"
        case .biceps: return "Biceps"
        case .bodyweight: return "Bodyweight"
        case .cardio: return "Cardio"
        case .chest: return "Chest"
        case .shoulders: return "Shoulders"
        case .triceps: return "Triceps"
        case .back: return "Back"
        case .legs: return "Legs"
        case .forearm: return "Forearm"
        }
    }
    
//    enum MuscleGroupsCategoryEnum {
//        case abs, arms, legs, back, chest, shoulders, glutes, cardio, bodyweight
//    }
//    
//    static func muscleGroupsCategoryEnum(_ category: MuscleGroupsCategoryEnum) -> [MuscleGroupEnum] {
//        switch category {
//        case .abs:
//            return [.abs, .obliques]
//        case .arms:
//            return [.biceps, .forearms, .triceps]
//        case .legs:
//            return [.calves, .hamstrings, .quads]
//        case .back:
//            return [.lats, .lowerBack, .traps]
//        case .chest:
//            return [.chest]
//        case .shoulders:
//            return [.shoulders]
//        case .glutes:
//            return [.glutes]
//        case .cardio:
//            return [.cardio]
//        case .bodyweight:
//            return [.bodyweight]
//        }
//    }
}

