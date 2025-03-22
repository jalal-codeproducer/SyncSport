//
//  TrackDetailView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 22.03.25.
//

import SwiftUI

struct TrackDetailView: View {
    let track: Track
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                VStack(spacing: 20) {
                    // Map visualization
                    ZStack {
                        Color(hex: "1C2E4A")

                        if !track.path.isEmpty {
                            GeometryReader { geometry in
                                Path { path in
                                    self.createPath(
                                        in: geometry.size, path: &path)
                                }
                                .stroke(Color.white, lineWidth: 3)
                            }
                            .padding(20)
                        } else {
                            Text("No path data available")
                                .foregroundColor(.white)
                        }
                    }
                    .frame(height: 250)
                    .cornerRadius(16)
                    .padding(.horizontal)

                    // Stats cards
                    HStack(spacing: 15) {
                        statCard(
                            title: "Distance",
                            value: String(format: "%.2f km", track.distance),
                            icon: "figure.walk")
                        statCard(
                            title: "Duration",
                            value: formatDuration(track.duration),
                            icon: "clock.fill")
                        statCard(
                            title: "Points", value: "\(track.points)",
                            icon: "star.circle.fill")
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Track Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }

    private func statCard(title: String, value: String, icon: String)
        -> some View
    {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)

            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let hours = minutes / 60
        let remainingMinutes = minutes % 60

        if hours > 0 {
            return "\(hours)h \(remainingMinutes)m"
        } else {
            let remainingSeconds = Int(seconds) % 60
            return "\(minutes)m \(remainingSeconds)s"
        }
    }

    private func createPath(in size: CGSize, path: inout Path) {
        guard !track.path.isEmpty else { return }

        let coordinates = track.path
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }

        guard let minLat = latitudes.min(),
            let maxLat = latitudes.max(),
            let minLong = longitudes.min(),
            let maxLong = longitudes.max()
        else { return }

        let padding: CGFloat = 20
        let drawableWidth = size.width - (padding * 2)
        let drawableHeight = size.height - (padding * 2)

        var isFirst = true
        for coordinate in coordinates {
            let latRange = maxLat - minLat
            let longRange = maxLong - minLong

            let normalizedX =
                longRange > 0
                ? CGFloat((coordinate.longitude - minLong) / longRange) : 0.5
            let normalizedY =
                latRange > 0
                ? CGFloat((coordinate.latitude - minLat) / latRange) : 0.5

            let x = padding + (normalizedX * drawableWidth)
            let y = padding + ((1 - normalizedY) * drawableHeight)

            if isFirst {
                path.move(to: CGPoint(x: x, y: y))
                isFirst = false
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
    }
}
