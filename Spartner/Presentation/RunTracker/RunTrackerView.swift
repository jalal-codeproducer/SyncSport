//
//  RunTrackerView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 09.03.25.
//

import SwiftUI

struct RunTrackerView: View {
    @StateObject private var authViewModel = DependencyInjection.shared.provideAuthViewModel()
    @StateObject private var viewModel: RunTrackerViewModel

    init(trackManger: TrackManager) {
        self._viewModel = StateObject(
            wrappedValue: RunTrackerViewModel(trackManger: trackManger))
    }

    var body: some View {
        VStack {
                switch viewModel.trackingStatus {
                case .initial:
                    Spacer()

                    Button(action: {
                        viewModel.activateCountDown()
                    }) {
                        Text("Start tracking")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 250, height: 250)
                            .background(Color.black)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }

                    Button(action: {
                        authViewModel.logout()
                    }) {
                        Text("Log out")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 120, height: 100)
                            .background(Color.black)
                            .shadow(radius: 5)
                    }

                    Spacer()
                case .running:
                    Spacer()
                    Text(
                        "\(String(format: "%.2f", viewModel.totalDistanceMoved / 1000)) KM"
                    )
                    .font(
                        .system(
                            size: 60, weight: .semibold, design: .monospaced)
                    )
                    .foregroundColor(.black)
                    .padding()

                    Spacer()

                    Button(action: {
                        viewModel.stopLocationUpdates()
                    }) {
                        Text("Stop tracking")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: 300, height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 3)
                            )
                    }
                case .done:
                    Spacer()
                    Image("finish")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    
                    Text("Great Job!")
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                        .foregroundStyle(.black)
                    
                    Text("You've completed your run")
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)

                    
                    Text(
                        "\(String(format: "%.2f", viewModel.totalDistanceMoved / 1000)) KM"
                    )
                    .font(
                        .system(
                            size: 45, weight: .semibold, design: .monospaced)
                    )
                    .foregroundColor(.black)
                    .padding()
                    
                    Spacer()

                }

        }
        .fullScreenCover(isPresented: $viewModel.presentCountDown) {
            CountDownView().environmentObject(viewModel)
        }
    }
}

#Preview {
    RunTrackerView(trackManger: TrackManager())
}
