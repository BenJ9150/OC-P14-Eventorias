//
//  ChooseCategoryView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 06/06/2025.
//

import SwiftUI

struct ChooseCategoryView: View {

    @EnvironmentObject var viewModel: EventsViewModel
    @State private var currentSelection: [EventCategory] = []

    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.categories) { category in
                    categoyItem(for: category)
                        .listRowBackground(Color.itemBackground)
                        .onTapGesture {
                            toggleSelection(for: category)
                        }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .foregroundStyle(.white)
            }
            .padding(.vertical)
            .background(Color.itemBackground)
            .toolbar {
                CloseButtonItem()
            }
            .onAppear {
                currentSelection = viewModel.categoriesSelection
            }
            .onDisappear {
                withAnimation {
                    viewModel.categoriesSelection = currentSelection
                }
            }
        }
    }
}

// MARK: Category item

private extension ChooseCategoryView {

    func categoyItem(for category: EventCategory) -> some View {
        let isTitle = category == viewModel.categories.first
        let isSelected = currentSelection.contains(category)
        return VStack {
            HStack {
                Text("\(category.emoji)  \(category.name)")
                    .font(isTitle ? .title3 : .callout)
                    .fontWeight(isTitle ? .semibold : .regular)
                    .accessibilityIdentifier(category.name)
                    .accessibilityLabel("\(isSelected ? "Unselect" : "Select") \(category.name)")
                    .accessibilityHidden(isTitle)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .accessibilityHidden(true)
                }
            }
            .background(.white.opacity(0.001)) /// For tap gesture
            Rectangle()
                .fill(Color.sheetBackground)
                .frame(height: 1)
        }
        .dynamicTypeSize(.xSmall ... .accessibility3)
    }

    func toggleSelection(for category: EventCategory) {
        guard category != viewModel.categories.first else {
            return
        }
        if currentSelection.contains(category) {
            currentSelection.removeAll(where: { $0 == category })
        } else {
            currentSelection.append(category)
        }
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withViewModels()) {
    ChooseCategoryView()
}
