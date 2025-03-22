//
//  ChallengeCard.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 20.03.25.
//

import SwiftUI

struct ChallengeCard: View {
    @State var challenge: Challenge
    @State private var rotation = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "1a2a6c").opacity(0.85),
                    Color(hex: "b21f1f").opacity(0.85)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(16)
            
            HStack(spacing: 15) {
                ZStack(alignment: .bottomTrailing) {
                    if let image = ImageUtilities().base64StringToImage(challenge.image!) {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 110, height: 130)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            )
                    } else {
                        Image("3")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 110, height: 130)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            )
                    }
                    
                    levelBadge
                        .padding(8)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(challenge.title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        metricView(
                            icon: "figure.walk",
                            value: "\(challenge.target) KM"
                        )
                        
                        metricView(
                            icon: "star.circle.fill",
                            value: "\(challenge.points) PTS"
                        )
                    }
                    
                    NavigationStack {
                        NavigationLink(destination: ChallengeView(challenge: challenge)) {
                            ZStack {
                                Text("View Challenge")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .padding(.top, 5)
                    }
                }
            }
            .padding(15)
        }
        .frame(height: 160)
        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    private var levelBadge: some View {
        HStack(spacing: 0) {
            ForEach(1...3, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.white)
                    .opacity(getLevelOpacity(for: index))
            }
        }
        .padding(6)
        .background(getLevelColor().opacity(0.8))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }

    private func getLevelOpacity(for position: Int) -> Double {
        switch challenge.level {
        case .easy:
            return position == 1 ? 1 : 0.3
        case .medium:
            return position <= 2 ? 1 : 0.3
        case .hard:
            return 1
        }
    }

    private func getLevelColor() -> Color {
        switch challenge.level {
        case .easy:
            return .green
        case .medium:
            return .orange
        case .hard:
            return .red
        }
    }
    
    private func metricView(icon: String, value: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
            
            Text(value)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}



#Preview {
    @Previewable @State var challenge = Challenge(
        title: "Quick Start: 1K Warm-Up",
        description:
            "Begin your fitness journey with a light 1km jog or brisk walk. Perfect for warming up the body and getting into a routine.",
        image: "4",
        target: 1.0,
        level: .medium,
        points: 50,
        date: Date()
    )

    ChallengeCard(
        challenge: challenge
    )
}
