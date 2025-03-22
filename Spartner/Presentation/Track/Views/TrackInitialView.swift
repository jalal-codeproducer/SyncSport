//
//  TrackInitialView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 22.03.25.
//

import SwiftUI

struct ChallengeHeaderBar: View {
    let challenge: Challenge
    let onBack: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                onBack()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            .padding(.trailing, 8)

            Spacer()

            HStack(spacing: 8) {
                Text(levelText(for: challenge.level))
                    .font(
                        .system(
                            size: 12, weight: .semibold,
                            design: .rounded)
                    )
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(levelColor(for: challenge.level))
                    .cornerRadius(12)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.yellow)
                    Text("\(challenge.points)")
                        .font(
                            .system(
                                size: 12, weight: .semibold,
                                design: .rounded)
                        )
                        .foregroundColor(.white.opacity(0.9))
                }
            }

        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)

        Text(challenge.title)
            .font(
                .system(size: 22, weight: .bold, design: .rounded)
            )
            .foregroundColor(.white)
                

        Text(challenge.description ?? "")
            .font(.system(size: 18, weight: .regular, design: .rounded))
            .foregroundColor(.white.opacity(0.8))
            .multilineTextAlignment(.leading)
            .padding(.vertical)
            .padding(.horizontal, 20)
    }

    private func levelText(for level: ChallengeLevel) -> String {
        switch level {
        case .easy:
            return "EASY"
        case .medium:
            return "MEDIUM"
        case .hard:
            return "HARD"
        }
    }

    private func levelColor(for level: ChallengeLevel) -> Color {
        switch level {
        case .easy:
            return .green.opacity(0.7)
        case .medium:
            return .orange.opacity(0.7)
        case .hard:
            return .red.opacity(0.7)
        }
    }
}

struct ReadyToStartView: View {
    let viewModel: TrackViewModel
    let challenge: Challenge

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 15)
                    .frame(width: 240, height: 240)

                VStack(spacing: 6) {
                    Text("TARGET")
                        .font(
                            .system(size: 16, weight: .medium, design: .rounded)
                        )
                        .foregroundColor(.white.opacity(0.7))

                    Text("\(String(format: "%.1f", challenge.target))")
                        .font(
                            .system(size: 62, weight: .bold, design: .rounded)
                        )
                        .foregroundColor(.white)

                    Text("KILOMETERS")
                        .font(
                            .system(size: 14, weight: .medium, design: .rounded)
                        )
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            Spacer()

            Button(action: {
                viewModel.activateCountDown()
            }) {
                HStack(spacing: 14) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 18))

                    Text("START CHALLENGE")
                        .font(
                            .system(size: 18, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 18)
                .background(Color.blue.opacity(0.7))
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            }

            Text("Tap to begin your run")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
                .padding(.top, 16)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
    }
}
