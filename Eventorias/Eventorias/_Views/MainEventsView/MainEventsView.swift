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

    @EnvironmentObject var viewModel: EventsViewModel
    @Binding var showAddEventView: Bool

    @FocusState private var searchBarIsFocused: Bool
    @State private var mode: DisplayMode = .list
    @State private var showCategoryPicker = false

    private var eventErrorMessage: String {
        if viewModel.fetchEventsError != "" {
            return viewModel.fetchEventsError
        }
        return viewModel.searchEventsError
    }

    init(showAddEventView: Binding<Bool>) {
        self._showAddEventView = showAddEventView
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.itemBackground)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.accentColor)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }

    // MARK: Body

    var body: some View {
        VStack(spacing: 0) {
            if verticalSize == .compact {
                HStack {
                    VStack(spacing: 0) {
                        searchBarWithCancelBtn
                        displayModePicker
                        if mode == .list {
                            filterToolbar
                        }
                        Spacer()
                    }
                    .padding(.top)
                    .frame(maxWidth: 280)
                    bodyContent
                        .frame(maxWidth: .infinity)
                }
            } else {
                VStack(spacing: 0) {
                    searchBarWithCancelBtn
                    displayModePicker
                    if mode == .list {
                        filterToolbar
                    }
                }
                .frame(maxWidth: .maxWidthForPad)
                bodyContent
                    .frame(maxWidth: .maxWidthForPad * 2)
            }
        }
    }
}

// MARK: Body content

private extension MainEventsView {

    private var bodyContent: some View {
        VStack(spacing: 0) {
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
                        CalendarView()
                            .frame(maxWidth: verticalSize == .compact ? 250 : nil)
                    }
                }
            } else {
                errorMessage
            }
            Spacer()
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
            .accessibilityLabel("Add an event")
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
                let countResult = viewModel.searchResult.count
                HStack(spacing: 5) {
                    Text("\(countResult) event" + (countResult > 1 ? "s" : "") + " found")
                        .font(.callout)
                        .foregroundStyle(.white)
                        .accessibilityHidden(true)
                    
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
                    .accessibilityIdentifier("ClearSearchButton")
                    .accessibilityLabel("\(countResult) event" + (countResult > 1 ? "s" : "") + " found, clear search")
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
        VStack {
            if verticalSize == .compact {
                sortButton
                chooseCategoriesButton
            } else {
                HStack(spacing: 0) {
                    Spacer()
                    sortButton
                    Spacer()
                    chooseCategoriesButton
                    Spacer()
                }
            }
            if !viewModel.categoriesSelection.isEmpty {
                categoriesSelection
            }
        }
        .dynamicTypeSize(.xSmall ... .xxxLarge)
        .padding(.bottom, 8)
        .sheet(isPresented: $showCategoryPicker) {
            ChooseCategoryView()
        }
        .onChange(of: viewModel.categoriesSelection) {
            Task { await viewModel.fetchData() }
        }
    }
}

// MARK: Choose categories

private extension MainEventsView {

    var chooseCategoriesButton: some View {
        Button {
            showCategoryPicker.toggle()
        } label: {
            HStack {
                Image(systemName: "checklist")
                    .font(.caption)
                Text("Category")
                    .font(.callout)
            }
            .foregroundStyle(.white)
            .padding(.vertical, 8)
            .padding(.horizontal)
            .frame(minHeight: 40)
            .background(Capsule().fill(Color.itemBackground))
        }
    }

    var categoriesSelection: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(viewModel.categoriesSelection) { category in
                        HStack(spacing: 4) {
                            Text(category.name)
                                .font(.caption)
                            Image(systemName: "xmark")
                                .font(.caption2)
                        }
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .frame(minHeight: 40)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Unselect \(category.name) category")
                        .onTapGesture {
                            withAnimation {
                                viewModel.categoriesSelection.removeAll { $0 == category }
                            }
                        }
                    }
                }
            }
            Rectangle()
                .fill(.white)
                .frame(height: 0.5)
                .padding(.horizontal, 24)
        }
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
            .frame(minHeight: 40)
            
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
        VStack(spacing: 16) {
            Picker("Mode", selection: $mode) {
                Text("List")
                    .tag(DisplayMode.list)
                Text("Calendar")
                    .tag(DisplayMode.calendar)
            }
            .pickerStyle(.palette)
            .padding(.horizontal, 24)
            
            Rectangle()
                .fill(Color.itemBackground)
                .frame(height: 1)
        }
        .padding(.bottom, 16)
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
        .dynamicTypeSize(.xSmall ... .accessibility2)
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
                .accessibilityHidden(true)
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
                .accessibilityLabel("Clear search")
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
        .accessibilityHidden(!searchBarIsFocused)
    }

    var searchPrompt: Text {
        Text("Search")
            .font(.callout)
            .foregroundColor(.textLightGray)
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withViewModels()) {
    NavigationStack {
        ZStack {
            Color.mainBackground
                .ignoresSafeArea()

            MainEventsView(showAddEventView: .constant(false))
        }
    }
}
