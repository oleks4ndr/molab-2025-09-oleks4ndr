//
//  ConfigureTimerView.swift
//  hw4
//
//  Created by Oleksandr A on 03/10/2025.
//

import SwiftUI

struct ConfigureTimerView: View {
    // same instance used by TimerView
    let timerObject: TimerObject

    // states for user input
    @State private var minutes: Int
    @State private var seconds: Int
    @State private var sets: Int
    @State private var color: Color

    init(timerObject: TimerObject) {
        self.timerObject = timerObject
        _minutes = State(initialValue: timerObject.length / 60)
        _seconds = State(initialValue: timerObject.length % 60)
        _sets = State(initialValue: timerObject.originalSets)
        _color = State(initialValue: timerObject.timerColor)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Duration") {
                    Stepper("Minutes: \(minutes)", value: $minutes, in: 0...180)
                    Stepper("Seconds: \(seconds)", value: $seconds, in: 0...59)
                    Text("Total: \(displayTime(minutes * 60 + seconds))")
                        .foregroundStyle(.secondary)
                }

                Section("Sets") {
                    Stepper("Number of sets: \(sets)", value: $sets, in: 1...50)
                }

                Section("Appearance") {
                    ColorPicker("Timer Color", selection: $color, supportsOpacity: false)
                }

                Section {
                    Button(role: .none) {
                        applyChanges()
                    } label: {
                        Label("Save Settings", systemImage: "checkmark.circle.fill")
                    }

                    Button(role: .destructive) {
                        discardChanges()
                    } label: {
                        Label("Discard Changes", systemImage: "xmark.circle")
                    }
                }
            }
            .navigationTitle("Configure Timer")
        }
    }

    private func applyChanges() {
        // Stop current timer and apply new configuration
        timerObject.stopTimer()
        let total = max(1, minutes * 60 + seconds)
        timerObject.length = total
        timerObject.timerColor = color
        timerObject.originalSets = max(1, sets)
        timerObject.setsRemaining = timerObject.originalSets
        timerObject.timeElapsed = 0
    }

    private func discardChanges() {
        minutes = timerObject.length / 60
        seconds = timerObject.length % 60
        sets = timerObject.originalSets
        color = timerObject.timerColor
    }

    private func displayTime(_ totalSeconds: Int) -> String {
        let m = totalSeconds / 60
        let s = totalSeconds % 60
        return String(format: "%01d:%02d", m, s)
    }
}

#Preview {
    ConfigureTimerView(timerObject: TimerObject(timerColor: .blue, length: 75, sets: 3))
}
