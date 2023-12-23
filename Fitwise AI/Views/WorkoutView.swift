//
//  WorkoutView.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/17/23.
//

import SwiftUI
import RealmSwift


/// TODO move all the code to vm


struct WorkoutView: View {
    @ObservedResults(WorkoutModel.self) var workoutModel
    @Environment(\.dismiss) var dismiss
    @State private var weight: Int?
    @State private var reps: Int?
    
    @EnvironmentObject private var svm: SharedViewModel
    @StateObject private var wvm = WorkoutViewModel()
    
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
                            NumberCell(setIndex: setIndex, exerciseIndex: exerciseIndex, previousWeight: "NIL", targetWeight: set.weight, targetReps: set.reps)
                        }
                    }
                }
                .padding()
                
                VStack {
                    Button("Discard Workout") {
                        
                        dismiss()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            let realm = try! Realm()
                            
                            let obj = realm.objects(WorkoutModel.self).last!
                                                                                    
                            try! realm.write {
                                realm.delete(obj)
                            }
                                                        
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("\(workoutModel.last!.name)").font(.headline)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    /// TODO: Alert the user if they're trying to finish without having completed all the sets. Don't let them finish if the workout is empty.
                    Button("Finish") {
                        
                        /// Not writing to workoutModel because it's a frozen object? I don't know what the heck that means but the app crashes if I do it with the property wrapper var
                        let realm = try! Realm()
                        let obj = realm.objects(WorkoutModel.self).last!
                        
                        try! realm.write {
                            obj.isFinished = true
                        }
                        
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
        }
    }
    
    struct NumberCell: View {
        @FocusState var isWeightFocused: Bool
        @FocusState var isRepsFocused: Bool
        
        @State private var weight = ""
        @State private var reps = ""
        
        let setIndex: Int
        let exerciseIndex: Int
        let previousWeight: String
        let targetWeight: Double
        let targetReps: Int
        
        @ObservedResults(WorkoutModel.self) var workoutModel

        
        var body: some View {
            
            HStack {
                HStack(spacing: 0) {
                    Text("\(setIndex + 1)")
                        .frame(width: UIScreen.main.bounds.size.width / 5)
                    
                    Text(previousWeight)
                        .frame(width: UIScreen.main.bounds.size.width / 5)
                    
                    TextField("\(String(format: "%g", targetWeight))", text: $weight)
                        .focused($isWeightFocused, equals: true)
                        .frame(maxWidth: 80)
                        .fixedSize()
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(width: UIScreen.main.bounds.size.width / 5)
                    
                    //                TextField("\(targetReps)", value: $reps, formatter: NumberFormatter())
                    
                    TextField("\(targetReps)", text: $reps)
                        .focused($isRepsFocused, equals: true)
                        .frame(maxWidth: 40)
                        .fixedSize()
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(width: UIScreen.main.bounds.size.width / 5)
                    
                    Button {
                        if !reps.isEmpty {
                           reps = ""
                        }
                        
                        // quick enter weight:
                        if weight.isEmpty {
                            weight = String(targetWeight)
                        }
                        // quick enter reps: 
                        if reps.isEmpty {
                            reps = String(targetReps)
                        }
                        print("Entered: \(weight) x \(reps)")
                        try! Realm().write {
                            workoutModel.thaw()?.last!.exercises[exerciseIndex].sets[setIndex].isChecked.toggle()
                        }
                        
                        isRepsFocused = false
                        isWeightFocused = false
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    // disable unless values are entered in the form
                    .buttonStyle(.bordered)
                    .tint(workoutModel.last!.exercises[exerciseIndex].sets[setIndex].isChecked ? .green : .gray)
                    .frame(width: UIScreen.main.bounds.size.width / 5)
//                    .disabled(weight.isEmpty && reps.isEmpty)
                    .opacity(weight.isEmpty && reps.isEmpty ? 0.8 : 1)
                }
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

