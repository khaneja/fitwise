////
////  WorkoutView.swift
////  Fitwise AI
////
////  Created by Keshav Khaneja on 12/17/23.
//


/*

 
 
 VIEWS TAKE A LOT OF TIME AND TWEAKING TO DESIGN
 
 
 DON'T WORK ON VIEWS UNTIL THE FUNCTIONS BEHIND THE VIEW ARE COMPLETED.
 
 
 LAY THE GROUND FIRST. THEN BUILD ON TOP OF IT.
 
 
 TEST OUTPUTS THROUGH CONSOLE. NOT BY DESIGNING A VIEW FOR THEM -- WHICH IS INEVITABLY GOING TO CHANCE.
 
 
 FALSE SENSE OF PROGRESS WHEN EVERYTHING LOOKS LIKE IT'S LAID OUT, BUT THE FUNTIONS THAT RUN THE VIEW ARE MISSING.
 
 
 DIRECT SWIFT IS ALSO  FASTER TO WORK WITH THAN SWIFTUI.
 
 
 
 
*/





//
//import SwiftUI
//import RealmSwift
//
//struct WorkoutView: View {
//    @StateObject private var hvm = HomeViewModel()
//    @StateObject private var svm = SharedViewModel()
//    
//    var body: some View {
//        
//        VStack {
//            Menu("Options"){
//                ForEach(UserWorkoutFrequencyEnum.allCases, id: \.self) { btn in
//                    Button("\(btn.text)", action: {
//                        do {
//                            let realm = try Realm()
//                            if let user = realm.objects(UserModel.self).last {
//                                try realm.write {
//                                    user.workoutFrequency = btn
//                                }
//                            }
//                        } catch {
//                            print("Error updating user name: \(error.localizedDescription)")
//                        }
//                    })
//                }
//            }
//            ScrollView {
//                VStack(alignment: .leading) {
//                    ForEach(svm.allExercises) { exercise in
//                        Text(exercise.name + "(\(exercise.muscleGroup))")
//                        
//                        ForEach(Array(exercise.sets.enumerated()), id: \.offset)  { index, set in
//                            Text("\(index+1): \(String(format: "%g", set.targetWeight!)) x \(set.targetReps!)")
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//
//
//

























import SwiftUI

struct WorkoutView: View {
        
    @State private var weight: Int?
    @State private var reps: Int?
    
    @ObservedObject private var svm: SharedViewModel
    
    init(sharedViewModel: SharedViewModel) {
        self.svm = sharedViewModel
    }
    
    let routineDays = generateRoutine()
    //TODO: Right now, the current day is hardcoded. Make it dynamic!
    let currentDay = 1
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                
                ForEach(svm.allExercises) { exercise in
                    Text(exercise.name)
                        .padding()
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    topView
                    
                    ForEach(Array(exercise.sets.enumerated()), id: \.offset)  { index, set in
                        
                        /// cell view
                        ExerciseSetCellView(weight: $weight, reps: $reps, setIndex: index, previousWeight: "NEW", targetWeight: set.targetWeight!, targetReps: set.targetReps!)
                    }
                }
            }
        }
    }
    
    struct ExerciseSetCellView: View {
        @Binding var weight: Int?
        @Binding var reps: Int?
        let setIndex: Int
        let previousWeight: String
        let targetWeight: Double
        let targetReps: Int
        
        var body: some View {
            HStack {
                HStack(spacing: 0) {
                    Text("\(setIndex + 1)")
                        .frame(width: UIScreen.main.bounds.size.width / 5)
                    
                    Text(previousWeight)
                        .frame(width: UIScreen.main.bounds.size.width / 5)
                    
                    TextField("\(String(format: "%g", targetWeight))", value: $weight, formatter: NumberFormatter())
                        .frame(maxWidth: 80)
                        .fixedSize()
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(width: UIScreen.main.bounds.size.width / 5)
                    
                    TextField("\(targetReps)", value: $reps, formatter: NumberFormatter())
                        .frame(maxWidth: 40)
                        .fixedSize()
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(width: UIScreen.main.bounds.size.width / 5)
                    
                    Button {
                        // Add action for the button if needed
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.gray)
                    }
                    .buttonStyle(.bordered)
                    .frame(width: UIScreen.main.bounds.size.width / 5)
                }
            }
        }
    }
}

extension WorkoutView {
    private var topView: some View {
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
