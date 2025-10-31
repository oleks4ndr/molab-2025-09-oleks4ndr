//
//  ProgressLogView.swift
//  RestTimer
//
//  Created on 23/10/2025.
//

import SwiftUI

struct ProgressLogView: View {
    @State private var logStore = ProgressLogStore()
    @State private var showingAddLog = false
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationStack {
            ZStack {
                if logStore.logs.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        Text("No Progress Logs Added")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    // List of logs
                    List {
                        ForEach(logStore.logs) { log in
                            NavigationLink {
                                ProgressLogDetailView(log: log)
                            } label: {
                                ProgressLogRowView(log: log)
                            }
                        }
                        .onDelete(perform: deleteLog)
                    }
                }
            }
            .navigationTitle("Progress Log")
            .toolbar {
                // top left edit button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(editMode.isEditing ? "Done" : "Edit") {
                        editMode = editMode.isEditing ? .inactive : .active
                    }
                    .disabled(logStore.logs.isEmpty == true)
                }
                // top right
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddLog = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddLog) {
                AddProgressLogView(logStore: logStore)
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    private func deleteLog(at offsets: IndexSet) {
        logStore.deleteLog(at: offsets)
    }
}

// Row view for each log entry
struct ProgressLogRowView: View {
    let log: ProgressLog
    
    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail image
            if let image = log.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundStyle(.secondary)
                    }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(log.formattedDate)
                    .font(.headline)
                
                if !log.description.isEmpty {
                    Text(log.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProgressLogView()
}
