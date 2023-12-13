//
//  UserModel.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/2/23.
//

import Foundation
import RealmSwift

class UserModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var age: Int
    @Persisted var gender: UserGenderEnum
    @Persisted var workoutFrequency: UserWorkoutFrequencyEnum
    @Persisted var goal: UserGoalEnum
    @Persisted var bodyType: UserBodyTypeEnum
    @Persisted var experience: UserExperienceEnum
    @Persisted var workoutDuration: UserWorkoutDurationEnum
    @Persisted var _workoutDays = List<Int>()
    @Persisted var isUserOnboarded: Bool = false

    convenience init(name: String, gender: UserGenderEnum, workoutFrequency: UserWorkoutFrequencyEnum, goal: UserGoalEnum, bodyType: UserBodyTypeEnum, experience: UserExperienceEnum, workoutDuration: UserWorkoutDurationEnum, workoutDays: [UserWorkoutDayEnum]) {
        self.init()
        self.name = name
        self.gender = gender
        self.workoutFrequency = workoutFrequency
        self.goal = goal
        self.bodyType = bodyType
        self.experience = experience
        self.workoutDuration = workoutDuration
        self.workoutDays = workoutDays
    }
}

extension UserModel {
    
    //anytime I - workoutdays — is called, my job is to call the "fake" _workoutdays and take all elements from her one by one and plug them into UserWorkoutDaysEnum(rawValue: x) to give you the enum case back. anytime the code sets any value to me,  i basically force the "fake" _workoutdays to throw all its prev values, i do the work of converting any values set on me to like  'Monday,' 'Wednesday,' 'Friday,' to their raw value + sort them & give them back to the fake workout days. ($0 literally means an enum item like .monday, .friday since $0 refers to each element of the array passed to it.)
    var workoutDays: [UserWorkoutDayEnum] {
        get {
            return _workoutDays
                .compactMap { UserWorkoutDayEnum(rawValue: $0) }
                .sorted { $0.rawValue < $1.rawValue }
        }
        
        set {
            _workoutDays.removeAll()
            let intValues = newValue.map { $0.rawValue }.sorted()
            _workoutDays.append(objectsIn: intValues)
        }
    }
}

//MARK: ENUMS

enum UserGenderEnum: String, PersistableEnum {
    case male, female, nonbinary
    
    var text: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .nonbinary:
            return "Non-binary"
        }
    }
}

enum UserBodyTypeEnum: String, PersistableEnum {
    case skinny, muscular, fat
    
    var text: String {
        switch self {
        case .skinny:
            return "Naturally Skinny"
        case .muscular:
            return "Naturally Muscular"
        case .fat:
            return "Naturally High Bodyfat"
        }
    }
}

enum UserExperienceEnum: String, PersistableEnum {
    case beginner, intermediate, advanced
    
    var text: String {
        switch self {
        case .beginner:
            return "I'm a beginner"
        case .intermediate:
            return "I'm intermediate"
        case .advanced:
            return "I'm advanced, bro"
        }
    }
    
    var tip: String {
        switch self {
        case .beginner:
            return "Lifting for less than 6 months"
        case .intermediate:
            return "Lifiting for 6 - 18 months"
        case .advanced:
            return "Lifting for over 2 years"
        }
    }
}

enum UserGoalEnum: String, PersistableEnum {
    case bodybuilding, strength, loseWeight
    
    var text: String {
        switch self {
        case .bodybuilding:
            return "Look Muscular & Toned"
        case .strength:
            return "Get Stronger, Faster"
        case .loseWeight:
            return "Lose Fat"
        }
    }
}

enum UserWorkoutDurationEnum: String, PersistableEnum {
    case min30, min45, min60, min90
    
    var int: Int {
        switch self {
        case .min30:
            return 30
        case .min45:
            return 45
        case .min60:
            return 60
        case .min90:
            return 90
        }
    }
    
    var text: String {
        switch self {
        case .min30:
            return "30m"
        case .min45:
            return "45m"
        case .min60:
            return "1h"
        case .min90:
            return "1h 30m"
        }
    }
}

enum UserWorkoutFrequencyEnum: Int, PersistableEnum {
    case twotimes, threetimes, fourtimes, fivetimes, sixtimes, seventimes
    
    var int: Int {
        switch self {
        case .twotimes:
            return 2
        case .threetimes:
            return 3
        case .fourtimes:
            return 4
        case .fivetimes:
            return 5
        case .sixtimes:
            return 6
        case .seventimes:
            return 7
        }
    }
    
    var text: String {
        switch self {
        case .twotimes:
            return "2 Times / Week"
        case .threetimes:
            return "3 Times / Week"
        case .fourtimes:
            return "4 Times / Week"
        case .fivetimes:
            return "5 Times / Week"
        case .sixtimes:
            return "6 Times / Week"
        case .seventimes:
            return "7 Times / Week"
        }
    }
    
    var tip: String {
        switch self {
        case .twotimes:
            return "Recommended for absolute beginners."
        case .threetimes:
            return "Recommended for beginners & intermediate users."
        case .fourtimes:
            return "Recommended for intermediate users."
        case .fivetimes:
            return "Recommended for intermediate & advanced users."
        case .sixtimes:
            return "Advanced users only."
        case .seventimes:
            return "Not recommended; high risk of overtraining!"
        }
    }
}

enum UserWorkoutDayEnum: Int, PersistableEnum {
    
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    public var id: Self {
        self
    }
    
    var text: String {
        switch self {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
    }
}
