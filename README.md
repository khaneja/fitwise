![fitwise_header](https://github.com/user-attachments/assets/662c8ef1-1623-4843-a1ba-bcfabc770a38)

An evidence-based workout tracker based training science. Released under the public domain.

- Auto-generates workout plans w/ autoregulation (adjust training based on performance).
- Smart progressive-overload & plateau detection.
- Exercise videos.
- SwiftUI-based core for a lightweight structure.
- Runs 100% offline. No servers, nothing weird going on.
- Accessible & supports VoiceOver!

## Showroom
<table>
<tr>
<td>
Smart onboarding
</td>
<td>
Tailor-made workout plans
</td>
<td>
Adjust workout frequency
</td>
<td>
Auto-logging
</td>
<td>
Exercise tutorials
</td>
</tr>

<tr>
<td>
<img src="Features/Onboarding.gif" alt="Onboarding.gif">
</td>
<td>
<img src="Features/Frequency.gif" alt="Frequency">
</td>
<td>
<img src="Features/Planning.gif" alt="Menu">
</td>
<td>
<img src="Features/Logging.gif" alt="Logging">
</td>
<td>
<img src="Features/Steps.gif" alt="Steps">
</td>
</tr>

</table>

## Backend
Backend architected with [Realm SwiftUI](https://github.com/realm/realm-swift). 

![Showcase](Features/Backend.png)

## Inner workings

The foundation of the algorithm is determining the volume per muscle group per week, adjusted for the user's:

- Training frequency
- Experience level

The `volumePerWeekPerBodypart` function dynamically determines the weekly set volume per muscle group, accounting for user experience, frequency, and unique muscle properties.

```swift
func volumePerWeekPerBodypart(muscle: MuscleGroupEnum) -> Int {
    var volume = 0
    
    if userModel.last!.workoutFrequency.int <= 2 {
        switch userModel.last!.experience {
        case .beginner: volume = 6
        case .intermediate: volume = 6
        case .advanced: volume = 8
        }
    } 
}
```

Then, the `distributeSets` function splits the weekly set volume into smaller, actionable groups for each session. (Example: Distribution: 17 sets → [4, 4, 3]. So, 3 exercises — the first two with 4 sets and the third one with 3.)

Finally, `addExercises` takes all the inputs and creates a day’s routine while accounting for both primary & secondary muscle activations

```swift
func addExercises(muscleGroup: MuscleGroupEnum)  {
    let distribution = distributeSets(volumePerWeekPerBodypart(muscle: muscleGroup))
    let exerciseObjects = getExerciseObject(muscleGroup: muscleGroup, distribution: distribution)
    let exercises = createExercisesFromExerciseObject(exerciseObjects, distribution: distribution)

    for exercise in exercises {
        var processedMuscleGroups: Set<String> = []
        
        for secondaryMuscleGroup in exercise.realmObj.muscleGroups {
            if secondaryMuscleGroup.activation_percent >= 0.6 && 
               secondaryMuscleGroup.group != exercise.realmObj.primaryMuscleGroups.first!.group &&
               !processedMuscleGroups.contains(secondaryMuscleGroup.group) {
                // ... 
                }
                processedMuscleGroups.insert(secondaryMuscleGroup.group)
            }
        }
    }

    allExercises.append(contentsOf: exercises)
}
```

Note: Local `SPW` is the weekly volume per muscle. To avoid exhausting weekly volume in just one single session, it is adjusted based on the number of sessions _per week_ targeting that muscle preventing overtraining.

To further avoid overtraining, the removeSynergistics function adjusts exercises by removing excessive secondary activations to balances direct & indirect training volume. 

```swift
func removeSynergistics(_ exercises: [ExerciseViewDataModel]) {
    muscleGroupData.allCases.forEach {
        if $0.bucket.indirect > 0 {
            let numberOfSets = $0.bucket.direct - $0.bucket.indirect
            removeAndReAddExercise(muscleGroup: $0.enumValue, newNumberOfSets: (numberOfSets >= 3 ? numberOfSets : 2))
        }
    }
}
```

## Resources

Fitwise is fully open-source and I intend to be as transparent as possible. Here are the resources used during development:

- A large part of the training algorithm was based on [Dr. Mike Israetel's course](https://www.youtube.com/playlist?list=PLyqKj7LwU2RuRKOeHg3mv_hLHI4Z-FAJD) on hypertrophy!![source](https://github.com/user-attachments/assets/592b9a1b-9253-46a9-82d2-629c4f6c51ce)
- https://pubmed.ncbi.nlm.nih.gov/27433992/
- https://pubmed.ncbi.nlm.nih.gov/35291645/
- https://journals.lww.com/nsca-jscr/Fulltext/2010/07000/The_Effect_of_Autoregulatory_Progressive.3.aspx
- https://journals.lww.com/nsca-jscr/Abstract/2010/01001/The_Effect_Of_Daily_Undulated_Periodization_As.1.aspx
- https://pmc.ncbi.nlm.nih.gov/articles/PMC2956949/


## Community

Author | Contributing | Need Help?
--- | --- | ---
Fitwise was created [Keshav Khaneja](https://keshav.me) during winter of 2023. | All contributions are welcome. Just [fork](https://github.com/khaneja/fitwise/fork) the repo, then make a pull request. | Open an [issue](https://github.com/khaneja/fitwise/issues). You can also ping me on [Twitter]([https://twitter.com/aheze0](https://twitter.com/khaneja52)).


## License

```
MIT License

Copyright (c) 2023 K. Khaneja

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
> **Note**  
> You can technically clone Fitwise and sell it on the App Store, but I'd appreciate it if you didn't do this. Instead, please make any changes you want to the main repo — all pull requests are welcome!
