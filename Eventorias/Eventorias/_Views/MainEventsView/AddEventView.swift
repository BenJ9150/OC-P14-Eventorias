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
    @StateObject private var viewModel: AddEventViewModel

    let eventAdded: () -> Void

    // Picture

    @State private var showPhotoPicker = false
    @State private var showCamera = false

    // Focus

    @FocusState private var descIsFocused: Bool
    @FocusState private var addressIsFocused: Bool

    // MARK: Init

    init(
        categories: [EventCategory],
        eventRepo: EventRepository = AppEventRepository(),
        eventAdded: @escaping () -> Void
    ) {
        self._viewModel = StateObject(
            wrappedValue: AddEventViewModel(eventRepo: eventRepo, categories: categories)
        )
        self.eventAdded = eventAdded
    }

    // MARK: Body

    var body: some View {
        ZStack(alignment: .top) {
            Color.mainBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                BackButtonView(title: "Creation of an event")
                scrollContent
                    .frame(maxWidth: .maxWidthForPad * 1.5)
                validateButton
                    .frame(maxWidth: .maxWidthForPad)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationBarHidden(true)
        .takePhoto(
            image: $viewModel.addEventPhoto,
            showCamera: $showCamera,
            showPhotoPicker: $showPhotoPicker
        )
    }
}

// MARK: Scroll content

private extension AddEventView {

    var scrollContent: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    if !viewModel.addEventError.isEmpty {
                        ErrorView(error: viewModel.addEventError)
                            .padding(.vertical, 24)
                            .id("top")
                    }
                    textFields
                    imageButtons
                }
            }
            .scrollIndicators(.hidden)
            .onChange(of: viewModel.addEventError) { _, newValue in
                if !newValue.isEmpty {
                    withAnimation {
                        proxy.scrollTo("top", anchor: .top)
                    }
                }
            }
        }

    }
}

// MARK: Image buttons

private extension AddEventView {

    var imageButtons: some View {
        HStack(spacing: 16) {
            Button {
                showCamera.toggle()
            } label: {
                Image(systemName: "camera")
            }
            .buttonStyle(AppButtonSquare(white: true))
            
            Button {
                showPhotoPicker.toggle()
            } label: {
                Image(systemName: "paperclip")
                    .rotationEffect(Angle(degrees: -45))
            }
            .buttonStyle(AppButtonSquare(small: true))
            
            if let photo = viewModel.addEventPhoto {
                selectedPhoto(photo)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }

    func selectedPhoto(_ photo: UIImage) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: photo)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 220)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .clipped()
            
            Button {
                withAnimation(.bouncy(duration: 0.3)) {
                    viewModel.addEventPhoto = nil
                }
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
        }
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
            .submitLabel(.continue)
            .onSubmit { descIsFocused = true }

            AppTextFieldView(
                "Description",
                text: $viewModel.addEventDesc,
                prompt: "Tap here to enter your description",
                error: $viewModel.addEventDescErr
            )
            .focused($descIsFocused)
            .submitLabel(.continue)
            .onSubmit { addressIsFocused = true }

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
            .focused($addressIsFocused)
            .textContentType(.addressCityAndState)
            .submitLabel(.return)

            categoryPicker
        }
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
            get: { viewModel.addEventDate ?? Date() },
            set: { viewModel.addEventDate = $0 }
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
            .dynamicTypeSize(.xSmall ... .accessibility4)
        }
    }
}

// MARK: Category picker

private extension AddEventView {

    var categoryPicker: some View {
        AppInputView(title: "Category", error: $viewModel.addEventCategoryErr) {
            Text("\(viewModel.addEventCategory.name) \(viewModel.addEventCategory.emoji)")
                .font(.callout)
                .foregroundStyle(viewModel.addEventDate == nil ? Color.textLightGray : .white)
                .allowsHitTesting(false)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    ZStack {
                        Picker("", selection: $viewModel.addEventCategory) {
                            ForEach(viewModel.categories) { category in
                                Text("\(category.emoji) \(category.name)")
                                    .tag(category)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Rectangle()
                            .fill(Color.itemBackground)
                            .allowsHitTesting(false)
                    }
                )
                .clipped()
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
                            eventAdded()
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
        .padding()
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel()) {
    AddEventView(
        categories: PreviewEventRepository().previewCategories(),
        eventRepo: PreviewEventRepository(withNetworkError: true)
    ) {}
}
