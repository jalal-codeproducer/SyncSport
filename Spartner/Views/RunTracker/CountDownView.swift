//
//  CountDownVIew.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 09.03.25.
//

import AVFAudio
import SwiftUI

struct CountDownView: View {
    @EnvironmentObject var viewModel: RunTrackerViewModel
    @State var timer: Timer?
    @State var countDown = 4
    @State var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack {
            if(countDown > 1){
                Text("\(countDown - 1)")
                    .font(.system(size: 128))
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.blue)
            } else {
                Text("GO!")
                    .font(.system(size: 128))
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.blue)
            }


        }.onAppear {
            setupCountDown()
        }
    }

    func setupCountDown() {
        playBeepSound()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            _ in
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

    func playBeepSound() {
        guard let path = Bundle.main.path(forResource: "beep", ofType: "mp3")
        else { return }

        do {
            audioPlayer = try AVAudioPlayer(
                contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CountDownView()
}
