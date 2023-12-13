//
//  decoder.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/12/23.
//

import Foundation

struct Exercise: Decodable {
    // to persist them, these models probably need to exist in the database, and their values just get populated.
    struct MuscleGroups: Decodable {
        let activation_percent: Double
        let male_priority: Int
        let female_priority: Int
        let description: String
        let display_name: String
        let group: String
    }
    struct PrimaryMuscleGroups: Decodable {
        let activation_percent: Double
        let male_priority: Int
        let female_priority: Int
        let description: String
        let display_name: String
        let group: String
    }
    struct Equipment: Decodable {
        let group: String
        let description: String
        let name: String
    }
    let aggressive_overload: Bool
    let male_bw_ratio: Double
    let pace_compatible: Bool
    let id: String
    let muscle_groups: [MuscleGroups]
    let rep_compatible: Bool
    let app_id: String?
    let notes: String
    let hiit_compatible: Bool
    let power_lift: Bool
    let high_rep_movement: Bool
    let primary_muscle_groups: [PrimaryMuscleGroups]
    let overloadable: Bool
    let steps: [String]
    let two_sided_movement: Bool
    let name: String
    let time_compatible: Bool
    let equipment: [Equipment]
    let female_bw_ratio: Double
}

func decodeJSON() -> [Exercise] {
    guard let sourceURL = Bundle.main.url(forResource: "exercises", withExtension: "json") else {
        fatalError("Could not find exercises.json")
    }
    
    guard let exerciseData = try? Data(contentsOf: sourceURL) else {
        fatalError("Could not convert data")
    }
    
    let decoder = JSONDecoder()
    
    // TODO: Check this with an if-let
    let exercises = try! decoder.decode([Exercise].self, from: exerciseData)
    
    return exercises
}
