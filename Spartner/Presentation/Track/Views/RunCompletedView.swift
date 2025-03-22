//
//  RunCompletedView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 22.03.25.
//

import SwiftUI

struct RunCompletedView: View {
    @ObservedObject var viewModel: TrackViewModel
    let onBack: () -> Void
    let challenge: Challenge

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 5) {
                    Image(
                        systemName: viewModel.isGoalReached
                            ? "trophy.fill" : "flag.checkered.2.crossed"
                    )
                    .font(.system(size: 70))
                    .foregroundColor(
                        viewModel.isGoalReached ? .yellow : .white.opacity(0.9)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)

                    Text(
                        viewModel.isGoalReached
                            ? "Challenge Complete!" : "Run Complete"
                    )
                    .font(
                        .system(size: 28, weight: .bold, design: .rounded)
                    )
                    .foregroundColor(.white)

                    if viewModel.isGoalReached {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)

                            Text("+\(challenge.points) points earned")
                                .font(
                                    .system(
                                        size: 18, weight: .semibold,
                                        design: .rounded)
                                )
                                .foregroundColor(.yellow)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.top, 20)

                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("YOUR DISTANCE")
                            .font(
                                .system(
                                    size: 14, weight: .medium, design: .rounded)
                            )
                            .foregroundColor(.white.opacity(0.7))

                        HStack(alignment: .bottom, spacing: 12) {
                            Text(
                                "\(String(format: "%.2f", (viewModel.totalDistanceMoved / 1000)))"
                            )
                            .font(
                                .system(
                                    size: 50, weight: .bold,
                                    design: .rounded)
                            )
                            .foregroundColor(.white)

                            Text("km")
                                .font(
                                    .system(
                                        size: 20, weight: .medium,
                                        design: .rounded)
                                )
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.bottom, 8)
                        }

                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 12)
                                .cornerRadius(6)

                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            .blue,
                                            viewModel.isGoalReached
                                                ? .green : .blue,
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: max(
                                        CGFloat(viewModel.completedPercentage)
                                            * 280, 10),
                                    height: 12
                                )
                                .cornerRadius(6)
                        }
                        .frame(width: 280)

                        HStack {
                            Text(
                                "Goal: \(String(format: "%.1f", challenge.target)) km"
                            )
                            .font(
                                .system(
                                    size: 16, weight: .medium, design: .rounded)
                            )
                            .foregroundColor(.white.opacity(0.8))

                            Spacer()

                            Text("\(Int(viewModel.completedPercentage * 100))%")
                                .font(
                                    .system(
                                        size: 16, weight: .bold,
                                        design: .rounded)
                                )
                                .foregroundColor(
                                    viewModel.isGoalReached ? .green : .white)
                        }
                        .frame(width: 280)
                    }

                    Divider()
                        .background(Color.white.opacity(0.2))
                        .padding(.horizontal, 20)

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
                }
                .padding(.vertical, 24)
                .background(Color.white.opacity(0.1))
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal, 20)

                VStack(spacing: 16) {
                    Button(action: {
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Results")
                        }
                        .font(
                            .system(
                                size: 16, weight: .semibold, design: .rounded)
                        )
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue.opacity(0.6))
                        .cornerRadius(16)
                    }

                    Button(action: {
                        viewModel.reset()
                        onBack()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "house.fill")
                            Text("Back to Dashboard")
                        }
                        .font(
                            .system(
                                size: 16, weight: .semibold, design: .rounded)
                        )
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    let viewModel = DependencyInjection.shared.provideRunTrackerViewmodel()

    RunCompletedView(
        viewModel: viewModel,
        onBack:{},
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
