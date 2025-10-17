//
//  MainView.swift
//  hw4
//
//  Created by Oleksandr A on 03/10/2025.
//
import SwiftUI

struct MainView: View {
    @State private var timerObject = TimerObject(timerColor: .black, length: 60, sets: 3)

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
    }
}

#Preview {
    MainView()
}




