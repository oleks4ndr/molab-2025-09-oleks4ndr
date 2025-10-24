//
//  ProgressLog.swift
//  RestTimer
//
//  Created on 23/10/2025.
//

import SwiftUI

struct ProgressLog: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var description: String
    var imageData: Data?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
}

@Observable
class ProgressLogStore {
    var logs: [ProgressLog] = [] {
        didSet {
            save()
        }
    }
    
    private let saveKey = "ProgressLogs"
    
    init() {
        load()
    }
    
    func addLog(_ log: ProgressLog) {
        logs.insert(log, at: 0) // Add to beginning so newest is first
    }
    
    func deleteLog(at offsets: IndexSet) {
        logs.remove(atOffsets: offsets)
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([ProgressLog].self, from: data) {
            logs = decoded
        }
    }
}
