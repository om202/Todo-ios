import SwiftUI

struct NoTasksView: View {
    var currentDate: Date;
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.orange, .yellow]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .mask(
                    Image(systemName: "sun.max.fill")
                        .resizable()
                        .scaledToFit()
                )
                .frame(width: 80, height: 80)
            }

            // Title
            Text("No Tasks")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.indigo)

            // Subtitle
            Text("Add new tasks to stay productive!")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
