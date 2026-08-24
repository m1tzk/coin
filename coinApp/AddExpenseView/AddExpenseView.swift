//
//  AddExpenseView.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 12/08/2026.
//

import SwiftUI
import SwiftData
import MapKit
import PhotosUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Place.name, order: .reverse)
    private var places: [Place]
    
    @State private var placeName = ""
    @State private var selectedExistingPlace: Place?
    @State private var isExistingPlacePickerPresented = false
    
    @State private var drafts = [ExpenseItemDraft()]
    
//    @State private var itemName = ""
//    @State private var unitPrice: Decimal = 0
//    @State private var quantity = 1
    
    @State private var isLocationEnabled = false
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var draftPhotos: [ExpensePhotoDraft] = []
    private let maxPhotoCount = 10
    
    @State private var rating = 0
    
    @State private var saveErrorMessage: String?
    
    private let currencyCode = "BYN"
    
//    private var itemTotal: Decimal {
//        -(unitPrice * Decimal(quantity))
//    }
    
    private var normalizedPlaceName: String {
        placeName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
//    private var mormalizedItemName: String {
//        itemName.trimmingCharacters(in: .whitespacesAndNewlines)
//    }
    
    private var canSave: Bool {
        !normalizedPlaceName.isEmpty && !drafts.isEmpty && drafts.allSatisfy(\.isValid) // проверка на правильность заполнения черновика
    }
    
    var body: some View {
        Form {
            Section("Место") {
                TextField("Введите намеинование места...", text: $placeName)
                    .textInputAutocapitalization(.words)
                
                Button{
                    isExistingPlacePickerPresented = true
                } label: {
                    HStack() {
                        Text("Выбрать место, к которому вы хотите добавить запись о расходах...")
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: "magnifyingglass")
                    }
                }
                .accessibilityLabel("Выбрать уже отмеченное место.")
            }
            Section("Услуги") {
                ForEach($drafts) { $draft in
                    ExpenseDraftItemView(draft: $draft, currencyCode: currencyCode)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
                .onDelete { indexSet in
                    drafts.remove(atOffsets: indexSet)
                }
                .animation(.easeInOut(duration: 0.25), value: drafts.count)
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        drafts.append(ExpenseItemDraft())
                    }
                } label: {
                    Label("Добавить позицию", systemImage: "plus")
                }
            }
            
            if selectedExistingPlace == nil {
                Section {
                    Toggle("Место на карте", isOn: Binding(
                        get: { isLocationEnabled },
                        set: { newValue in
                            withAnimation(.easeInOut(duration: 0.25)) {
                                isLocationEnabled = newValue
                            }
                        }
                    )
                    )
                    if isLocationEnabled {
                        VStack(alignment: .leading, spacing: 8) {
                            PlacePickerView(selectedCoordinate: $selectedCoordinate, placeName: placeName)
                                .frame(height: 220)
                                .clipShape(.rect(cornerRadius: 14))
                            
                            if let selectedCoordinate {
                                Text("Выбранная точка: " + "\(selectedCoordinate.latitude.formatted(.number.precision(.fractionLength(5)))), "
                                     + "\(selectedCoordinate.longitude.formatted(.number.precision(.fractionLength(5))))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            } else {
                                Text("Нажмите на карту, чтобы добавить точку.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                header: {
                    Text("Место на карте")
                }
            } else {
                Section {
                    Label("Место выбрано из списка. Вы не можете изменить его местоположение.", systemImage: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Section("Фотографии") {
                if !draftPhotos.isEmpty {
                    PhotoFanView(
                        photos: draftPhotos,
                        onDelete: { id in
                            withAnimation(.smooth(duration: 0.25)) {
                                draftPhotos.removeAll { $0.id == id }
                            }
                        }
                    )
                    .frame(height: 135)
                }
                
                if draftPhotos.count < maxPhotoCount {
                    PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: maxPhotoCount - draftPhotos.count, selectionBehavior: .ordered, matching: .images)
                    {
                        Label("Добавить фотографии", systemImage: "plus")
                    }
                }
                
                if !draftPhotos.isEmpty {
                    Text("\(draftPhotos.count) фотографий из \(maxPhotoCount) выбрано.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .onChange(of: selectedPhotoItems) { _, newItems in
                Task {
                    await loadPhotos(from: newItems)
                }
            }
            
            Section("Поделитесь впечатлениями") {
                VStack(spacing: 10) {
                    StarRatingView(rating: $rating)
                    
                    if rating > 0 {
                        Text("\(rating) из 5")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .contentTransition(.numericText())
                            .transition(.opacity)
                            .animation(.snappy, value: rating)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .listRowBackground(Color.clear)
                .animation(.easeInOut(duration: 0.18), value: rating > 0)
            }
        }
        .navigationDestination(isPresented: $isExistingPlacePickerPresented) {
            ExistingPlacePicker { place in
                selectedExistingPlace = place
                placeName = place.name
                
                selectedCoordinate = place.coordinate
                isLocationEnabled = place.coordinate != nil
                rating = place.averageRating.map { Int($0.rounded()) } ?? 0
            }
        }
        .onChange(of: placeName) { _, newName in
            guard let selectedExistingPlace else { return }
            
            if newName != selectedExistingPlace.name {
                self.selectedExistingPlace = nil
            }
        }
        .alert("Ошибка сохранения",
            isPresented: Binding(
                get: { saveErrorMessage != nil },
                set: { if !$0 { saveErrorMessage = nil } }
            )
        ) {
            Button("Понятно", role: .cancel) { }
        } message: {
            Text(saveErrorMessage ?? "")
        }
        .navigationTitle("Новая запись")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Отмена", systemImage: "xmark") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Сохранить", systemImage: "paperplane") {
                    save()
                }
                .disabled(!canSave)
            }
        }
    }
    
    @MainActor
    private func loadPhotos(from items: [PhotosPickerItem]) async {
        for item in items {
            guard draftPhotos.count < maxPhotoCount else { break }
            do {
                if let data = try await item.loadTransferable(type: Data.self) {
                    draftPhotos.append(ExpensePhotoDraft(data: data))
                }
            } catch {
                saveErrorMessage = "Возникла ошибка при загрузке фотографий. Попробуйте еще раз."
            }
        }
        selectedPhotoItems = []
    }
    
    private func save() {
        guard canSave else { return }
        
        let place: Place
        
        if let selectedExistingPlace {
            place = selectedExistingPlace
        } else {
            let newPlace = Place(name: normalizedPlaceName, latitude: isLocationEnabled ? selectedCoordinate?.latitude : nil, longitude: isLocationEnabled ? selectedCoordinate?.longitude : nil)
            
            modelContext.insert(newPlace)
            place = newPlace
        }
        
        let record = ExpenseRecord(currencyCode: currencyCode)
        record.rating = rating == 0 ? nil : rating
        
        record.items = drafts.map { draft in
            ExpenseItem(
                serviceName: draft.serviceName.trimmingCharacters(in: .whitespacesAndNewlines), quantity: draft.quantity, unitPrice: draft.unitPrice)
        }
        
        record.photos = draftPhotos.enumerated().map { index, draft in
            ExpensePhoto(imageData: draft.data, sortOrder: index)
        }
        
        record.place = place
        // inverse relationship моделей автоматически записывает place.visits (то есть добавляет этот record по указанному пути -> place.visits.append(record) не требуется)
        
        modelContext.insert(record)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            saveErrorMessage = "Не удалось сохранить расход."
        }
    }
}

#Preview {
    AddExpenseView()
}
