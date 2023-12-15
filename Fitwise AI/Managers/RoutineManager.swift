//
//  TrainingSplit.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/5/23.
//

import Foundation
import RealmSwift

func generateRoutine() -> [RoutineDay] {
    
    let realm = try! Realm()
    let target = realm.objects(UserModel.self).last?.workoutFrequency.int

    //TODO: Put these into a separate file
    //TODO: Cardio
    //TODO: 7-day split
    
    switch target {
    case 2:
        //Full Body x2 [No abs]
        let day1 = RoutineDay(dayIndex: 1, muscleGroup: [.legs, .back, .chest, .biceps, .shoulders, .triceps])
        let day2 = RoutineDay(dayIndex: 1, muscleGroup: [.legs, .back, .chest, .biceps, .shoulders, .triceps])
        return [day1, day2]
    case 3:
        //Push Pull Legs
        let day1 = RoutineDay(dayIndex: 1, muscleGroup: [.chest, .shoulders, .triceps, .abs])
        let day2 = RoutineDay(dayIndex: 2, muscleGroup: [.back, .biceps, .abs])
        let day3 = RoutineDay(dayIndex: 3, muscleGroup: [.legs, .abs])
        return [day1, day2, day3]
    case 4:
        //4 Day Classic "Bro-ey" Split
        let day1 = RoutineDay(dayIndex: 1, muscleGroup: [.chest, .triceps, .abs])
        let day2 = RoutineDay(dayIndex: 2, muscleGroup: [.back, .biceps, .abs])
        let day3 = RoutineDay(dayIndex: 3, muscleGroup: [.shoulders, .abs])
        let day4 = RoutineDay(dayIndex: 4, muscleGroup: [.legs, .abs])
        return [day1, day2, day3, day4]
    case 5:
        //Push Pull Legs Upper Lower (PPLUL)
        let day1 = RoutineDay(dayIndex: 1, muscleGroup: [.chest, .shoulders, .triceps, .abs])
        let day2 = RoutineDay(dayIndex: 2, muscleGroup: [.back, .biceps, .abs])
        let day3 = RoutineDay(dayIndex: 3, muscleGroup: [.legs, .abs])
        let day4 = RoutineDay(dayIndex: 4, muscleGroup: [.chest, .back, .shoulders, .biceps, .triceps])
        let day5 = RoutineDay(dayIndex: 5, muscleGroup: [.legs, .abs])
        return [day1, day2, day3, day4, day5]
    case 6:
        //Push Pull Legs x2
        let day1 = RoutineDay(dayIndex: 1, muscleGroup: [.chest, .shoulders, .triceps, .abs])
        let day2 = RoutineDay(dayIndex: 2, muscleGroup: [.back, .biceps, .abs])
        let day3 = RoutineDay(dayIndex: 3, muscleGroup: [.legs, .abs])
        let day4 = RoutineDay(dayIndex: 4, muscleGroup: [.chest, .shoulders, .triceps, .abs])
        let day5 = RoutineDay(dayIndex: 5, muscleGroup: [.back, .biceps, .abs])
        let day6 = RoutineDay(dayIndex: 6, muscleGroup: [.legs, .abs])
        return [day1, day2, day3, day4, day5, day6]
    case 7:
        fatalError("Split not programmed yet")
    default:
        let day1 = RoutineDay(dayIndex: 1, muscleGroup: [.chest, .shoulders, .triceps, .abs])
        let day2 = RoutineDay(dayIndex: 2, muscleGroup: [.back, .biceps, .abs])
        let day3 = RoutineDay(dayIndex: 3, muscleGroup: [.legs, .abs])
        return [day1, day2, day3]
    }
    
    //no if else to check for user target days in this branch
    
}

/*
 I don't have any problem with pre-populating the workout as long as they can be altered on the go. Altering would mean the exercise have some 'source of truth' - and changing that source of truth would mean the routine day  gets altered. Ofc that source of truth can't be the app's code because there's no way to edit the app's code from app. It's possible in the sense that I can append items to an array but they won't be persisted. So I can hardcode the workout info for every case and then init it  when the app runs and save it to Realm. When I need to make any changes, I just read the saved data from realm, edit it and re-save it to realm. Bc the entire app is reading from Realm, changes are reflected everywhere.
 */
