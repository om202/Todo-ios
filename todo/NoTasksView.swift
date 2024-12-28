import SwiftUI

struct NoTasksView: View {
    var body: some View {
        VStack(spacing: 20) {

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
            Text("No Tasks Today!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.indigo)

            // Subtitle
            Text("You're all set for now. Add new tasks to stay productive!")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 24)
        }
        .padding()
    }
}
