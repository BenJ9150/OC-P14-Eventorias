//
//  EventsView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import SwiftUI

struct EventsView: View {

    @Environment(\.dynamicTypeSize) var dynamicSize
    @Environment(\.verticalSizeClass) var verticalSize

    @ObservedObject var viewModel: EventsViewModel
    @FocusState private var searchBarIsFocused: Bool

    private var imageWidth: CGFloat {
        UIScreen.main.bounds.width <= 375 ? 110 : 136
    }

    private var gridColumms: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: 16),
            count: isPad ? 2 : 1
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.sheetBackground
                    .ignoresSafeArea()

                if viewModel.fetchingEvents {
                    AppProgressView()
                } else {
                    VStack(spacing: 0) {
                        searchBarWithCancelBtn
                        sortButton
                        ScrollView {
                            if viewModel.fetchEventsError != "" {
                                errorMessage
                            } else {
                                eventsList
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    .padding(.horizontal)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

// MARK: Error message

private extension EventsView {

    var errorMessage: some View {
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
        .padding(.top, dynamicSize.isAccessibilitySize ? 48 : 180)
    }
}

// MARK: Events list

private extension EventsView {

    var eventsList: some View {
        LazyVGrid(columns: gridColumms, spacing: isPad ? 16 : 8) {
            ForEach(viewModel.events) { event in
                if dynamicSize.isAccessibilitySize && verticalSize != .compact {
                    eventItemHighSize(event)
                } else {
                    eventItem(event)
                }
            }
        }
    }
}

// MARK: Event item

private extension EventsView {

    func eventItem(_ event: Event) -> some View {
        HStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.leading, 16)
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 8) {
                title(ofEvent: event)
                date(ofEvent: event)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
            ImageView(url: event.photoURL)
                .frame(width: imageWidth)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.itemBackground)
        )
    }

    func eventItemHighSize(_ event: Event) -> some View {
        VStack(spacing: 0) {
            title(ofEvent: event)
                .padding(.top)
                .multilineTextAlignment(.center)
            Rectangle()
                .frame(height: 0.5)
                .foregroundStyle(.white)
                .padding()
            HStack(spacing: 16) {
                date(ofEvent: event)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .dynamicTypeSize(.xSmall ... .accessibility4)
                    .padding(.leading, 16)
                ImageView(url: event.photoURL)
                    .frame(width: imageWidth, height: 100)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.itemBackground)
        )
    }
    
    func title(ofEvent event: Event) -> some View {
        Text(event.title)
            .foregroundStyle(Color.textLightGray)
            .font(.callout)
            .fontWeight(.medium)
            .lineLimit(3)
    }

    func date(ofEvent event: Event) -> some View {
        Text(event.date.toMonthDayYear())
            .foregroundStyle(Color.textLightGray)
            .font(.footnote)
    }
}

// MARK: Sort button

private extension EventsView {

    var sortButton: some View {
        HStack {
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
            Spacer()
        }
        .padding(.bottom, 24)
    }
}

// MARK: Search bar

private extension EventsView {

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
        .padding(.bottom, 12)
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
            height: searchBarIsFocused ? 35 : 0
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
    let viewModel = EventsViewModel(eventRepo: PreviewEventRepository())
//    let viewModel = EventsViewModel(eventRepo: PreviewEventRepository(withNetworkError: true))

    EventsView(viewModel: viewModel)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Task { await viewModel.fetchData() }
            }
        }
}
