//
//  HistoryView.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/24/23.
//

import SwiftUI
import RealmSwift
import SwiftDate

struct HistoryView: View {
    
    @ObservedResults(WorkoutModel.self) var workoutModel
    @State private var multiSelection = Set<ObjectId>()

    var body: some View {
        NavigationStack {
            List {
                ForEach(workoutModel) { workout in
//                    if workout.isFinished {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(workout.name)
                                .font(.headline)
                            Text(workout.startDate.toFormat("dd MMM yyyy 'at' HH:mm"))
                                .foregroundStyle(.secondary)
                                .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 4){
                                ForEach(workout.exercises, id: \.self) { exercise in
                                    if (exercise.sets.first != nil && exercise.sets.first!.isChecked) {
                                        Text(exercise.name)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
//                    }
                }
                .onDelete { indexSet in
                    $workoutModel.remove(atOffsets: indexSet)
                }
            }
            .listStyle(.plain)
            .navigationTitle("History")
            .toolbar {
                EditButton()
            }
            .overlay {
                if workoutModel.isEmpty {
                    if #available(iOS 17.0, *) {
                        ContentUnavailableView(
                            /// TODO: Easter egg
                            "No Workouts Performed... Yet",
                            systemImage: "figure.gymnastics"
                        )
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
