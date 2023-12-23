//
//  ContentView.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/2/23.
//

import SwiftUI
import RealmSwift

struct EntryView: View {
    
    @ObservedResults(UserModel.self) var user

    var body: some View {
        ZStack {
            if let user = user.last, user.isUserOnboarded {
                @StateObject var sharedViewModel = SharedViewModel()

                /// Don't initialize SharedViewModel() unless the user is onboarded
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "dumbbell")
                        }
                    HistoryView()
                        .tabItem {
                            Label("History", systemImage: "clock.arrow.circlepath")
                        }
                }
                .environmentObject(sharedViewModel)

            } else {
                OnboardingView()
            }
        }
    }
}

#Preview {
    EntryView()
}
