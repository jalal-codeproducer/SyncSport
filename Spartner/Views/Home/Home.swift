//
//  Home.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 08.03.25.
//

import SwiftUI

struct Home: View {
    @StateObject private var viewModel: HomeViewModel
    @EnvironmentObject var authManager: AuthManager

    init(locationManager: LocationManager) {
        self._viewModel = StateObject(
            wrappedValue: HomeViewModel(locationManager: locationManager))
    }

    var body: some View {
        VStack(alignment: .center) {
            Text("Hey, \(authManager.user?.displayName ?? "User")!")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding(.leading)
                .padding(.bottom, 20)

            Spacer()

            Text(
                "\(String(format: "%.2f", viewModel.totalDistanceMoved / 1000)) KM"
            )
            .font(.system(size: 60, weight: .semibold, design: .monospaced))
            .foregroundColor(.black)
            .padding()

            Spacer()

            Button(action: {
                viewModel.startLocationUpdates()
            }) {
                Text("Start tracking")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 60)
                    .background(Color.black)
                    .cornerRadius(20)
            }

        }
        .background(Color.white)
    }
}

#Preview {
    Home(locationManager: LocationManager())
        .environmentObject(AuthManager())
}
