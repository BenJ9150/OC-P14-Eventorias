//
//  EventDetailView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 16/05/2025.
//

import SwiftUI

struct EventDetailView: View {

    let event: Event

    var body: some View {
        Text("En construction")
    }
}

// MARK: - Preview

#Preview {
    EventDetailView(event: PreviewEventRepository().previewEvents().first!)
}
