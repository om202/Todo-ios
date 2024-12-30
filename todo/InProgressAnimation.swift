import SwiftUI

struct InProgressAnimation: View {
    private let height: CGFloat
    private let startTime: Date
    private let finishTime: Date?

    @State private var progress: CGFloat = 0.0
    @State private var barOffset: CGFloat = 0.0
    @State private var isAnimating = false

    @EnvironmentObject var globalTime: GlobalTimeStore

    init(height: CGFloat, startTime: Date, finishTime: Date?) {
        self.height = height
        self.startTime = startTime
        self.finishTime = finishTime
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Time Description
            HStack {
                Text(timeDescription)
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
                .cornerRadius(height / 2)
                .clipped()
            }
            .frame(height: height)
        }
        .frame(height: height + 20)
        .onAppear {
            if finishTime != nil { calculateProgress() }
        }
        .onReceive(globalTime.$globalTime) { _ in
            if finishTime != nil { calculateProgress() }
        }
        .onDisappear { isAnimating = false }
    }

    private var timeDescription: String {
        guard let finishTime = finishTime else {
            return "In Progress ⏳"
        }
        if globalTime.globalTime >= finishTime {
            return "Time Over! ⏰"
        } else {
            let remainingTime = finishTime.timeIntervalSince(globalTime.globalTime)
            return "In Progress ⏳ – \(formatTimeInterval(remainingTime)) left"
        }
    }

    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60

        if hours > 0 {
            return "\(hours)hr \(minutes)min"
        } else if minutes > 0 {
            return "\(minutes)min \(seconds)sec"
        } else {
            return "\(seconds)sec"
        }
    }

    private var progressBackgroundBar: some View {
        RoundedRectangle(cornerRadius: height / 2)
            .frame(height: height)
            .foregroundColor(.gray.opacity(0.2))
    }

    private func determinateProgressBar(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(barColor(for: progress))
            .frame(width: width * progress, height: height)
            .animation(.easeInOut(duration: 0.3), value: progress)
    }

    private func barColor(for progress: CGFloat) -> Color {
        switch progress {
        case 0..<0.8: return .indigo
        case 0.8..<1.0: return .orange
        default: return .red
        }
    }

    private func indeterminateProgressBar(width: CGFloat) -> some View {
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

    private func calculateProgress() {
        guard let finishTime = finishTime else { return }
        let totalTime = finishTime.timeIntervalSince(startTime)
        let elapsedTime = globalTime.globalTime.timeIntervalSince(startTime)
        let fraction = CGFloat(elapsedTime / totalTime)
        progress = max(min(fraction, 1.0), 0.0)
    }

    private func startIndeterminateAnimation(totalWidth: CGFloat) {
        isAnimating = true
        barOffset = -totalWidth * 0.3
        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
            barOffset = totalWidth
        }
    }
}
