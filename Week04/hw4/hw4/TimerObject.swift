//
//  TimerObject.swift
//  hw4
//
//  Created by Oleksandr A. on 02/10/2025.
//

import SwiftUI

@Observable
class TimerObject {
    var timerColor: Color
    var length: Int
    var originalSets: Int
    var setsRemaining: Int
    
    init(timerColor: Color, length: Int, sets: Int) {
        self.timerColor = timerColor
        self.length = length
        self.setsRemaining = sets
        self.originalSets = sets
    }
    
    var timer: Timer? = nil
    var timeElapsed = 0
    
    var isTimerRunning = false
    
    var remainingTime: Int {
        length - timeElapsed
    }
    
    var progress: CGFloat {
        CGFloat(length - remainingTime) / CGFloat(length)
    }
    
    func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            if remainingTime > 0 {
                timeElapsed += 1
            } else {
                stopTimer()
            }
        }
    }
    
    func stopTimer () {
        if isTimerRunning {
            isTimerRunning = false
            timer?.invalidate()
        }
    }
    
    func resetTimer() {
        timeElapsed = 0
        isTimerRunning = false
        setsRemaining -= 1
    }
    
    func nextExercise() {
        setsRemaining = originalSets
    }
    
    var playButtonDisabled: Bool {
        guard remainingTime > 0, !isTimerRunning, nextExerciseDisabled else { return true }
        return false
    }
    
    var pauseButtonDisabled: Bool {
        guard remainingTime > 0, isTimerRunning, nextExerciseDisabled else { return true }
        return false
    }
    
    var resetButtonDisabled: Bool {
        guard remainingTime != length, !isTimerRunning, nextExerciseDisabled else { return true }
        return false
    }
    
    var nextExerciseDisabled: Bool {
        return setsRemaining != 0
    }
}
