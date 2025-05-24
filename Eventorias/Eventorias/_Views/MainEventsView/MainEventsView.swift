//
//  EventsView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import SwiftUI

struct MainEventsView: View {

    enum DisplayMode {
        case list
        case calendar
    }

    @Environment(\.dynamicTypeSize) var dynamicSize
    @Environment(\.verticalSizeClass) var verticalSize

    @ObservedObject var viewModel: EventsViewModel
    @FocusState private var searchBarIsFocused: Bool

    @State private var mode: DisplayMode = .list
    @State private var showAddEventView = false

    // MARK: Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBackground
                    .ignoresSafeArea()

                if viewModel.fetchingEvents {
                    AppProgressView()
                } else {
                    VStack(spacing: 0) {
                        searchBarWithCancelBtn
                        filterToolbar
                        if viewModel.fetchEventsError != "" {
                            errorMessage
                        } else {
                            switch mode {
                            case .list:
                                eventsList
                            case .calendar:
                                CalendarView(viewModel: viewModel)
                            }
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showAddEventView) {
                AddEventView(viewModel: viewModel)
            }
        }
    }
}

// MARK: Events list

private extension MainEventsView {

    var eventsList: some View {
        ZStack(alignment: .bottomTrailing) {
            EventsListView(events: viewModel.events)

            Button {
                showAddEventView.toggle()
            } label: {
                Image(systemName: "plus")
            }
            .buttonStyle(AppButtonSquare())
            .padding(.all, 8)
        }
    }
}

// MARK: Error message

private extension MainEventsView {

    var errorMessage: some View {
        /// Use ScrollView for high accessibility size and long error message
        ScrollView {
            VStack(spacing: 35) {
                ErrorView(error: viewModel.fetchEventsError)
                    .frame(
                        maxWidth: dynamicSize.isAccessibilitySize ? .infinity : 240
                    )
                Button("Try again") {
                    Task { await viewModel.fetchData() }
                }
                .buttonStyle(AppButtonPlain(small: true))
            }
            .padding(.top, dynamicSize.isAccessibilitySize || verticalSize == .compact ? 16 : 180)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: Filter toolbar

private extension MainEventsView {

    var filterToolbar: some View {
        HStack(spacing: 0) {
            sortButton
            Spacer()
            displayModePicker
        }
        .dynamicTypeSize(.xSmall ... .accessibility1)
        .padding(.bottom, 8)
        .padding(.horizontal)
    }
}

// MARK: Sort button

private extension MainEventsView {

    var sortButton: some View {
        Button {
            // sort
        } label: {
            HStack(spacing: 2) {
                HStack(spacing: 0) {
                    Image(systemName: "arrow.up")
                        .padding(.trailing, -7)
                        .padding(.bottom, 9)
                    Image(systemName: "arrow.down")
                        .padding(.top, 9)
                }
                .font(.caption2)
                .fontWeight(.black)
                .scaleEffect(0.8)
                Text("Sorting")
                    .font(.callout)
                    .padding(.vertical, 8)
            }
            .foregroundStyle(.white)
            .padding(.leading, 14)
            .padding(.trailing, 16)
            .frame(minHeight: 35)
            .background(Capsule().fill(Color.itemBackground))
        }
    }
}

// MARK: Display mode picker

private extension MainEventsView {

    var displayModePicker: some View {
        Picker("Mode", selection: $mode) {
            Text("List")
                .tag(DisplayMode.list)
            Text("Calendar")
                .tag(DisplayMode.calendar)
        }
        .pickerStyle(.menu)
        .tint(.white)
    }
}

// MARK: Search bar

private extension MainEventsView {

    var searchBarWithCancelBtn: some View {
        ZStack {
            if dynamicSize.isAccessibilitySize {
                VStack(spacing: 0) {
                    searchBar
                    HStack {
                        Spacer()
                        cancelButton
                    }
                }
            } else {
                HStack(spacing: 0) {
                    searchBar
                    cancelButton
                }
            }
        }
        .animation(.easeIn(duration: 0.2), value: searchBarIsFocused)
        .padding(.vertical, 8)
        .padding(.horizontal)
    }

    var searchBar: some View {
        HStack(spacing: 4) {
            Image(systemName: "magnifyingglass")
                .font(.subheadline)
                .foregroundStyle(.white)
                .padding(.vertical, 8)
            TextField("Search", text: $viewModel.search, prompt: searchPrompt)
                .foregroundStyle(.white)
                .focused($searchBarIsFocused)
                .submitLabel(.search)
        }
        .padding(.horizontal)
        .frame(minHeight: 35)
        .background(Capsule().fill(Color.itemBackground))
        .frame(minHeight: 44)
        .onTapGesture {
            /// Focus when clic on icon or around the prompt
            searchBarIsFocused = true
        }
    }

    var cancelButton: some View {
        Button("Cancel") {
            viewModel.search.removeAll()
            searchBarIsFocused = false
        }
        .buttonStyle(AppButtonBorderless())
        .frame(
            width: searchBarIsFocused ? nil : 0,
            height: searchBarIsFocused ? nil : 0
        )
        .padding(.leading, searchBarIsFocused ? 16 : 0)
        .scaleEffect(searchBarIsFocused ? 1 : 0)
    }

    var searchPrompt: Text {
        Text("Search")
            .font(.callout)
            .foregroundColor(.textLightGray)
    }
}

// MARK: - Preview

#Preview {
    let viewModel = EventsViewModel(eventRepo: PreviewEventRepository(withNetworkError: false))

    MainEventsView(viewModel: viewModel)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Task { await viewModel.fetchData() }
            }
        }
}
