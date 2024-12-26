import SwiftUI

struct InProgressAnimation: View {
    private let height: CGFloat
    private let startTime: Date
    private let finishTime: Date?

    @State private var progress: CGFloat = 0.0
    @State private var barOffset: CGFloat = 0.0
    @State private var isAnimating = false
    @State private var currentTime = Date()

    init(height: CGFloat, startTime: Date, finishTime: Date?) {
        self.height = height
        self.startTime = startTime
        self.finishTime = finishTime
    }

    var body: some View {
        VStack(alignment: .leading) {
            // 1) Status / time label
            HStack {
                Text(timeDescription)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }

            // 2) The progress bar area
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    progressBackgroundBar

                    if finishTime != nil {
                        // DETERMINATE: Color changes based on progress
                        determinateProgressBar(width: geometry.size.width)
                    } else {
                        // INDETERMINATE: Sweeping indigo gradient
                        indeterminateProgressBar(width: geometry.size.width)
                    }
                }
                .cornerRadius(10)
                .clipped()
            }
        }
        .frame(height: height + 20)  // Extra space for text
        .onAppear(perform: handleOnAppear)
        .onDisappear { isAnimating = false }
    }

    // MARK: - Time Description

    private var timeDescription: String {
        guard let finishTime = finishTime else {
            // Indeterminate: just say "In Progress"
            return "In Progress"
        }

        // Determinate
        if currentTime >= finishTime {
            // Deadline has passed
            return "Missed Deadline"
        } else {
            // Still before the deadline
            // Show time remaining: "In Progress - X left"
            let remainingTime = finishTime.timeIntervalSince(currentTime)
            return "In Progress – \(formatTimeInterval(remainingTime)) left"
        }
    }

    // Helper to format seconds into hr/min/sec text
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60

        if hours > 0 {
            // Example: "2hr 15min"
            return "\(hours)hr \(minutes)min"
        } else if minutes > 0 {
            // Example: "14min 5sec"
            return "\(minutes)min \(seconds)sec"
        } else {
            // Example: "10sec"
            return "\(seconds)sec"
        }
    }

    // MARK: - Background Bar

    private var progressBackgroundBar: some View {
        RoundedRectangle(cornerRadius: height / 2)
            .frame(height: height)
            .foregroundColor(.gray.opacity(0.1))
    }

    // MARK: - Determinate Progress Bar

    private func determinateProgressBar(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(barColor(for: progress))
            .frame(width: width * progress, height: height)
            .animation(.linear(duration: 0.2), value: progress)
    }

    /// Returns color based on current progress fraction:
    ///   - 0.0 ..< 0.8 → Indigo
    ///   - 0.8 ..< 1.0 → Orange
    ///   - >= 1.0      → Red
    private func barColor(for progress: CGFloat) -> Color {
        switch progress {
        case 0..<0.8:
            return .indigo
        case 0.8..<1.0:
            return .orange
        default:
            return .red
        }
    }

    // MARK: - Indeterminate Progress Bar (Infinite indigo)

    private func indeterminateProgressBar(width: CGFloat) -> some View {
        // Sweeping gradient in indigo shades
        let infiniteGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color.indigo.opacity(0),
                Color.indigo,
                Color.indigo.opacity(0)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )

        return RoundedRectangle(cornerRadius: height / 2)
            .fill(infiniteGradient)
            .frame(width: width * 0.3, height: height)
            .offset(x: barOffset)
            .onAppear {
                startIndeterminateAnimation(totalWidth: width)
            }
    }

    // MARK: - Lifecycle / Appearance

    private func handleOnAppear() {
        // If we have a finish time, it's determinate → calculate progress
        if finishTime != nil {
            calculateProgress()
            startProgressTimer()
        }
    }

    // MARK: - Progress Calculation

    private func calculateProgress() {
        guard let finishTime = finishTime else { return }
        let totalTime = finishTime.timeIntervalSince(startTime)
        let elapsedTime = Date().timeIntervalSince(startTime)

        let fraction = CGFloat(elapsedTime / totalTime)
        progress = max(min(fraction, 1.0), 0.0)

        currentTime = Date()
    }

    private func startProgressTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            currentTime = Date()
            calculateProgress()

            // Stop the timer if progress is fully 100%
            if progress >= 1.0 {
                timer.invalidate()
            }
        }
    }

    // MARK: - Indeterminate Animation

    private func startIndeterminateAnimation(totalWidth: CGFloat) {
        isAnimating = true
        // Start the bar “off-screen” to the left
        barOffset = -totalWidth * 0.3

        withAnimation(
            Animation.linear(duration: 2).repeatForever(autoreverses: false)
        ) {
            barOffset = totalWidth
        }
    }
}
