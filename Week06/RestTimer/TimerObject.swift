//  TimerObject.swift

import SwiftUI

@Observable
class TimerObject {
    var timerColor: Color
    var buttonForeground: Color { timerColor == .white ? .black : .white }

    @ObservationIgnored @AppStorage("timerLength") var timerLength: Int = 180 // default is 3 mins
    @ObservationIgnored @AppStorage("originalSets") var originalSets: Int = 3
    @ObservationIgnored @AppStorage("timerStartEpoch") private var timerStartEpoch: Double = 0
    @ObservationIgnored @AppStorage("timerWasRunning") private var timerWasRunning: Bool = false
    var setsRemaining: Int
    
    init(timerColor: Color, length: Int, sets: Int) {
        self.timerColor = timerColor
        self.timerLength = length
        self.setsRemaining = sets
        self.originalSets = sets
        
        if timerWasRunning && timerStartEpoch > 0 {
            let elapsed = Int(Date().timeIntervalSince1970 - timerStartEpoch)
            timeElapsed = min(max(0, elapsed), timerLength)
            if timeElapsed < timerLength {
                startTimer()
            } else {
                timerWasRunning = false
                isTimerRunning = false
            }
        }

    }
    
    var timer: Timer? = nil
    var timeElapsed = 0
    
    var isTimerRunning = false
    
    var remainingTime: Int {
        max(0, timerLength - timeElapsed)
    }
    
    var progress: CGFloat {
        CGFloat(timerLength - remainingTime) / CGFloat(timerLength)
    }
    
    func startTimer() {
        guard !isTimerRunning else { return }
        isTimerRunning = true
        timerWasRunning = true
        timerStartEpoch = Date().timeIntervalSince1970 - Double(timeElapsed) // anchor

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            // derive elapsed from anchor -> works across app closes
            timeElapsed = min(Int(Date().timeIntervalSince1970 - timerStartEpoch), timerLength)
            if timeElapsed >= timerLength {
                stopTimer()
            }
        }
    }
    
    func stopTimer() {
        if isTimerRunning {
            isTimerRunning = false
            timerWasRunning = false
            timer?.invalidate()
            timerStartEpoch = 0
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        timeElapsed = 0
        isTimerRunning = false
        timerWasRunning = false
        timerStartEpoch = 0
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
        guard remainingTime != timerLength, !isTimerRunning, nextExerciseDisabled else { return true }
        return false
    }
    
    var nextExerciseDisabled: Bool {
        return setsRemaining != 0
    }
}

