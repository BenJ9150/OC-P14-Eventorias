//
//  EventsListView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 16/05/2025.
//

import SwiftUI

struct EventsListView: View {

    @Environment(\.dynamicTypeSize) var dynamicSize
    @Environment(\.verticalSizeClass) var verticalSize

    let events: [Event]

    private var imageWidth: CGFloat {
        UIScreen.main.bounds.width <= 375 ? 110 : 136
    }

    private var gridColumms: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: 16),
            count: isPad ? 2 : 1
        )
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridColumms, spacing: isPad ? 16 : 8) {
                    ForEach(events) { event in
                        NavigationLink {
                            EventDetailView(event: event)
                        } label: {
                            if dynamicSize.isAccessibilitySize && verticalSize != .compact {
                                eventItemHighSize(event)
                            } else {
                                eventItem(event)
                            }
                        }

                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
    }
}

// MARK: Event item

private extension EventsListView {

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

// MARK: - Preview

#Preview {
    EventsListView(events: PreviewEventRepository().previewEvents())
}
