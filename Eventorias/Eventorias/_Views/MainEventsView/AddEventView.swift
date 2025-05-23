//
//  AddEventView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 23/05/2025.
//

import SwiftUI

struct AddEventView: View {

    @Environment(\.verticalSizeClass) var verticalSize
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: EventsViewModel

    var body: some View {
        ZStack(alignment: .top) {
            Color.mainBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                bannerTitle
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

            HStack(spacing: 16) {
                AppInputView(title: "Date", error: $viewModel.addEventDateErr) {
                    DatePicker("", selection: $viewModel.addEventDate, displayedComponents: [.date])
                        .labelsHidden()
                }
                AppInputView(title: "Time", error: $viewModel.addEventTimeErr) {
                    DatePicker("", selection: $viewModel.addEventDate, displayedComponents: [.hourAndMinute])
                        .labelsHidden()
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

// MARK: Validate button

private extension AddEventView {

    var validateButton: some View {
        ZStack {
            if viewModel.addingEvent {
                AppProgressView()
            } else {
                Button {
                    Task {
                        await viewModel.addEvent(byUser: authViewModel.currentUser)
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


// MARK: Banner title

private extension AddEventView {

    var bannerTitle: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.backward")
                        .font(.body)
                        .fontWeight(.semibold)
                        .padding(.leading)

                    Text("Creation of an event")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .frame(minWidth: 44, minHeight: 44)
            }
            .foregroundStyle(.white)
            Spacer()
        }
        .padding(.bottom, 12)
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel()) {
    let viewModel = EventsViewModel(eventRepo: PreviewEventRepository(withNetworkError: true))

    AddEventView(viewModel: viewModel)
}
