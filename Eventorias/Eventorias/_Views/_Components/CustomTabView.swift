//
//  CustomTabView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 16/05/2025.
//

import SwiftUI

struct CustomTabView: View {

    @Environment(\.dynamicTypeSize) var dynamicSize
    @Environment(\.verticalSizeClass) var verticalSize

    @EnvironmentObject var eventsViewModel: EventsViewModel
    @StateObject private var notifViewModel = NotificationsViewModel()

    @State private var selectedTab: TabIdentifier = .events
    @State private var showAddEventView = false

    enum TabIdentifier {
        case events, profile
    }

    private var iconSize: CGFloat {
        dynamicSize.isAccessibilitySize ? 40 : 24
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    TabView(selection: $selectedTab) {
                        Tab(value: TabIdentifier.events) {
                            MainEventsView(showAddEventView: $showAddEventView)
                        }
                        
                        Tab(value: TabIdentifier.profile) {
                            ProfileView(notifViewModel: notifViewModel)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    customTabView
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onOpenURL { url in
                Task(priority: .high) { await eventsViewModel.showEvent(from: url) }
            }
            .navigationDestination(item: $eventsViewModel.eventFromShare) { event in
                EventDetailView(event: event)
            }
            .navigationDestination(isPresented: $showAddEventView) {
                AddEventView(categories: eventsViewModel.categories) {
                    /// Callback when event added
                    Task { await eventsViewModel.fetchData() }
                }
            }
        }
    }
}

// MARK: Tabview

private extension CustomTabView {

    var customTabView: some View {
        HStack(spacing: 34) {
            Button(action: { selectedTab = .events }) {
                tabItem(image: "icon_tab_event", text: "Events")
            }
            .foregroundStyle(selectedTab == .events ? .textRed : .white)
            
            Button(action: { selectedTab = .profile }) {
                tabItem(image: "icon_tab_profile", text: "Profile")
            }
            .foregroundStyle(selectedTab == .profile ? .textRed : .white)
        }
    }

    func tabItem(image: String, text: String) -> some View {
        ZStack {
            if dynamicSize.isAccessibilitySize && verticalSize == .compact {
                Text(text)
                    .font(.caption)
                    .fontWeight(.semibold)
            } else {
                VStack(spacing: 8) {
                    Image(image)
                        .resizable()
                        .frame(width: iconSize, height: iconSize)
                    Text(text)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
            }
        }
        .dynamicTypeSize(.xSmall ... .accessibility4)
        .frame(minHeight: 44)
        .padding(.top, 8)
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withViewModels()) {
    CustomTabView()
}
