//
//  FitwiseApp.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/2/23.
//

/*
 -------
 MVMM Architecture
 
 Model: data point
 View: UI
 ViewModel: orchestrates Models for View
 -------
 
 Crux of the app:
 
 with the app, you get a custom program. you can choose your no. of training days, split type, muscle focus. those programs the app generates are not pre-loaded templates. they are generated in app by an algorithm that follows rules about training volume, frequency, work distribution etc. you can edit the program / create a custom one. you can allow for cardio and the app automatically figures out the ideal cardio frequency for you and your goal. the app applies progressive overload for you automatically - unless you can pause it. it will use ai to recognize plateaus & swap exercise when it deems you can benefit from a change. it also has a AI form tracker which tracks your form to give you pointers on where you can improve.
 */

import SwiftUI

@main
struct FitwiseApp: App {
    
    var body: some Scene {
        WindowGroup {
            EntryView()
                .onAppear {
                    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
                }
        }
    }
}
