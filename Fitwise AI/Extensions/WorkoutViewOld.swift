////
////  WorkoutView.swift
////  Fitwise AI
////
////  Created by Keshav Khaneja on 12/17/23.
//
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
//                ForEach(routineDays[currentDay].muscleGroup, id: \.self) { muscleGroup in
//                    let exercises = hvm.getExercises(muscleGroup, 3)
//                    
//                    ForEach(exercises) { exercise in
//                        Text("\(exercise.name)")
//                            .padding()
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                        
//                        headerView
//                        
//                        HStack(spacing: 0) {
//                            Text("2")
//                                .frame(width: UIScreen.main.bounds.size.width/5)
//                            
//                            Text("50kg x 7")
//                                .frame(width: UIScreen.main.bounds.size.width/5)
//                            
//                            TextField("52.5", value: $weight, formatter: NumberFormatter())
//                                .frame(maxWidth: 80)
//                                .fixedSize()
//                                .textFieldStyle(.roundedBorder)
//                                .multilineTextAlignment(.center)
//                                .keyboardType(.numberPad)
//                                .frame(width: UIScreen.main.bounds.size.width/5)
//                            
//                            
//                            TextField("8", value: $reps, formatter: NumberFormatter())
//                                .frame(maxWidth: 40)
//                                .fixedSize()
//                                .textFieldStyle(.roundedBorder)
//                                .multilineTextAlignment(.center)
//                                .keyboardType(.numberPad)
//                                .frame(width: UIScreen.main.bounds.size.width/5)
//                            
//                            
//                            Button {
//                            } label: {
//                                Image(systemName: "checkmark")
//                                    .foregroundStyle(.gray)
//                            }
//                            .buttonStyle(.bordered)
//                            .frame(width: UIScreen.main.bounds.size.width/5)
//                            
//                            
//                        }
//
//                    }
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
