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
 
 Shtick of the app:
 
 With the app, you get a custom program. you can choose your no. of training days, split type, muscle focus. those programs the app generates are not pre-loaded templates. you could be the most advanced person on planet but can't generate plans that are better than the app, as the app does autoregulation (Altering training variables and fatigue management strategies based on needs rather than predetermined changes.) on the fly. It's totally evidence-based. Programs are generated in app by an algorithm that follows rules about training volume, frequency, work distribution etc and it supports *your* goals and needs & is deeply tailored to your goals.  you can edit the program / create a custom one. you can allow for cardio and the app automatically figures out the ideal cardio frequency for you and your goal. the app applies progressive overload for you automatically - unless you can pause it. it will use ai to recognize plateaus & swap exercise when it deems you can benefit from a change. it also has a AI form tracker which tracks your form to give you pointers on where you can improve.
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
