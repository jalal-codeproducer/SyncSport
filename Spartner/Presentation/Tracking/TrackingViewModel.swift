//
//  TrackingViewModel.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 23.03.25.
//

import Foundation
import Combine

@MainActor
class TrackingViewModel: ObservableObject {
    private let repository: ChallengeRepositoryImpl
    
    @Published var tracks: [Track] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    
    init(repository: ChallengeRepositoryImpl) {
        self.repository = repository
    }
    
    func fetchChallengeTracks(userId: String) {
        isLoading = true
        defer {
            isLoading = false
        }
        Task {
            do {
                let fetchedTracks = try await repository.fetchChallengeTracks(userId: userId)
                DispatchQueue.main.async {
                    self.tracks = fetchedTracks
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
}
