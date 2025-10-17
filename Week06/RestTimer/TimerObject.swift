import SwiftUI

@Observable
class TimerObject {
    // Observed UI-driving properties
    var timerColor: Color
    var setsRemaining: Int
    var timeElapsed = 0
    var isTimerRunning = false

    // These MUST be observed so views update when they change
    var timerLength: Int {
        didSet { UserDefaults.standard.set(timerLength, forKey: "timerLength") }
    }
    var originalSets: Int {
        didSet { UserDefaults.standard.set(originalSets, forKey: "originalSets") }
    }

    // Persistence-only fields; UI doesn’t need to track them live
    @ObservationIgnored private var timerStartEpoch: Double {
        get { UserDefaults.standard.double(forKey: "timerStartEpoch") }
        set { UserDefaults.standard.set(newValue, forKey: "timerStartEpoch") }
    }
    @ObservationIgnored private var timerWasRunning: Bool {
        get { UserDefaults.standard.bool(forKey: "timerWasRunning") }
        set { UserDefaults.standard.set(newValue, forKey: "timerWasRunning") }
    }

    init(timerColor: Color, length: Int, sets: Int) {
        self.timerColor = timerColor
        // seed from persisted values if present, else use args
        let savedLength = UserDefaults.standard.object(forKey: "timerLength") as? Int
        let savedSets   = UserDefaults.standard.object(forKey: "originalSets") as? Int
        self.timerLength = savedLength ?? length
        self.originalSets = savedSets ?? sets
        self.setsRemaining = savedSets ?? sets

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

    var buttonForeground: Color { timerColor == .white ? .black : .white }

    var remainingTime: Int { max(0, timerLength - timeElapsed) }

    var progress: CGFloat {
        guard timerLength > 0 else { return 0 }
        return CGFloat(timerLength - remainingTime) / CGFloat(timerLength)
    }

    private var timer: Timer?

    func startTimer() {
        guard !isTimerRunning else { return }
        isTimerRunning = true
        timerWasRunning = true
        timerStartEpoch = Date().timeIntervalSince1970 - Double(timeElapsed)

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.timeElapsed = min(Int(Date().timeIntervalSince1970 - self.timerStartEpoch), self.timerLength)
            if self.timeElapsed >= self.timerLength {
                self.stopTimer()
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
        !(remainingTime > 0 && !isTimerRunning && nextExerciseDisabled)
    }
    var pauseButtonDisabled: Bool {
        !(remainingTime > 0 && isTimerRunning && nextExerciseDisabled)
    }
    var resetButtonDisabled: Bool {
        !(remainingTime != timerLength && !isTimerRunning && nextExerciseDisabled)
    }
    var nextExerciseDisabled: Bool { setsRemaining != 0 }
}
