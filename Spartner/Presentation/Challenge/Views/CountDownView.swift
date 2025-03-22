import AVFAudio
import SwiftUI

struct CountDownView: View {
    @State var viewModel = DependencyInjection.shared
        .provideChallengeViewmodel()
    @State private var timer: Timer?
    @State private var countDown = 4
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(getLevelColor().opacity(0.2))
                    .frame(width: 220, height: 220)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )

                Text(countDown > 1 ? "\(countDown - 1)" : "GO!")
                    .font(.system(size: 100, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            }
            .padding(.bottom, 40)

            HStack(spacing: 16) {
                ForEach(1...3, id: \.self) { index in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 12, height: 12)
                        .opacity(getCountdownOpacity(for: index))
                }
            }
            .padding()

            Text("Get ready to start your challenge!")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .padding(.top, 20)
                .padding(.horizontal, 40)
                .multilineTextAlignment(.center)
        }.withAppBackground()
            .onAppear {
                setupCountDown()
            }

    }

    private func setupCountDown() {
        playBeepSound()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            _ in
            Task { @MainActor in
                if countDown <= 1 {
                    timer?.invalidate()
                    timer = nil
                    viewModel.startLocationUpdates()
                } else {
                    countDown -= 1
                }
            }
        }
    }

    private func playBeepSound() {
        guard let path = Bundle.main.path(forResource: "beep", ofType: "mp3")
        else { return }

        do {
            audioPlayer = try AVAudioPlayer(
                contentsOf: URL(fileURLWithPath: path))
            // audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }

    private func getCountdownOpacity(for position: Int) -> Double {
        let remainingCount = countDown - 1
        return position >= remainingCount ? 1.0 : 0.3
    }

    private func getLevelColor() -> Color {
        switch countDown {
        case 4:
            return .red
        case 3:
            return .orange
        case 2:
            return .yellow
        case 1:
            return .green
        default:
            return .green
        }
    }
}

#Preview {
    CountDownView()
}
