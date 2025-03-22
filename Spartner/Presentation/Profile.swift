//
//  Profile.swift
//  SyncSports
//
//  Created by Mohammed Jalal Alamer on 20.03.25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = DependencyInjection.shared
        .provideAuthViewModel()
    @State private var showingLogoutAlert = false
    @State private var animateElements = false

    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 120, height: 120)

                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 120, height: 120)

                    Text(
                        String(viewModel.sportUser!.name.prefix(1).uppercased())
                    )
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                }
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

                Text(viewModel.sportUser!.name)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text(viewModel.sportUser!.email)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.top, 20)
            .offset(y: animateElements ? 0 : -20)
            .opacity(animateElements ? 1 : 0)

            VStack(spacing: 20) {
                HStack {
                    Text("Stats")
                        .font(
                            .system(size: 20, weight: .bold, design: .rounded)
                        )
                        .foregroundColor(.white)

                    Spacer()
                }

                HStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 60, height: 60)

                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.yellow)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Points")
                            .font(
                                .system(
                                    size: 16, weight: .medium, design: .rounded)
                            )
                            .foregroundColor(.white.opacity(0.8))

                        Text("\(viewModel.sportUser!.points)")
                            .font(
                                .system(
                                    size: 24, weight: .bold, design: .rounded)
                            )
                            .foregroundColor(.white)
                    }

                    Spacer()
                }

                let level = (viewModel.sportUser!.points / 100) + 1
                let progress = Double(viewModel.sportUser!.points % 100) / 100.0

                HStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 60, height: 60)

                        Image(systemName: "trophy.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.orange)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current Level")
                            .font(
                                .system(
                                    size: 16, weight: .medium, design: .rounded)
                            )
                            .foregroundColor(.white.opacity(0.8))

                        Text("Level \(level)")
                            .font(
                                .system(
                                    size: 24, weight: .bold, design: .rounded)
                            )
                            .foregroundColor(.white)

                        // Progress to next level
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(
                                        width: geometry.size.width, height: 8
                                    )
                                    .opacity(0.3)
                                    .foregroundColor(.white)
                                    .cornerRadius(4)

                                Rectangle()
                                    .frame(
                                        width: geometry.size.width * progress,
                                        height: 8
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(4)
                            }
                        }
                        .frame(height: 8)
                        .padding(.top, 4)

                        Text(
                            "\(viewModel.sportUser!.points % 100)/100 to Level \(level + 1)"
                        )
                        .font(
                            .system(size: 12, weight: .medium, design: .rounded)
                        )
                        .foregroundColor(.white.opacity(0.6))
                    }

                    Spacer()
                }
            }
            .padding(20)
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
            .offset(y: animateElements ? 0 : 20)
            .opacity(animateElements ? 1 : 0)

            // Logout Button
            Button(action: {
                showingLogoutAlert = true

            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 20))

                    Text("Logout")
                        .font(
                            .system(size: 16, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.6))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
            }
            .offset(y: animateElements ? 0 : 20)
            .opacity(animateElements ? 1 : 0)

            Spacer()
        }
        .padding(.bottom, 30)
        .withAppBackground()
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateElements = true
            }
        }
        .alert(isPresented: $showingLogoutAlert) {
            Alert(
                title: Text("Logout"),
                message: Text("Are you sure you want to logout?"),
                primaryButton: .destructive(Text("Logout")) {
                    viewModel.logout()
                },
                secondaryButton: .cancel()
            )
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
