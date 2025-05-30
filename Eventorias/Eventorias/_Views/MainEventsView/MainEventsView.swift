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

    private var eventErrorMessage: String {
        if viewModel.fetchEventsError != "" {
            return viewModel.fetchEventsError
        }
        return viewModel.searchEventsError
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    searchBarWithCancelBtn
                    filterToolbar

                    if viewModel.fetchingEvents {
                        Spacer()
                        AppProgressView()
                    } else if eventErrorMessage.isEmpty {
                        if viewModel.userIsSearching {
                            searchList
                        } else {
                            switch mode {
                            case .list:
                                eventsList
                            case .calendar:
                                CalendarView(viewModel: viewModel)
                            }
                        }
                    } else {
                        errorMessage
                    }
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showAddEventView) {
                AddEventView(categories: viewModel.categories) {
                    /// Callback when event added
                    Task { await viewModel.fetchData() }
                }
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

// MARK: Search list

private extension MainEventsView {

    var searchList: some View {
        VStack(spacing: 0) {
            if viewModel.fetchingSearchedEvents {
                Spacer()
                AppProgressView()
                Spacer()
            } else {
                HStack(spacing: 5) {
                    let countResult = viewModel.searchResult.count
                    Text("\(countResult) event" + (countResult > 1 ? "s" : "") + " found")
                        .font(.callout)
                        .foregroundStyle(.white)
                    
                    Button {
                        withAnimation { viewModel.clearSearch() }
                    } label: {
                        ZStack {
                            Image(systemName: "xmark")
                                .font(.caption.bold())
                                .padding(.all, 8)
                                .background(Circle().fill(Color.white))
                        }
                        .frame(minWidth: 44, minHeight: 44)
                    }
                    .foregroundStyle(Color.itemBackground)
                }
                .dynamicTypeSize(.xSmall ... .accessibility3)
                .padding(.top)
                
                Rectangle()
                    .fill(.white)
                    .frame(height: 0.5)
                    .padding(.horizontal, 24)
                    .padding(.bottom)
                    
                EventsListView(events: viewModel.searchResult)
            }
        }
    }
}

// MARK: Error message

private extension MainEventsView {

    var errorMessage: some View {
        /// Use ScrollView for high accessibility size and long error message
        ScrollView {
            VStack(spacing: 35) {
                ErrorView(error: eventErrorMessage)
                    .frame(
                        maxWidth: dynamicSize.isAccessibilitySize ? .infinity : 240
                    )
                if eventErrorMessage != AppError.searchEventIsEmpty.userMessage {
                    Button("Try again") {
                        if viewModel.search.isEmpty {
                            Task { await viewModel.fetchData() }
                        } else {
                            Task { await viewModel.searchEvents() }
                        }
                    }
                    .buttonStyle(AppButtonPlain(small: true))
                }
            }
            .padding(.top, dynamicSize.isAccessibilitySize || verticalSize == .compact ? 16 : 180)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: Filter toolbar

private extension MainEventsView {

    var filterToolbar: some View {
        ZStack {
            if dynamicSize.isAccessibilitySize {
                VStack(spacing: 8) {
                    sortButton
                    displayModePicker
                }
            } else {
                HStack(spacing: 0) {
                    sortButton
                    Spacer()
                    displayModePicker
                }
            }
        }
        .dynamicTypeSize(.xSmall ... .accessibility2)
        .padding(.bottom, 8)
        .padding(.horizontal)
    }
}

// MARK: Sort button

private extension MainEventsView {

    var sortButton: some View {
        Menu {
            Button("Sorting by title") {
                viewModel.eventSorting = .byTitle
            }
            Button("Sorting by date") {
                viewModel.eventSorting = .byDate
            }
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
                
                ZStack {
                    switch viewModel.eventSorting {
                    case .byDate:
                        Text("Sorting by date")
                    case .byTitle:
                        Text("Sorting by title")
                    }
                }
                .font(.callout)
            }
            .padding(.vertical, 8)
            
        }
        .foregroundStyle(.white)
        .padding(.horizontal)
        .background(Capsule().fill(Color.itemBackground))
        .onChange(of: viewModel.eventSorting) {
            Task { await viewModel.fetchData() }
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
        .background(
            Capsule().fill(Color.itemBackground)
        )
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
                .onSubmit {
                    Task { await viewModel.searchEvents() }
                }
            if !viewModel.search.isEmpty {
                Button {
                    viewModel.clearSearch()
                } label: {
                    Image(systemName: "xmark")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .frame(minHeight: 35)
                }

            }
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
            viewModel.clearSearch()
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
            Task { await viewModel.fetchData() }
        }
}
