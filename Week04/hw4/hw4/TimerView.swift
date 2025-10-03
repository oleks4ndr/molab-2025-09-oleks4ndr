//
//  TimerView.swift
//  hw4
//
//  Created by Oleksandr A. on 02/10/2025.
//

import SwiftUI

struct TimerView: View {
    let timerObject: TimerObject
    
    var body: some View {
        VStack {
            Text("Sets remaining: \(timerObject.setsRemaining)")
                .bold()
                .font(.system(size: 25))
            ZStack {
                Circle()
                    .stroke(lineWidth: 30)
                    .foregroundStyle(timerObject.timerColor.opacity(0.4))
                Circle()
                    .trim(from: 0.0, to: min(1-timerObject.progress, 1.0))
                    .stroke(timerObject.timerColor.gradient, style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round,
                        lineJoin: .miter))
                    .rotationEffect(.degrees(-90))
                    .shadow(radius: 2)
                VStack{
                    Text(displayTime(timerObject.length))
                        .monospacedDigit()
                        .font(.system(size: 20))
                    Text(displayTime(timerObject.remainingTime))
                        .monospacedDigit()
                        .font(.system(size: 100))
                    
                }
                .foregroundStyle(timerObject.timerColor)
                .bold()
                .contentTransition(.numericText())
            }
            .padding(40)
            .animation(.linear, value: timerObject.remainingTime)
            
            HStack {
                // start button
                Button {
                    timerObject.startTimer()
                } label: {
                    Image(systemName: "play.fill")
                }
                .modifier(ControlButtonStyle(color: timerObject.timerColor, disabled: timerObject.playButtonDisabled))
                
                // pause/stop button
                Button {
                    timerObject.stopTimer()
                } label: {
                    Image(systemName: "pause.fill")
                }
                .modifier(ControlButtonStyle(color: timerObject.timerColor, disabled: timerObject.pauseButtonDisabled))
                
                // reset button
                Button {
                    timerObject.resetTimer()
                } label: {
                    Image(systemName: "gobackward")
                }
                .modifier(ControlButtonStyle(color: timerObject.timerColor, disabled: timerObject.resetButtonDisabled))
            }
            .padding()
            Button {
                timerObject.nextExercise()
            } label: {
                Text("Next Exercise!")
            }
            .font(.title)
            .bold()
            .frame(width: 250, height: timerObject.nextExerciseDisabled ? 0 : 80)
            .background(timerObject.timerColor)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
    
    
    func displayTime (_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%01d:%02d", minutes, seconds)
    }
}

#Preview {
    TimerView(timerObject: TimerObject(timerColor: .black, length: 5, sets: 1))
}

struct ControlButtonStyle: ViewModifier {
    let color: Color
    let disabled: Bool
    func body(content: Content) -> some View {
        content
            .font(.title)
            .bold()
            .frame(width: 80, height: 80)
            .background(color).opacity(disabled ? 0.5 : 1)
            .foregroundStyle(.white)
            .clipShape(Circle())
            .disabled(disabled)
    }
}
