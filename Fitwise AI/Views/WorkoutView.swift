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






import SwiftUI

struct WorkoutView: View {
    let routineDays = generateRoutine()
    //TODO: Right now, the current day is hardcoded. Make it dynamic!
    let currentDay = 1
    @StateObject private var hvm = HomeViewModel()


    var body: some View {

        ScrollView {
            VStack(alignment: .leading) {

                    let exercises = hvm.getExercises(.back, 8)

                    ForEach(exercises) { exercise in
                        Text(exercise.name)

                        ForEach(Array(exercise.sets.enumerated()), id: \.offset)  { index, set in
                            Text("\(String(format: "%g", set.targetWeight!)) x \(set.targetReps!)")
                        }
                }
            }
        }
    }
}




























//
//import SwiftUI
//
//struct WorkoutView: View {
//    @State private var weight: Int?
//    @State private var reps: Int?
//    @StateObject private var hvm = HomeViewModel()
//
//    let routineDays = generateRoutine()
//    //TODO: Right now, the current day is hardcoded. Make it dynamic!
//    let currentDay = 1
//
//    var body: some View {
//
//        ScrollView {
//            VStack(alignment: .leading) {
//
//                    let exercises = hvm.getExercises(.back)
//
//                    ForEach(exercises) { exercise in
//                        Text(exercise.name)
//                            .padding()
//                            .font(.title3)
//                            .fontWeight(.semibold)
//
//                        topView
//
//                        ForEach(Array(exercise.sets.enumerated()), id: \.offset)  { index, set in
//                            
//                            //TODO: Force unwrapping the target weight and reps here. They might not exist!
//                            #warning("Force unwrapping the target weight and reps here. They might not exist")
//                            HStack {
//                                Text("Set: \(index+1)")
//                                    .padding()
//
//                                Text("Weight: \(String(format: "%g", set.targetWeight!))")
//                                    .padding()
//
//                                Text("Reps: \(set.targetReps!)")
//                                    .padding()
//
//                            }
//
//                            
//                        }
//                        
////                        HStack(spacing: 0) {
////                            Text("count here")
////                                .frame(width: UIScreen.main.bounds.size.width/5)
////
////                            Text("50kg x 7")
////                                .frame(width: UIScreen.main.bounds.size.width/5)
////
////                            TextField("52.5", value: $weight, formatter: NumberFormatter())
////                                .frame(maxWidth: 80)
////                                .fixedSize()
////                                .textFieldStyle(.roundedBorder)
////                                .multilineTextAlignment(.center)
////                                .keyboardType(.numberPad)
////                                .frame(width: UIScreen.main.bounds.size.width/5)
////
////
////                            TextField("8", value: $reps, formatter: NumberFormatter())
////                                .frame(maxWidth: 40)
////                                .fixedSize()
////                                .textFieldStyle(.roundedBorder)
////                                .multilineTextAlignment(.center)
////                                .keyboardType(.numberPad)
////                                .frame(width: UIScreen.main.bounds.size.width/5)
////
////
////                            Button {
////                            } label: {
////                                Image(systemName: "checkmark")
////                                    .foregroundStyle(.gray)
////                            }
////                            .buttonStyle(.bordered)
////                            .frame(width: UIScreen.main.bounds.size.width/5)
////
////
////                        }
//
//                }
//            }
//        }
//    }
//}
//
//extension WorkoutView {
//    private var topView: some View {
//        VStack {
//            HStack(spacing: 0) {
//                Text("SET")
//                    .frame(width: UIScreen.main.bounds.size.width/5)
//
//                Text("PERVIOUS")
//                    .frame(width: UIScreen.main.bounds.size.width/5)
//
//
//                Text("KG")
//                    .frame(width: UIScreen.main.bounds.size.width/5)
//
//
//                Text("REPS")
//                    .frame(width: UIScreen.main.bounds.size.width/5)
//
//                Text(Image(systemName: "checkmark"))
//                    .frame(width: UIScreen.main.bounds.size.width/5)
//
//            }
//            .padding(.bottom, 5)
//            .font(.caption)
//            .foregroundStyle(.secondary)
//        }
//
//    }
//}
//
//
//#Preview {
//    WorkoutView()
//}
//
//
