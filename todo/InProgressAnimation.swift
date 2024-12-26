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
            HStack {
                Text(timeDescription)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    progressBackgroundBar

                    if finishTime != nil {
                        determinateProgressBar(width: geometry.size.width)
                    } else {
                        indeterminateProgressBar(width: geometry.size.width)
                    }
                }
                .cornerRadius(10)
                .clipped()
            }
        }
        .frame(height: height + 20)  // Additional height for text
        .onAppear(perform: handleOnAppear)
        .onDisappear { isAnimating = false }
    }

    private var timeDescription: String {
        if finishTime == nil {
            return "No limit"
        }

        guard let finishTime = finishTime else { return "" }

        if currentTime > finishTime {
            let passedTime = currentTime.timeIntervalSince(finishTime)
            return "Past \(formatTimeInterval(passedTime))"
        } else {
            let remainingTime = finishTime.timeIntervalSince(currentTime)
            return "\(formatTimeInterval(remainingTime)) left"
        }
    }

    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60

        if hours > 0 {
            return "\(hours) hr \(minutes) min \(seconds) sec"
        } else if minutes > 0 {
            return "\(minutes) min \(seconds) sec"
        } else {
            return "\(seconds) sec"
        }
    }

    private var progressBackgroundBar: some View {
        RoundedRectangle(cornerRadius: height / 2)
            .frame(height: height)
            .foregroundColor(.gray.opacity(0.3))
    }

    private func determinateProgressBar(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: height / 2)
            .frame(width: width * progress, height: height)
            .foregroundColor(Date() > finishTime! ? .pink : .indigo)
            .animation(.linear(duration: 0.2), value: progress)
    }

    private func indeterminateProgressBar(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: height / 2)
            .frame(width: width * 0.3, height: height)
            .foregroundColor(.indigo)
            .offset(x: barOffset)
            .onAppear { startIndeterminateAnimation(totalWidth: width) }
    }

    private func handleOnAppear() {
        if finishTime != nil {
            calculateProgress()
            startProgressTimer()
        }
    }

    private func calculateProgress() {
        guard let finishTime = finishTime else { return }
        let totalTime = finishTime.timeIntervalSince(startTime)
        let elapsedTime = Date().timeIntervalSince(startTime)
        progress = CGFloat(min(max(elapsedTime / totalTime, 0), 1))
    }

    private func startProgressTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            currentTime = Date()
            calculateProgress()
            if progress >= 1.0 {
                timer.invalidate()
            }
        }
    }

    private func startIndeterminateAnimation(totalWidth: CGFloat) {
        isAnimating = true
        barOffset = -totalWidth * 0.3
        withAnimation(
            Animation.linear(duration: 2).repeatForever(autoreverses: false)
        ) {
            barOffset = totalWidth
        }
    }
}
