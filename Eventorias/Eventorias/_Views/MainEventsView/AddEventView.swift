//
//  AddEventView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 23/05/2025.
//

import SwiftUI

struct AddEventView: View {

    @Environment(\.dynamicTypeSize) var dynamicSize
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: EventsViewModel

    var body: some View {
        ZStack(alignment: .top) {
            Color.mainBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                BackButtonView(title: "Creation of an event")
                ScrollView {
                    textFields
                    if !viewModel.addEventError.isEmpty {
                        ErrorView(error: viewModel.addEventError)
                            .padding(.top, 24)
                    }
                }
                .scrollIndicators(.hidden)
                validateButton
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: Textfields

private extension AddEventView {

    var textFields: some View {
        VStack(spacing: 0) {
            AppTextFieldView(
                "Title",
                text: $viewModel.addEventTitle,
                prompt: "New event",
                error: $viewModel.addEventTitleErr
            )
            AppTextFieldView(
                "Description",
                text: $viewModel.addEventDesc,
                prompt: "Tap here to enter your description",
                error: $viewModel.addEventDescErr
            )

            if dynamicSize.isAccessibilitySize {
                pickerForDate
                pickerForTime
            } else {
                HStack(spacing: 16) {
                    pickerForDate
                    pickerForTime
                }
            }

            AppTextFieldView(
                "Address",
                text: $viewModel.addEventAddress,
                prompt: "Enter full address",
                error: $viewModel.addEventAddressErr
            )
        }
        /// Set max width for iPad or iphone in landscape
        .frame(maxWidth: 440)
        .padding(.horizontal)
    }
}

// MARK: Date picker

private extension AddEventView {

    var pickerForDate: some View {
        datePicker(
            title: "Date",
            date: viewModel.addEventDate?.toMonthDayYearSlashes() ?? "MM/DD/YYYY",
            error: $viewModel.addEventDateErr,
            component: .date
        )
    }

    var pickerForTime: some View {
        datePicker(
            title: "Time",
            date: viewModel.addEventDate?.toHourMinute24h() ?? "HH : MM",
            error: $viewModel.addEventTimeErr,
            component: .hourAndMinute
        )
    }

    func datePicker(title: String, date: String, error: Binding<String>, component: DatePicker.Components) -> some View {
        let dateBinding = Binding<Date>(
            get: {
                viewModel.addEventDate ?? Date()
            },
            set: {
                viewModel.addEventDate = $0
            }
        )
        return AppInputView(title: title, error: error) {
            HStack {
                Text(date)
                    .font(.callout)
                    .foregroundStyle(viewModel.addEventDate == nil ? Color.textLightGray : .white)
                    .allowsHitTesting(false)
                    .fixedSize(horizontal: true, vertical: false)
                    .background(
                        ZStack {
                            DatePicker(
                                "",
                                selection: dateBinding,
                                in: Date()...,
                                displayedComponents: [component]
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            Rectangle()
                                .fill(Color.itemBackground)
                                .allowsHitTesting(false)
                        }
                    )
                    .clipped()
                Spacer()
            }
        }
    }
}

// MARK: Validate button

private extension AddEventView {

    var validateButton: some View {
        ZStack {
            if viewModel.addingEvent {
                AppProgressView()
            } else {
                Button {
                    Task {
                        let success = await viewModel.addEvent(byUser: authViewModel.currentUser)
                        if success {
                            dismiss()
                        }
                    }
                } label: {
                    Text("Validate")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(AppButtonPlain())
            }
        }
        /// Set max width for iPad or iphone in landscape
        .frame(maxWidth: 440)
        .padding()
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel()) {
    let viewModel = EventsViewModel(eventRepo: PreviewEventRepository(withNetworkError: true))

    AddEventView(viewModel: viewModel)
}
