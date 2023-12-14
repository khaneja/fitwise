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
    @StateObject private var hvm = HomeViewModel()

    var body: some View {
        let user = User.last
        
        //based on the muscle groups thrown by the routineGenerator(), this code should pick out exercises
        Button {
            hvm.pickExercises()
        } label: {
         Text(verbatim: "Pick")
        }
        
    }
}

#Preview {
    HomeView()
}
