//
//  Register.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 02.03.25.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel: RegisterViewModel
    @Binding var isRegistering: Bool
    @Binding var isAuthenticated: Bool

    init(
        isRegistering: Binding<Bool>, isAuthenticated: Binding<Bool>,
        authManager: AuthManager
    ) {
        self._isRegistering = isRegistering
        self._isAuthenticated = isAuthenticated
        self._viewModel = StateObject(
            wrappedValue: RegisterViewModel(authManager: authManager))
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                AuthenticationHeader(text: "Sing up")

                UsernameInputView(username: $viewModel.displayname)
                EmailInputView(email: $viewModel.email)
                PasswordInputView(
                    password: $viewModel.password, placeholder: "Password"
                )
                .padding(.bottom, 20)
                PasswordInputView(
                    password: $viewModel.repeatPassword,
                    placeholder: "Repeat password")

                if viewModel.errorMessage != nil {
                    Text(viewModel.errorMessage!)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(10)
                } else {
                    Spacer()
                        .frame(height: 20)
                }

                if !viewModel.isLoading {
                    Button(action: {
                        Task {
                            if !viewModel.isLoading {
                                isAuthenticated = await viewModel.register()
                            }
                        }
                    }) {

                        AuthenticationButtonContent(text: "Register")

                    }.padding(.bottom, 10)

                    Text("or")
                        .padding(.bottom, 10)
                        .fontDesign(.rounded)
                        .foregroundColor(.black)

                    Button(action: {
                        Task {
                            if !viewModel.isLoading {
                                isAuthenticated =
                                    await viewModel.singInAnonymously()

                            }
                        }
                    }) {
                        AuthenticationButtonContent(text: "Sign in as a Guest")
                    }.padding(.bottom, 20)
                } else {
                    LoadingView()
                }

                Button("Already have an account? Login!") {
                    if !viewModel.isLoading {
                        isRegistering = false
                    }
                }
                .font(.subheadline)
                .foregroundColor(.gray)

            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isRegistering = false
        @State private var isAuthenticated = false

        var body: some View {
            RegisterView(
                isRegistering: $isRegistering,
                isAuthenticated: $isAuthenticated,
                authManager: AuthManager()
            )
        }
    }

    return PreviewWrapper()
}

struct RegisterText: View {
    var body: some View {
        Text("Register")
            .foregroundColor(.black)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}
