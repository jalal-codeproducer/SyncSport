//
//  TrackingView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 23.03.25.
//

import SwiftUI

struct TrackingView: View {
    @StateObject var viewModel = DependencyInjection.shared
        .provideTrackingViewModel()
    @AppStorage("userId") var userId: String = ""

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 15) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)

                    Text("Error loading tracks")
                        .font(
                            .system(size: 18, weight: .bold, design: .rounded)
                        )
                        .foregroundColor(.white)

                    Text(errorMessage)
                        .font(
                            .system(size: 14, weight: .medium, design: .rounded)
                        )
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Button(action: {
                        viewModel.errorMessage = nil
                        viewModel.fetchChallengeTracks(userId: userId)
                    }) {
                        Text("Try Again")
                            .font(
                                .system(
                                    size: 16, weight: .semibold,
                                    design: .rounded)
                            )
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue.opacity(0.6))
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
            } else if viewModel.tracks.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.7))

                    Text("No Tracks Yet")
                        .font(
                            .system(size: 22, weight: .bold, design: .rounded)
                        )
                        .foregroundColor(.white)

                    Text("Complete challenges to see your activity here")
                        .font(
                            .system(size: 16, weight: .medium, design: .rounded)
                        )
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
            } else {

                ScrollView {
                    TrackCardList(tracks: viewModel.tracks)

                    VStack(spacing: 0) {

                        VStack(alignment: .leading, spacing: 15) {
                            Text("Overall Track Statistics")
                                .font(
                                    .system(
                                        size: 20, weight: .bold,
                                        design: .rounded)
                                )
                                .foregroundColor(.white)
                                .padding(.horizontal)

                            HStack(spacing: 15) {
                                statisticsCard(
                                    icon: "figure.walk",
                                    title: "Distance",
                                    value: String(
                                        format: "%.1f km",
                                        viewModel.tracks.reduce(0) {
                                            $0 + $1.distance
                                        } / 1000)  
                                )

                                statisticsCard(
                                    icon: "star.circle.fill",
                                    title: "Points",
                                    value:
                                        "\(viewModel.tracks.reduce(0) { $0 + $1.points }) pts"
                                )
                            }
                            .padding(.horizontal)

                            HStack(spacing: 15) {
                                statisticsCard(
                                    icon: "clock.fill",
                                    title: "Time",
                                    value: formatTotalDuration(
                                        viewModel.tracks.reduce(0) {
                                            $0 + $1.duration
                                        })
                                )

                                statisticsCard(
                                    icon: "flame.fill",
                                    title: "Done",
                                    value: "\(viewModel.tracks.count) tracks"
                                )
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 10)
                    }
                    .padding(.vertical)
                }
            }
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()

            // Set back button color and text color
            appearance.setBackIndicatorImage(
                UIImage(systemName: "chevron.left")?.withTintColor(
                    .white, renderingMode: .alwaysOriginal),
                transitionMaskImage: UIImage(systemName: "chevron.left")?
                    .withTintColor(.white, renderingMode: .alwaysOriginal)
            )

            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [
                .foregroundColor: UIColor.white
            ]
            appearance.backButtonAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.white
            ]

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().tintColor = .white  

            viewModel.fetchChallengeTracks(userId: userId)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .withAppBackground()
    }

    private func statisticsCard(icon: String, title: String, value: String)
        -> some View
    {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)

                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(15)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "0F2027").opacity(0.9),
                    Color(hex: "203A43").opacity(0.9),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .frame(width: UIScreen.main.bounds.width * 0.43, height: 80)
        .fixedSize(horizontal: true, vertical: true)
    }

    private func formatTotalDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

#Preview {
    TrackingView()
}
