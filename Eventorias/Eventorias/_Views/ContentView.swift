//
//  ContentView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            if let name = authViewModel.currentUser?.displayName {
                Text("Hello \(name)!")
            } else {
                Text("Hello!")
            }
            
            Spacer()

            Button("Fetch events") {
                Task {
                    do {
                        let items: [Event] = try await EventService(dbRepo: FirestoreRepository()).fetchEvents()
                        for item in items {
                            print(item)
                            print(" ")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            Button("Fetch categories") {
                Task {
                    do {
                        let items: [EventCategory] = try await EventService(dbRepo: FirestoreRepository()).fetchEventCategories()
                        for item in items {
                            print(item)
                            print(" ")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            Button("Sign out") {
                authViewModel.signOut()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel()) {
    ContentView()
}
