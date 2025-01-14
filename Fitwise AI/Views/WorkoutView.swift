//
//  WorkoutView.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/17/23.
//

import SwiftUI
import RealmSwift


struct WorkoutView: View {
    
    ///TODO: Make this view like the overcase player view. Instead of cover, put the 3d model. Instead of podcast notes, put exercise notes and steps. Instead of speed controls put muscle groups or previous info. or best-reps info.
    
    @ObservedResults(WorkoutModel.self) var workoutModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var svm: SharedViewModel

    @StateObject var wvm = WorkoutViewModel()
    
    @State var isRunning = false
    @State private var startTime = Date()
    @State private var display = "00:00"
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(Array(workoutModel.last!.exercises.enumerated()), id: \.offset) { exerciseIndex, exercise in
                        Text(exercise.name)
                            .padding()
                            .fontWeight(.medium)
                        
                        setGroupBannerView
                        
                        ForEach(Array(exercise.sets.enumerated()), id: \.offset)  { setIndex, set in
                            NumberCell(
                                setIndex: setIndex,
                                exerciseIndex: exerciseIndex,
                                exercise: exercise,
                                targetWeight: set.weight,
                                targetReps: set.reps)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("\(workoutModel.last!.name)").font(.headline)
                        Text(display)
                            .foregroundStyle(.secondary)
                            .onReceive(timer) { _ in
                                let duration = Date().timeIntervalSince(workoutModel.last!.startDate)
                                let formatter = DateComponentsFormatter()
                                formatter.allowedUnits = [.minute, .second]
                                formatter.unitsStyle = .positional
                                formatter.zeroFormattingBehavior = .pad
                                display = formatter.string(from: duration) ?? ""
                            }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Finish") {
                        wvm.finishWorkout()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                        svm.presentationParentShouldDiscardWorkout = true
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }
        }
    }
}

struct NumberCell: View {
    @ObservedResults(WorkoutModel.self) var workoutModel
//    @ObservedResults(WorkoutExerciseModel.self) var workoutExerciseModel

    @StateObject private var wvm = WorkoutViewModel()
    
    @FocusState var isWeightFocused: Bool
    @FocusState var isRepsFocused: Bool
    
    @State private var weight = ""
    @State private var reps = ""
    
    let setIndex: Int
    let exerciseIndex: Int
    let exercise: WorkoutExerciseModel
    let targetWeight: Double
    let targetReps: Int
    
    var body: some View {
        
        let exerciseHistory = try! Realm().objects(WorkoutExerciseModel.self)
            .filter("name = '\(exercise.name)'")
        
        HStack {
            HStack(spacing: 0) {
                Text("\(setIndex + 1)")
                    .frame(width: UIScreen.main.bounds.size.width / 5)
                
                /// Only go inside the if clozure if exerciseHistory is equal to or great than 2 AND if preivous instance's set is checked (ie, the user complete it).
                if (exerciseHistory.count >= 2) && (setIndex < exerciseHistory[exerciseHistory.count - 2].sets.count) && (exerciseHistory[exerciseHistory.count - 2].sets[setIndex].isChecked == true) {
                    let set = exerciseHistory[exerciseHistory.count - 2].sets[setIndex]
                    Text("\(String(format: "%g", set.weight)) × \(set.reps)")
                        .frame(width: UIScreen.main.bounds.size.width / 5)
                } else {
                    Text("—")
                        .frame(width: UIScreen.main.bounds.size.width / 5)
                        .foregroundStyle(.secondary)
                }
                
                TextField("\(String(format: "%g", targetWeight))", text: $weight)
                    .focused($isWeightFocused, equals: true)
                    .frame(maxWidth: 60)
                    .fixedSize()
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .frame(width: UIScreen.main.bounds.size.width / 5)
                
                TextField("\(targetReps)", text: $reps)
                    .focused($isRepsFocused, equals: true)
                    .frame(maxWidth: 40)
                    .fixedSize()
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .frame(width: UIScreen.main.bounds.size.width / 5)
                
                Button {
                    // quick enter weight:
                    if weight.isEmpty {
                        weight = String(format: "%g", targetWeight)
                    }
                    // quick enter reps:
                    if reps.isEmpty {
                        reps = String(targetReps)
                    }
                    
                    wvm.markSetCompleted(forExerciseAtIndex: exerciseIndex, forSetAtIndex: setIndex, weight: Double(weight)!, reps: Int(reps)!)
                    isRepsFocused = false
                    isWeightFocused = false
                    
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 30)
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.bordered)
                .tint(workoutModel.last!.exercises[exerciseIndex].sets[setIndex].isChecked ? .green : .gray)
                .frame(width: UIScreen.main.bounds.size.width / 5)
                .opacity(weight.isEmpty && reps.isEmpty ? 0.8 : 1)
            }
        }
        .onAppear {
            /// if on appear, a set is already check, that means it's a recovered workout. So if that's the case, we're taking values from realm and setting them and pre-populating them in the textfields as strings
            if exercise.sets[setIndex].isChecked {
                weight = String(format: "%g", exercise.sets[setIndex].weight)
                reps = String(exercise.sets[setIndex].reps)
            }
        }
    }
}


extension WorkoutView {
    private var setGroupBannerView: some View {
        VStack {
            HStack(spacing: 0) {
                Text("SET")
                    .frame(width: UIScreen.main.bounds.size.width/5)
                
                Text("PERVIOUS")
                    .frame(width: UIScreen.main.bounds.size.width/5)
                
                Text("KG")
                    .frame(width: UIScreen.main.bounds.size.width/5)
                
                Text("REPS")
                    .frame(width: UIScreen.main.bounds.size.width/5)
                
                Text(Image(systemName: "checkmark"))
                    .frame(width: UIScreen.main.bounds.size.width/5)
                
            }
            .padding(.bottom, 5)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        
    }
}

