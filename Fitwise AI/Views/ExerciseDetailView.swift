//
//  ExerciseDetailView.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/25/23.
//

import RealmSwift
import SwiftUI
import AVKit

struct ExerciseDetailView: View {
    
    let exerciseObject: ExerciseModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                let video: (player: AVPlayer, looper: AVPlayerLooper)  = {
                    let asset = AVAsset(url: URL(string: exerciseObject.videoURL)!)
                    let item = AVPlayerItem(asset: asset)
                    let queuePlayer = AVQueuePlayer(playerItem: item)
                    let playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)
                    
                    return (queuePlayer, playerLooper)
                }()
                
                VideoPlayer(player: video.player)
                    .disabled(true) // Hides iOS video controls
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .onAppear { video.player.play() }
                    .onDisappear{ video.player.pause() }

                ///Exercise details
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Learning Phase")
                            .font(.title2)
                        Text("Gotta add a _isLearning_ property to the exericse or figure out some other way to tell if this is a new exercise for the user and show exercise phase info")
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tip")
                            .font(.title2)
                        Text(exerciseObject.notes)
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Steps")
                            .font(.title2)
                        
                        ForEach(Array(exerciseObject.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 8) {
                                Text("\(index + 1).")
                                    .fontWeight(.semibold)
                                Text(step)
                                    .fixedSize(horizontal: false, vertical: true) // Allow text to wrap to the next line
                            }
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("History")
                            .font(.title2)
                        Text("[TODO]")
                    }
                    .padding()
                }
                
            }
            .navigationTitle(exerciseObject.name)
        }
    }
}
