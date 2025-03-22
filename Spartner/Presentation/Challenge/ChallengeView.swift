//
//  RunTrackerView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 09.03.25.
//

import SwiftUI

struct ChallengeView: View {
    @StateObject var viewModel = DependencyInjection.shared
        .provideChallengeViewmodel()
    @Environment(\.presentationMode) var presentationMode
    let challenge: Challenge

    var body: some View {
        VStack {

            switch viewModel.trackingStatus {
            case .initial:
                ChallengeHeaderBar(
                    challenge: challenge,
                    onBack: { presentationMode.wrappedValue.dismiss() }
                )
                ReadyToStartView(viewModel: viewModel, challenge: challenge)
            case .running:
                ActiveRunView(viewModel: viewModel, challenge: challenge)
            case .done:
                RunCompletedView( 
                    viewModel: viewModel,
                    onBack: { presentationMode.wrappedValue.dismiss() },
                    challenge: challenge
                )
            }
        }.navigationBarBackButtonHidden(true)
            .withAppBackground()
            .edgesIgnoringSafeArea(.bottom)
            .fullScreenCover(isPresented: $viewModel.presentCountDown) {
                CountDownView()
            }
            .onAppear{
                viewModel.setChallenge(challenge: challenge)
            }
    }
}


struct StatBlockView: View {
    let title: String
    let value: String
    let unit: String
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))

                Text(title)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
            }

            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Text(unit)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(width: 120)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
}



#Preview {
    ChallengeView(
        challenge: Challenge(
            title: "10K Consistency Goal",
            description:
                "Run or walk 10km at your own pace. A great challenge for improving endurance and fitness.",
            image: "",
            target: 10.0,
            level: .hard,
            points: 500,
            date: Date()
        ))
}
