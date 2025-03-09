import AVFAudio
import SwiftUI

struct CountDownView: View {
    @EnvironmentObject var viewModel: RunTrackerViewModel
    @State private var timer: Timer?
    @State private var countDown = 4
    @State private var audioPlayer: AVAudioPlayer?

    private let countdownColors: [Color] = [.red, .orange, .yellow, .green]
    
    var body: some View {
        VStack {
            Text(countDown > 1 ? "\(countDown - 1)" : "GO!")
                .font(.system(size: 128))
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(countDown > 1 ? countdownColors[4 - countDown] : .green)
                .animation(.easeInOut(duration: 0.5), value: countDown)
        }
        .onAppear {
            setupCountDown()
        }
    }

    private func setupCountDown() {
        playBeepSound()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                if countDown <= 1 {
                    timer?.invalidate()
                    timer = nil
                    viewModel.presentCountDown = false
                } else {
                    countDown -= 1
                }
            }
        }
    }

    private func playBeepSound() {
        guard let path = Bundle.main.path(forResource: "beep", ofType: "mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CountDownView()
}
