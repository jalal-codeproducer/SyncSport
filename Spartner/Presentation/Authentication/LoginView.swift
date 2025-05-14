//
//  LoginView.swift
//  SyncSports
//
//  Created by Mohammed Jalal Alamer on 02.03.25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = DependencyInjection.shared
        .provideAuthViewModel()
    @State private var email = ""
    @State private var password = ""

    @Binding var isRegistering: Bool
    @Binding var isAuthenticated: Bool

    init(
        isRegistering: Binding<Bool>, isAuthenticated: Binding<Bool>
    ) {
        self._isRegistering = isRegistering
        self._isAuthenticated = isAuthenticated
    }

    var body: some View {
        VStack(spacing: 25) {
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 110, height: 110)

                    Image(systemName: "figure.run")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                }

            }
            .padding(.top, 20)

            Text("Welcome Back")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 20)

            VStack(spacing: 20) {
                AuthField(
                    text: $email,
                    icon: "envelope.fill",
                    title: "Email",
                    placeholder: "Enter your email",
                    keyboardType: .emailAddress
                )

                AuthField(
                    text: $password,
                    icon: "lock.fill",
                    title: "Password",
                    placeholder: "Create a password",
                    isSecure: true
                )


                if viewModel.errorMessage != nil {
                    Text(viewModel.errorMessage!)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Color.white)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.red.opacity(0.7))
                        )
                        .padding(.top, 5)
                }

                Button(action: {
                    Task {
                        if !viewModel.isLoading {
                            await viewModel.login(
                                email: email, password: password)
                        }
                    }
                }) {
                    ZStack {
                        if !viewModel.isLoading {
                            HStack {
                                Text("Login")
                                    .font(
                                        .system(
                                            size: 18, weight: .bold,
                                            design: .rounded))

                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 20))
                            }
                            .foregroundColor(Color(hex: "1a2a6c"))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Capsule()
                                    .fill(Color.white)
                            )
                        } else {
                            ProgressView()
                                .progressViewStyle(
                                    CircularProgressViewStyle(tint: .white)
                                )
                                .scaleEffect(1.2)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.3))
                                )
                        }
                    }
                }
                .padding(.top, 10)

                Button(action: {
                    if !viewModel.isLoading {
                        isRegistering = true
                    }
                }) {
                    HStack {
                        Text("Don't have an account?")
                            .font(.system(size: 16, design: .rounded))

                        Text("Register!")
                            .font(
                                .system(
                                    size: 16, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.top, 5)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .withAppBackground()

    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isRegistering = false
        @State private var isAuthenticated = false

        var body: some View {
            LoginView(
                isRegistering: $isRegistering,
                isAuthenticated: $isAuthenticated)
        }
    }

    return PreviewWrapper()
}
