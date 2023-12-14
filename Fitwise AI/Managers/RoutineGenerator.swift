//
//  TrainingSplit.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/5/23.
//

import Foundation
import RealmSwift

//We want this function to spit out routine in the form of routineDay, meaning routine day 1 -> group to target is this this and this.

func routineGenerator() -> [RoutineDay] {
    
    //no if else to check for user target days in this branch
    let day1 = RoutineDay(dayIndex: 1, muscleGroup: [.chest, .shoulders, .triceps, .abs])
    let day2 = RoutineDay(dayIndex: 2, muscleGroup: [.back, .biceps, .abs])
    let day3 = RoutineDay(dayIndex: 3, muscleGroup: [.legs, .abs])
    
    return [day1, day2, day3]
}

/*
 I don't have any problem with pre-populating the workout as long as they can be altered on the go. Altering would mean the exercise have some 'source of truth' - and changing that source of truth would mean the routine day  gets altered. Ofc that source of truth can't be the app's code because there's no way to edit the app's code from app. It's possible in the sense that I can append items to an array but they won't be persisted. So I can hardcode the workout info for every case and then init it  when the app runs and save it to Realm. When I need to make any changes, I just read the saved data from realm, edit it and re-save it to realm. Bc the entire app is reading from Realm, changes are reflected everywhere.
 */
