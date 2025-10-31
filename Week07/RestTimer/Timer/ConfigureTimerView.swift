//  ConfigureTimerView.swift

import SwiftUI

struct ConfigureTimerView: View {
    // same instance used by TimerView
    let timerObject: TimerObject
    @Binding var selectedTab: MainView.Tab
    
    // states for user input
    @State private var minutes: Int
    @State private var seconds: Int
    @State private var sets: Int
    @State private var colorTheme: ColorTheme
    @State private var ringtone: Ringtone
    @AppStorage("useDarkMode") private var useDarkMode: Bool = false
    @Environment(\.colorScheme) private var scheme
    
    
    init(timerObject: TimerObject, selectedTab: Binding<MainView.Tab>) {
        self.timerObject = timerObject
        self._selectedTab = selectedTab
        
        _minutes = State(initialValue: timerObject.timerLength / 60)
        _seconds = State(initialValue: timerObject.timerLength % 60)
        _sets = State(initialValue: timerObject.originalSets)
        _colorTheme = State(initialValue: timerObject.colorTheme)
        _ringtone = State(initialValue: timerObject.ringtone)
    }
    
    

    var body: some View {
        NavigationStack {
            Form {
                //                Section("Duration") {
                //                    Stepper("Minutes: \(minutes)", value: $minutes, in: 0...180)
                //                    Stepper("Seconds: \(seconds)", value: $seconds, in: 0...59)
                //                    Text("Total: \(displayTime(minutes * 60 + seconds))")
                //                        .foregroundStyle(.secondary)
                //                }
                Section("Duration") {
                    VStack(spacing: 12) {
                        HStack {
                            UnitWheel(title: "min", range: 0...59, value: $minutes)
                            UnitWheel(title: "sec", range: 0...59,  value: $seconds)
                        }
                        .frame(height: 160) // shows a few rows; adjust to taste

                        Text("Total: \(displayTime(minutes * 60 + seconds))")
                            .foregroundStyle(.secondary)
                            .font(.callout)
                    }
                    // Optional: make it feel like a single, centered control in Forms
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                Section("Sets") {
                    Stepper("Number of sets: \(sets)", value: $sets, in: 1...50)
                }

                Section("Appearance") {
                    Picker("Color Theme", selection: $colorTheme) {
                        ForEach(ColorTheme.allCases) { theme in
                            HStack {
                                Text(theme.rawValue)
                                Spacer()
                                Circle()
                                    .fill(theme.color(for: scheme))
                                    .frame(width: 20, height: 20)
                            }
                            .tag(theme)
                        }
                    }
                }
                
                Section("Ringtone") {
                    Picker("End of Timer Sound", selection: $ringtone) {
                        ForEach(Ringtone.allCases) { tone in
                            Text(tone.rawValue).tag(tone)
                        }
                    }
                    
                    Button("Preview Sound") {
                        timerObject.ringtone = ringtone
                        timerObject.playRingtone()
                    }
                }

//                Section {
//                    Button(role: .none) {
//                        applyChanges()
//                    } label: {
//                        Label("Save Settings", systemImage: "checkmark.circle.fill")
//                    }
//
//                    Button(role: .destructive) {
//                        discardChanges()
//                    } label: {
//                        Label("Discard Changes", systemImage: "xmark.circle")
//                    }
//                }
            }
            .navigationTitle("Configure Timer")
            .toolbar {
                // top left reset button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        discardChanges()
                    }
                    .tint(.red)
                }
                // top right save button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        applyChanges()
                        selectedTab = .timer // go back to timer after saved
                    }
                    .tint(.blue)
                    .keyboardShortcut(.defaultAction) // Return key triggers Save
                }
            }
        }
    }

    private func applyChanges() {
        // Stop current timer and apply new configuration
        timerObject.stopTimer()
        let total = max(1, minutes * 60 + seconds)
        timerObject.timerLength = total
        timerObject.colorTheme = colorTheme
        timerObject.ringtone = ringtone
        let effectiveScheme = useDarkMode ? ColorScheme.dark : scheme
        timerObject.updateColor(for: effectiveScheme)
        timerObject.originalSets = max(1, sets)
        timerObject.setsRemaining = timerObject.originalSets
        timerObject.timeElapsed = 0
    }

    private func discardChanges() {
        minutes = timerObject.timerLength / 60
        seconds = timerObject.timerLength % 60
        sets = timerObject.originalSets
        colorTheme = timerObject.colorTheme
        ringtone = timerObject.ringtone
    }

    private func displayTime(_ totalSeconds: Int) -> String {
        let m = totalSeconds / 60
        let s = totalSeconds % 60
        return String(format: "%01d:%02d", m, s)
    }
}

// unit wheel for picking duration
private struct UnitWheel: View {
    let title: String
    let range: ClosedRange<Int>
    @Binding var value: Int
    private let squeeze: CGFloat = 4 // tight join between digits + label

    var body: some View {
        HStack(spacing: -squeeze) {
            Picker("", selection: $value) {
                ForEach(range, id: \.self) { n in
                    HStack {
                        Spacer()
                        Text("\(n)")
                            .monospacedDigit()
                            .multilineTextAlignment(.trailing)
                            .padding(squeeze*2)
                    }
                    .tag(n)
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)      
            .frame(width: 110)
            .clipped()

            Text(title)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    ConfigureTimerView(timerObject: TimerObject(colorTheme: .blue, length: 75, sets: 3),
                       selectedTab: .constant(.timer))
}
