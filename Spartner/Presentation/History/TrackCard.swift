//
//  TrackCard.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 22.03.25.
//

import CoreLocation
import SwiftUI

struct TrackCardList: View {
    let tracks: [Track]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Tracks")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(tracks) { track in
                        TrackCard(track: track)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
            }
        }
    }
}

struct TrackCard: View {
    @State var track: Track
    @State private var showingDetails = false

    var body: some View {
        Button(action: {
            showingDetails.toggle()
        }) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "0F2027").opacity(0.9),
                        Color(hex: "203A43").opacity(0.9),
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(16)

                VStack(spacing: 12) {
                    MapPreviewView(coordinates: track.path)
                        .frame(height: 100)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 10)
                        .padding(.top, 10)

                    HStack {
                        Spacer()
                        if track.points > 0 {
                            Text("Goal Reached")
                                .font(
                                    .system(
                                        size: 12, weight: .semibold,
                                        design: .rounded)
                                )
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.green.opacity(0.3))
                                .cornerRadius(8)
                        } else {
                            Text("Done")
                                .font(
                                    .system(
                                        size: 12, weight: .semibold,
                                        design: .rounded)
                                )
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.orange.opacity(0.3))
                                .cornerRadius(8)
                        }

                        Spacer()
                    }

                    HStack(spacing: 8) {
                        Spacer()

                        metricView(
                            icon: "figure.walk",
                            value: String(format: "%.1f", track.distance),
                            unit: "KM"
                        )

                        metricView(
                            icon: "clock.fill",
                            value: formatDuration(track.duration),
                            unit: ""
                        )

                        metricView(
                            icon: "star.circle.fill",
                            value: "\(track.points)",
                            unit: "PTS"
                        )

                        Spacer()
                    }

                    Text(formatDate(track.date))
                        .font(
                            .system(size: 12, weight: .medium, design: .rounded)
                        )
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 10)
                }
                .padding(.vertical, 5)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 200, height: 220)
        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
        .sheet(isPresented: $showingDetails) {
            TrackDetailView(track: track)
        }
    }

    private func metricView(icon: String, value: String, unit: String)
        -> some View
    {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)

            HStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                if !unit.isEmpty {
                    Text(unit)
                        .font(
                            .system(size: 10, weight: .medium, design: .rounded)
                        )
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return "\(minutes)m \(remainingSeconds)s"
    }
}

struct MapPreviewView: View {
    let coordinates: [CLLocationCoordinate2D]

    var body: some View {
        ZStack {
            Color(hex: "1C2E4A")

            if !coordinates.isEmpty {
                GeometryReader { geometry in
                    Path { path in
                        self.createPath(in: geometry.size, path: &path)
                    }
                    .stroke(Color.white, lineWidth: 2)
                }
                .padding(8)
            } else {
                Image(systemName: "map")
                    .font(.system(size: 32))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }

    private func createPath(in size: CGSize, path: inout Path) {
        guard !coordinates.isEmpty else { return }

        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }

        guard let minLat = latitudes.min(),
            let maxLat = latitudes.max(),
            let minLong = longitudes.min(),
            let maxLong = longitudes.max()
        else { return }

        let padding: CGFloat = 10
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


#Preview {
    let sampleCoordinates = [
        CLLocationCoordinate2D(latitude: 25.276987, longitude: 55.296249),
        CLLocationCoordinate2D(latitude: 25.276701, longitude: 55.298102),
        CLLocationCoordinate2D(latitude: 25.275923, longitude: 55.299433),
        CLLocationCoordinate2D(latitude: 25.274502, longitude: 55.300241),
    ]

    // Sample tracks
    let tracks = [
        Track(
            userId: "user123",
            challengeId: "challenge456",
            distance: 2.5,
            duration: 1320,
            points: 75,
            date: Date(),
            path: sampleCoordinates
        ),
        Track(
            userId: "user123",
            challengeId: "challenge789",
            distance: 0.8,
            duration: 540,
            points: 0,
            date: Date().addingTimeInterval(-3600),
            path: sampleCoordinates.prefix(2).map { $0 }
        ),
        Track(
            userId: "user123",
            challengeId: "challenge101",
            distance: 5.2,
            duration: 2700,
            points: 120,
            date: Date().addingTimeInterval(-86400),
            path: sampleCoordinates.reversed()
        ),
    ]

    return ZStack {
        AppBackground()
        TrackCardList(tracks: tracks)
    }
}
