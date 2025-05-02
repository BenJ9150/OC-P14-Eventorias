//
//  EventsView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import SwiftUI

struct EventsView: View {

    @ObservedObject var viewModel: EventsViewModel

    var body: some View {
        ScrollView {
            ForEach(viewModel.categories) { category in
                Text(category.name)
            }
            Divider()
            ForEach(viewModel.events) { event in
                Text(event.title)
            }
        }
        .padding()
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview {
    let viewModel = EventsViewModel(eventRepo: PreviewEventRepository())
    EventsView(viewModel: viewModel)
}
