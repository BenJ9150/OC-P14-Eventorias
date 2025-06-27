//
//  CalendarView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 11/05/2025.
//

import SwiftUI

struct CalendarView: View {

    @EnvironmentObject var viewModel: EventsViewModel

    private var calendarDetailIsPresented: Binding<Bool> {
        Binding(
            get: { viewModel.calendarEventsSelection != nil },
            set: { if !$0 { viewModel.calendarEventsSelection = nil } }
        )
    }

    var body: some View {
        NavigationStack {
            CalendarUIViewRepresentable()
                .padding(.horizontal, 8)
                .background(
                    Rectangle()
                        .fill(Color.itemBackground)
                )
                .padding(.top)
                .navigationDestination(isPresented: calendarDetailIsPresented) {
                    if let selected = viewModel.calendarEventsSelection {
                        if selected.count == 1, let event = selected.first {
                            EventDetailView(event: event)
                        } else {
                            CalendarDetailsView(events: selected)
                        }
                    }
                }
        }
    }
}

// MARK: UIViewRepresentable

struct CalendarUIViewRepresentable: UIViewRepresentable {
    
    @EnvironmentObject var viewModel: EventsViewModel
    
    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        let calendarView = UICalendarView()
        calendarView.overrideUserInterfaceStyle = .dark

        /// Autorize clic on date
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        context.coordinator.selectionBehavior = selection

        /// Set coordinator as delegate
        calendarView.delegate = context.coordinator
        calendarView.selectionBehavior = selection

        /// Set calendar constraints
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: container.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        /// Get calendar view
        guard let calendarView = uiView.subviews.compactMap({ $0 as? UICalendarView }).first else { return }
        
        /// Reload decorations when UI is updated
        let dateComponents = viewModel.events.map {
            Calendar.current.dateComponents([.year, .month, .day], from: $0.date)
        }
        calendarView.reloadDecorations(forDateComponents: dateComponents, animated: true)
    }
}

// MARK: Coordinator

extension CalendarUIViewRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        
        let viewModel: EventsViewModel
        var selectionBehavior: UICalendarSelectionSingleDate?

        init(viewModel: EventsViewModel) {
            self.viewModel = viewModel
        }

        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            /// Get current date
            guard let calendarDate = dateComponents.date else { return nil }
            
            /// Get events for this date
            let events = viewModel.events.filter { Calendar.current.isDate($0.date, inSameDayAs: calendarDate) }
            if events.isEmpty {
                return nil
            }
            
            /// Get emoji of events
            var emojis: [String] = []
            for event in events {
                guard let category = viewModel.categories.first(where: { $0.id == event.category }) else {
                    return .default(color: .systemBlue, size: .medium)
                }
                emojis.append(category.emoji)
            }
            if emojis.isEmpty {
                return .default(color: .systemBlue, size: .medium)
            }

            let emojiLabel = UILabel()
            let text = emojis.prefix(2).joined()

            if emojis.count > 2 {
                emojiLabel.text = "\(text)..."
                emojiLabel.font = UIFont.systemFont(ofSize: 13)
            } else {
                emojiLabel.text = text
                emojiLabel.font = UIFont.systemFont(ofSize: 16)
            }
            return .customView { emojiLabel }
        }

        // Selection Delegate

        func calendarView(_ calendarView: UICalendarView, didSelectDateComponents dateComponents: DateComponents) {
            print("calendarView(_:didSelectDateComponents:) appelé")
        }

        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            /// Unselect selection
            selection.selectedDate = nil

            /// Get current date
            guard let components = dateComponents, let calendarDate = components.date else { return }

            /// Get events at this date
            let events = viewModel.events.filter {
                Calendar.current.isDate($0.date, inSameDayAs: calendarDate)
            }
            if events.isEmpty {
                return
            }
            /// Update viewModel selection to display details or list of events
            DispatchQueue.main.async {
                self.viewModel.calendarEventsSelection = events
            }
        }
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withViewModels()) {
    CalendarView()
}
