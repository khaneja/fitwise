//
//  ExerciseModel.swift
//  Fitwise AI
//
//  Created by Keshav Khaneja on 12/12/23.
//

import Foundation
import RealmSwift

class ExerciseModel: Object, ObjectKeyIdentifiable  {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var maleBwRatio: Double
    @Persisted var femaleBwRatio: Double
    @Persisted var aggressiveOverload: Bool
    @Persisted var idJSON: String
    @Persisted var paceCompatible: Bool
    @Persisted var repCompatible: Bool
    @Persisted var appIdJSON: String?
    @Persisted var powerLift: Bool
    @Persisted var hiitCompatible: Bool
    @Persisted var videoURL: String
    @Persisted var notes: String
    @Persisted var highRepMovement: Bool
    @Persisted var unweighted: Bool
    @Persisted var timeCompatible: Bool
    @Persisted var twoSidedMovement: Bool
    @Persisted var mediaId: String
    @Persisted var steps: List<String>
    @Persisted var equipments: List<EquipmentModel>
    @Persisted var primaryMuscleGroups: List<PrimaryMuscleGroupModel>
    @Persisted var muscleGroups: List<MuscleGroupModel>
    
    convenience init(name: String, maleBwRatio: Double, femaleBwRatio: Double, aggressiveOverload: Bool, idJSON: String, paceCompatible: Bool, repCompatible: Bool, appIdJSON: String? = nil, powerLift: Bool, hiitCompatible: Bool, notes: String, highRepMovement: Bool, unweighted: Bool, timeCompatible: Bool, twoSidedMovement: Bool, videoURL: String, mediaId: String) {
        self.init()
        self.name = name
        self.maleBwRatio = maleBwRatio
        self.femaleBwRatio = femaleBwRatio
        self.aggressiveOverload = aggressiveOverload
        self.idJSON = idJSON
        self.paceCompatible = paceCompatible
        self.repCompatible = repCompatible
        self.appIdJSON = appIdJSON
        self.powerLift = powerLift
        self.hiitCompatible = hiitCompatible
        self.notes = notes
        self.videoURL = videoURL
        self.highRepMovement = highRepMovement
        self.unweighted = unweighted
        self.timeCompatible = timeCompatible
        self.twoSidedMovement = twoSidedMovement
        self.mediaId = mediaId
    }
}
