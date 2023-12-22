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
    
    @State private var showingAlert = false
    
    @ObservedObject private var svm: SharedViewModel
    
    init(sharedViewModel: SharedViewModel) {
        self.svm = sharedViewModel
    }

    var body: some View {
        
        NavigationStack {
            VStack {
                List {
                    Section {
                        Button("Start a Workout", systemImage: "plus") {
                        }
                    }
                    
                    
                    Section{
                        ForEach(svm.allExercises) { exercise in
                            VStack(alignment: .leading) {
                                Text(exercise.name + " - \(exercise.muscleGroup)")

                                HStack(spacing: 0) {
                                    if let weight = exercise.sets.first!.targetWeight {
                                        Text("\(String(format: "%g", (weight))) x ")
                                    }
                                    Text("\(exercise.sets.first!.targetReps!) x ")
                                    Text("\(exercise.sets.count)")
                                }
                                .foregroundStyle(.secondary)
                            }
                        }
                    } header: {
                        Text("Day \(svm.currentDay)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 3)
                    }
                    
                    Button("Fuck it") {
                        svm.removeAll()
                    }
                    
                    Text("\(svm.routineDays.count)")
                    
//                    ForEach(routineDays, id: \.self) { day in
//                        Section {
//                            #warning("Exercises are not sorted properly")
//                            //TODO: Sorting is bad! It should be as-it-is. Instead, it's picking muscle groups at random?
//                            ForEach(day.muscleGroup, id: \.self) { muscleGroup in
//                                Text(muscleGroup.text)
//                                    .font(.title2)
//                                    .fontWeight(.semibold)
//                                
//                                if day.dayIndex == currentDay {
//                                    let exercises = hvm.getExercises(muscleGroup, 8)
//                                    
//                                    ForEach(exercises) { exercise in
//                                        Text("\(exercise.name)")
//                                            .padding(.leading, 15)
//                                    }
//                                }
//                            }
//                        } header: {
//                            Text("Day \(day.dayIndex)")
//                                .font(.title3)
//                                .fontWeight(.semibold)
//                                .padding(.vertical, 3)
//                        }
//                    }
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print(svm.allExercises.first!.name)
                    } label: {
                        Label("Stats", systemImage: "chart.bar")
                    }
                }
            }
        }
    }
}
