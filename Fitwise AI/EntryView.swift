//
//  ContentView.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/2/23.
//

import SwiftUI
import RealmSwift

struct EntryView: View {
    
    @StateObject var sharedViewModel = SharedViewModel()

    @ObservedResults(UserModel.self) var user

    var body: some View {
        ZStack {
            if let user = user.last, user.isUserOnboarded {
                TabView {
                    HomeView(sharedViewModel: sharedViewModel)
                        .tabItem {
                            Label("Home", systemImage: "dumbbell")
                        }
                    
                    WorkoutView(sharedViewModel: sharedViewModel)
                        .tabItem {
                            Label("Workout", systemImage: "dumbbell")
                        }
                }
            } else {
                OnboardingView()
            }
            
        }
    }
}

#Preview {
    EntryView()
}
