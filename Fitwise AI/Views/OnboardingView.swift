//
//  OnboardingVIe.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/3/23.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject private var ovm = OnboardingViewModel(totalOnboardingStates: 8)
    @FocusState var isNameFocused: Bool
    @FocusState var isWightFocused: Bool
    
    var body: some View {
        NavigationStack{
            ZStack {
                
                switch ovm.onboardingState {
                case 0:
                    genderView
                        .transition(ovm.transition)
                        .padding()
                case 1:
                    nameView
                        .transition(ovm.transition)
                case 2:
                    weightView
                        .transition(ovm.transition)
                        .padding()
                case 3:
                    bodyTypeView
                        .transition(ovm.transition)
                        .padding()
                case 4:
                    experienceView
                        .transition(ovm.transition)
                        .padding()
                case 5:
                    goalView
                        .transition(ovm.transition)
                        .padding()
                case 6:
                    workoutDurationView
                        .transition(ovm.transition)
                        .padding()
                case 7:
                    frequencyView
                        .transition(ovm.transition)
                        .padding()
                case 8:
                    workoutDaysView
                        .transition(ovm.transition)
                default:
                    fatalError("The onboarding state couldn't be found!")
                }
            }
//            .navigationTitle("Progress bar?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    // https://sarunw.com/posts/custom-navigation-bar-title-view-in-swiftui/
                    Image(systemName: "bus")
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        ovm.previous()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}

//MARK: Views
extension OnboardingView {
    struct ButtonView: View {
        let action: () -> Void
        let buttonText: String
        
        var body: some View {
            Button {
                action()
            } label: {
                Text(buttonText)
                    .frame(maxWidth: .infinity)
                    .fontWeight(.medium)
            }
            .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
            .buttonStyle(.borderedProminent)
            
        }
    }
    
    private var genderView: some View {
        VStack(alignment: .leading) {
            Text("Select your gender")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(UserGenderEnum.allCases, id: \.self) { Gender in
                ButtonView(action: {
                    ovm.gender = Gender
                    ovm.next()
                }, buttonText: Gender.text)
            }
            
            Spacer()
        }
    }
    
    private var nameView: some View {
        VStack {
            Form {
                TextField("Enter your first name", text: $ovm.name)
                    .focused($isNameFocused, equals: true)
                Button("Next") {
                    isNameFocused = false
                    ovm.next()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(ovm.name.isEmpty)
            }
            
        }
    }
    
    
    private var weightView: some View {
        VStack {
            Form {
                TextField("Enter your weight", text: $ovm.weightString)
                    .focused($isWightFocused, equals: true)
                //TODO: WEIGHT ONLY IN KG
                    .keyboardType(.decimalPad)

                Button("Next") {
                    isWightFocused = false
                    ovm.next()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                
                .disabled(ovm.weight == nil)

            }
            
        }
        
    }
    
    private var bodyTypeView: some View {
        VStack(alignment: .leading) {
            Text("Select your body type")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(UserBodyTypeEnum.allCases, id: \.text) { BodyType in
                ButtonView(action: {
                    ovm.bodyType = BodyType
                    ovm.next()
                }, buttonText: BodyType.text)
            }
            
            Spacer()
        }
    }
    
    private var experienceView: some View {
        VStack(alignment: .leading) {
            Text("What is your experience level with weight lifting?")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(UserExperienceEnum.allCases, id: \.text) { Experience in
                ButtonView(action: {
                    ovm.experience = Experience
                    ovm.next()
                }, buttonText: Experience.text)
            }
            
            Spacer()
        }
    }
    
    private var goalView: some View {
        VStack(alignment: .leading) {
            Text("What is your main reason for using the app?")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(UserGoalEnum.allCases, id: \.text) { Goal in
                ButtonView(action: {
                    ovm.goal = Goal
                    ovm.next()
                }, buttonText: Goal.text)
            }
            
            Spacer()
        }
    }
    
    private var workoutDurationView: some View {
        VStack(alignment: .leading) {
            Text("How long do you want your workouts to be?")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(UserWorkoutDurationEnum.allCases, id: \.text) { WorkoutDuration in
                ButtonView(action: {
                    ovm.workoutDuration = WorkoutDuration
                    ovm.next()
                }, buttonText: WorkoutDuration.text)
            }
            
            Text("Don't worry - you'll still be able to do workouts shorter than 45m with Rush Mode perfectly adapted to you goals for days when time's tight!")
            
            // TODO: Add tip here
            
            Spacer()
        }
    }
    
    private var frequencyView: some View {
        VStack(alignment: .leading) {
            Text("How frequently do you want to workout?")
                .font(.title2)
                .fontWeight(.bold)
            
            ZStack {
                Slider(value: .convert(from: $ovm.slider), in: 2...7, step: 1)
                    .tint(Color(UIColor.systemFill))
                    .onChange(of: ovm.slider, perform: { newValue in
                        let generator = UIImpactFeedbackGenerator(style: .rigid)
                        generator.impactOccurred()
                    })
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 4)
                    .foregroundColor(.gray.opacity(1))
                    .cornerRadius(1)
                    .zIndex(-1)
                
                HStack(spacing: 0) {
                    ForEach(2...7, id: \.self) { step in
                        Spacer()
                        Rectangle()
                            .frame(width: 4, height: 10)
                            .foregroundColor(.gray.opacity(1))
                        Spacer()
                    }
                }.zIndex(-1)
            }
            
            VStack(spacing: 6) {
                //Slider value text + Times / week
                Text("\(String(ovm.slider)) Times / week")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                //Tip text
                Text(ovm.sliderFrequencyIntToUserWorkoutFrequencyEnum().tip)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical)
            
            ButtonView(action: {
                ovm.workoutFrequency = ovm.sliderFrequencyIntToUserWorkoutFrequencyEnum()
                ovm.next()
            }, buttonText: "Continue")
            Spacer()
        }
        
        
    }
    
    private var workoutDaysView: some View {
        VStack {
            Text("Pick \(ovm.workoutFrequency.int) workout days")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            
            Form {
                Section(header: Text("Select Workout Days")) {
                    ForEach(UserWorkoutDayEnum.allCases, id: \.self) { WorkoutDay in
                        Toggle(WorkoutDay.text, isOn: Binding (
                            get: { ovm.tempArray.contains(WorkoutDay) },
                            set: { isSelected in
                                ovm.toggleSelection(for: WorkoutDay, isSelected: isSelected)
                            }
                        ))
                    }
                }
            }
            Spacer()
            
            ButtonView(action: {
                ovm.saveUser()
                ovm.seedAppData()
            }, buttonText: "Next")
            
        }
    }
}

#Preview {
    OnboardingView()
}
