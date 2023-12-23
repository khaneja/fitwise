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
    @EnvironmentObject private var svm: SharedViewModel
    @StateObject private var hvm = HomeViewModel()
    @State private var showingAlert = false
    @State private var showWorkoutView = false


    var body: some View {
        
        NavigationStack {
            VStack {
                List {
                    Section {
                        Button("Start Workout", systemImage: "play.circle") {
                            /// TODO (!) — The user in any case should not be able to start a new workout if the previous one hasn't been 1) deleted or 2) marked as finished
                            hvm.startWorkout(svm.allExercises)
                            showWorkoutView = true
                        }
                        .fullScreenCover(isPresented: $showWorkoutView, content: WorkoutView.init)
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
//        .onChange(of: svm.totalTrainingDays) { _ in
//            /// TODO: If there's a workout going on, don't regenerate the workout plan without showing an alert to the user that a workout is going on and chaning the plan is gonig to lose all the sets and shit
//            svm.start()
//        }
    }
}
