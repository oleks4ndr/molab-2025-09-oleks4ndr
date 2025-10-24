//
//  MainView.swift
//  hw4
//
//  Created by Oleksandr A on 03/10/2025.
//
import SwiftUI

struct MainView: View {
    enum Tab: Hashable { case timer, config, progressLog }

    @State private var timerObject = TimerObject(colorTheme: .monochrome, length: 60, sets: 3)
    @State private var selectedTab: Tab = .timer

    @Environment(\.colorScheme) private var scheme
    @AppStorage("useDarkMode") private var useDarkMode: Bool = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RestTimerView(timerObject: timerObject)
                .tabItem { Label("Rest Timer", systemImage: "timer") }
                .tag(Tab.timer)
            
            ProgressLogView()
                .tabItem { Label("Progress Log", systemImage: "chart.line.uptrend.xyaxis") }
                .tag(Tab.progressLog)
            
            ConfigureTimerView(timerObject: timerObject, selectedTab: $selectedTab)
                .tabItem { Label("Configure", systemImage: "gearshape") }
                .tag(Tab.config)
        }
        .preferredColorScheme(useDarkMode ? .dark : .light)
        .onAppear {
            updateTimerColor()
        }
        .onChange(of: useDarkMode) {
            updateTimerColor()
        }
        .onChange(of: scheme) {
            updateTimerColor()
        }
    }
    
    private func updateTimerColor() {
        let effectiveScheme = useDarkMode ? ColorScheme.dark : (scheme == .dark ? .dark : .light)
        timerObject.updateColor(for: effectiveScheme)
    }
}

#Preview {
    MainView()
}




