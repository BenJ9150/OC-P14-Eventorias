//
//  CalendarDetailsView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 16/05/2025.
//

import SwiftUI

struct CalendarDetailsView: View {

    @Environment(\.dismiss) var dismiss

    let events: [Event]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBackground
                    .ignoresSafeArea()

                VStack {
                    LargeTitleView(title: events.first?.date.toMonthDayYear() ?? "")
                        .padding(.horizontal)
                    EventsListView(events: events)
                }
            }
            .withBackButton {
                dismiss()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CalendarDetailsView(events: PreviewEventRepository().previewEvents())
}
