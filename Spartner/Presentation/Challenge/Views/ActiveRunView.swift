//
//  ActiveRunView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 22.03.25.
//

import SwiftUI

struct ActiveRunView: View {
    @ObservedObject var viewModel: ChallengeViewModel
    let challenge: Challenge

    var body: some View {
        VStack {
            HStack {
                Text(Date(), style: .time)
                    .font(.system(size: 16, weight: .medium, design: .rounded))

                Text(" • ")

                Text(Date(), style: .date)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
            }
            .foregroundColor(.white.opacity(0.8))
            .padding(.top, 20)

            Spacer()

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.07))
                    .frame(width: 260, height: 260)

                Circle()
                    .trim(from: 0, to: viewModel.completedPercentage)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .green]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
                    .frame(width: 260, height: 260)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 8) {
                    Text("DISTANCE")
                        .font(
                            .system(size: 14, weight: .medium, design: .rounded)
                        )
                        .foregroundColor(.white.opacity(0.7))

                    Text(
                        "\(String(format: "%.2f", (viewModel.totalDistanceMoved / 1000)))"
                    )
                    .font(
                        .system(size: 64, weight: .bold, design: .rounded)
                    )
                    .foregroundColor(.white)

                    Text("km")
                        .font(
                            .system(
                                size: 20, weight: .semibold, design: .rounded)
                        )
                        .foregroundColor(.white.opacity(0.8))

                    Text("\(Int(viewModel.completedPercentage * 100))% of goal")
                        .font(
                            .system(size: 16, weight: .medium, design: .rounded)
                        )
                        .foregroundColor(
                            viewModel.completedPercentage >= 1.0
                                ? .green : .white.opacity(0.8)
                        )
                        .padding(.top, 6)
                }
            }
            .padding(.bottom, 40)

            HStack(spacing: 30) {
                StatBlockView(
                    title: "SPEED",
                    value: "\(String(format: "%.2f", viewModel.speed))",
                    unit: "km/h",
                    icon: "speedometer"
                )

                StatBlockView(
                    title: "DURATION",
                    value:
                        "\(viewModel.elapsedTimeMinutes):\(viewModel.elapsedTimeSeconds)",
                    unit: "min",
                    icon: "clock"
                )
            }
            .padding(.bottom, 40)

            Button(action: {
                viewModel.stopLocationUpdates()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 16, weight: .bold))

                    Text("FINISH RUN")
                        .font(
                            .system(size: 16, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 16)
                .background(Color.red.opacity(0.7))
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    let viewModel = DependencyInjection.shared.provideChallengeViewmodel()
    ActiveRunView(
        viewModel: viewModel,
        challenge: Challenge(
            title: "10K Consistency Goal",
            description:
                "Run or walk 10km at your own pace. A great challenge for improving endurance and fitness.",
            image: "",
            target: 10.0,
            level: .hard,
            points: 500,
            date: Date()
        )
    ).withAppBackground()
}
