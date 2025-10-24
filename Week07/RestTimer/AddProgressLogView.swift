//
//  AddProgressLogView.swift
//  RestTimer
//
//  Created on 23/10/2025.
//

import SwiftUI
import PhotosUI

struct AddProgressLogView: View {
    let logStore: ProgressLogStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var description = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Photo") {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label(selectedImage == nil ? "Add Photo" : "Change Photo", 
                              systemImage: "photo.on.rectangle.angled")
                    }
                }
                
                Section("Description") {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
                
                Section("Date") {
                    Text(currentDateFormatted)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("New Progress Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveLog()
                    }
                    .disabled(selectedImage == nil && description.isEmpty)
                }
            }
            .onChange(of: selectedItem) {
                Task {
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
            }
        }
    }
    
    private var currentDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }
    
    private func saveLog() {
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        let log = ProgressLog(
            date: Date(),
            description: description,
            imageData: imageData
        )
        logStore.addLog(log)
        dismiss()
    }
}

#Preview {
    AddProgressLogView(logStore: ProgressLogStore())
}
