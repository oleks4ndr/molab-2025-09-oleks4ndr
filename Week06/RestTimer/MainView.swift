//
//  MainView.swift
//  hw4
//
//  Created by Oleksandr A on 03/10/2025.
//
import SwiftUI

struct MainView: View {
    enum Tab: Hashable { case timer, config }

    @State private var timerObject = TimerObject(timerColor: .black, length: 60, sets: 3)
    @State private var selectedTab: Tab = .timer
    
    @Environment(\.colorScheme) private var scheme
    @AppStorage("useDarkMode") private var useDarkMode: Bool = false
    var body: some View {
        TabView(selection: $selectedTab) {
            RestTimerView(timerObject: timerObject)
                .tabItem { Label("Rest Timer", systemImage: "timer") }
                .tag(Tab.timer)
            
            ConfigureTimerView(timerObject: timerObject, selectedTab: $selectedTab)
                .tabItem { Label("Configure", systemImage: "gearshape") }
                .tag(Tab.config)
            
            
        }
        .preferredColorScheme(useDarkMode ? .dark : .light)
        .onAppear {
            // initiate timer color based on dark preference
            timerObject.timerColor = (useDarkMode || scheme == .dark) ? .white : .black
        }
    }
}

#Preview {
    MainView()
}




