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
        let user = User.last
        
        let routineDays = generateRoutine()
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(routineDays, id: \.self) { day in
                        Text("Day \(day.dayIndex)")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.vertical)
                            
                        ForEach(day.muscleGroup, id: \.self) { muscleGroup in
                            Text(muscleGroup.text)
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            let exercises = hvm.getExercises(muscleGroup, 3)
                            
                            ForEach(exercises) { exercise in
                                Text("\(exercise.name)")
                            }
                        }
                    }
                }
                .padding()
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
