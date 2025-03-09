//
//  ContentView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 02.03.25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var locationManager: LocationManager
    @State private var isRegistering = false
    @State private var isAuthenticated = false

    var body: some View {
        NavigationStack {
            if !isAuthenticated {
                Home(locationManager: locationManager)
            } else {
                if isRegistering {
                    RegisterView(
                        isRegistering: $isRegistering,
                        isAuthenticated: $isAuthenticated,
                        authManager: authManager)
                } else {
                    LoginView(
                        isRegistering: $isRegistering,
                        isAuthenticated: $isAuthenticated,
                        authManager: authManager)
                }
            }
        }
    }
}
