//
//  HomeView.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/3/23.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    
    @ObservedResults(UserModel.self) var User
    
    var body: some View {
        
        let user = User.last
        
        VStack {
            Text("Bodytype: \(user!.bodyType.text)")
            
            Text("\(user!.experience.text)")
            Text("\(user!.workoutFrequency.text)")
            
            Text("\(user!.goal.text)")
        }
    }
}

#Preview {
    HomeView()
}
