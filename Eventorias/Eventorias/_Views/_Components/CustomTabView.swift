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

    @ObservedObject var eventsViewModel: EventsViewModel
    @State private var selectedTab: Tab = .events

    enum Tab {
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
                    if selectedTab == .events {
                        MainEventsView(viewModel: eventsViewModel)
                    } else {
                        ProfileView()
                    }
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
            .foregroundStyle(selectedTab == .events ? .accent : .white)
            
            Button(action: { selectedTab = .profile }) {
                tabItem(image: "icon_tab_profile", text: "Profile")
            }
            .foregroundStyle(selectedTab == .profile ? .accent : .white)
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
#Preview(traits: .withAuthViewModel()) {
    @Previewable @State var isHidden: Bool = false
    let viewModel = EventsViewModel(eventRepo: PreviewEventRepository(withNetworkError: false))

    CustomTabView(eventsViewModel: viewModel)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Task { await viewModel.fetchData() }
            }
        }
}
