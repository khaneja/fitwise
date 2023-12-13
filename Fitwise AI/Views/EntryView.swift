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
                HomeView()
            } else {
                OnboardingView()
            }
            
        }
    }
}

#Preview {
    EntryView()
}
