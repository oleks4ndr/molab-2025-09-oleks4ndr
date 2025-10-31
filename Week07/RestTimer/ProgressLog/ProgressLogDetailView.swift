//
//  ProgressLogDetailView.swift
//  RestTimer
//
//  Created on 23/10/2025.
//

import SwiftUI

struct ProgressLogDetailView: View {
    let log: ProgressLog
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Image
                if let image = log.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 5)
                }
                
                // Date
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(log.formattedDate)
                        .font(.title2)
                }
                
                // Description
                if !log.description.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text(log.description)
                            .font(.body)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Progress Log")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProgressLogDetailView(log: ProgressLog(
            date: Date(),
            description: "Great workout today! Increased my reps by 10%.",
            imageData: nil
        ))
    }
}
