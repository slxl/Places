//
//  CustomCoordinatesView.swift
//  Places
//

import SwiftUI

struct CustomCoordinatesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: CustomCoordinatesViewModel

    init(onSave: @escaping (Double, Double, String) -> Void) {
        _viewModel = State(initialValue: CustomCoordinatesViewModel(onSave: onSave))
    }

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            Form {
                Section("Coordinates") {
                    TextField("Latitude (-90 … 90)", text: $viewModel.latText)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Latitude")
                        .accessibilityHint("Enter latitude between minus 90 and 90")
                    TextField("Longitude (-180 … 180)", text: $viewModel.lonText)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Longitude")
                        .accessibilityHint("Enter longitude between minus 180 and 180")
                }
                Section("Name (optional)") {
                    TextField("Place name", text: $viewModel.nameText)
                        .accessibilityLabel("Place name")
                        .accessibilityHint("Optional name for the location")
                }
                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .dynamicTypeSize(DynamicTypeSize.accessibility1 ... DynamicTypeSize.accessibility3)
                            .accessibilityAddTraits(.isStaticText)
                            .accessibilityLabel("Validation error")
                            .accessibilityValue(errorMessage)
                    }
                }
            }
            .navigationTitle("Custom location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .accessibilityLabel("Cancel")
                    .accessibilityHint("Closes without saving")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add to list") {
                        if viewModel.save() {
                            dismiss()
                        }
                    }
                    .accessibilityLabel("Add to list")
                    .accessibilityHint("Saves the location to the list and closes this screen")
                }
            }
        }
    }
}

#Preview {
    CustomCoordinatesView(onSave: { _, _, _ in })
}
