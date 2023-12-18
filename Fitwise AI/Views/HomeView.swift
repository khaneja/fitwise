//
//  HomeView.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/3/23.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    @ObservedResults(UserModel.self) var User
    @StateObject private var hvm = HomeViewModel()

    
    var body: some View {
        let routineDays = generateRoutine()
        
        //TODO: Right now, the current day is hardcoded. Make it dynamic!
        let currentDay = 1
        
        NavigationStack {
            VStack {
                List {
                    Section {
                        Button("Start a Workout", systemImage: "plus") {
                        }
                    }
                    
                    ForEach(routineDays, id: \.self) { day in
                        Section {
                            #warning("Exercises are not sorted properly")
                            //TODO: Sorting is bad! It should be as-it-is. Instead, it's picking muscle groups at random?
                            ForEach(day.muscleGroup, id: \.self) { muscleGroup in
                                Text(muscleGroup.text)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                if day.dayIndex == currentDay {
                                    let exercises = hvm.getExercises(muscleGroup)
                                    
                                    ForEach(exercises) { exercise in
                                        Text("\(exercise.name)")
                                            .padding(.leading, 15)
                                    }
                                }
                            }
                        } header: {
                            Text("Day \(day.dayIndex)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.vertical, 3)
                        }
                    }
                }
                .listStyle(.grouped)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationTitle("Fitwise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar() {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(UserWorkoutFrequencyEnum.allCases, id: \.self) { btn in
                            Button("\(btn.text)", action: {
                                do {
                                    let realm = try Realm()
                                    if let user = realm.objects(UserModel.self).last {
                                        try realm.write {
                                            user.workoutFrequency = btn
                                        }
                                    }
                                } catch {
                                    print("Error updating user name: \(error.localizedDescription)")
                                }
                            })
                        }
                    } label: {
                        Label("Frequency", systemImage: "target")
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
