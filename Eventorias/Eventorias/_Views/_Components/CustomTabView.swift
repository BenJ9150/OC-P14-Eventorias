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
    @State private var showEventDetailsFromShare = false

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
                
                if #available(iOS 17.0, *) {
                    tabView
                        .navigationDestination(item: $eventsViewModel.eventFromShare) { event in
                            EventDetailView(event: event)
                        }
                } else {
                    // Fallback on earlier versions
                    tabView
                        .navigationDestination(isPresented: $showEventDetailsFromShare, destination: {
                            if let event = eventsViewModel.eventFromShare {
                                EventDetailView(event: event)
                                    .onDisappear {
                                        eventsViewModel.eventFromShare = nil
                                    }
                            }
                        })
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onOpenURL { url in
                Task(priority: .high) {
                    do {
                        try await eventsViewModel.showEvent(from: url)
                        showEventDetailsFromShare = true
                    } catch {}
                }
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

    var tabView: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                MainEventsView(showAddEventView: $showAddEventView)
                    .tag(TabIdentifier.events)
                ProfileView(notifViewModel: notifViewModel)
                    .tag(TabIdentifier.profile)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            customTabView
        }
    }

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
