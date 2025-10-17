//
//  MainView.swift
//  hw4
//
//  Created by Oleksandr A on 03/10/2025.
//
import SwiftUI

struct MainView: View {
    @State private var timerObject = TimerObject(timerColor: .black, length: 60, sets: 3)
    @Environment(\.colorScheme) private var scheme
    @AppStorage("useDarkMode") private var useDarkMode: Bool = false
    var body: some View {
        TabView {
            RestTimerView(timerObject: timerObject)
                .tabItem {
                    Label("Rest Timer", systemImage: "timer")
                }
            
            ConfigureTimerView(timerObject: timerObject)
                .tabItem {
                    Label("Configure", systemImage: "gearshape")
                }
            
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




