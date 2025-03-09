//
//  RunTrackerView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 09.03.25.
//

import SwiftUI

struct RunTrackerView: View {
    @StateObject private var viewModel: RunTrackerViewModel

    init(trackManger: TrackManager) {
        self._viewModel = StateObject(
            wrappedValue: RunTrackerViewModel(trackManger: trackManger))
    }

    var body: some View {
        VStack {
            Spacer()

            Text(
                "\(String(format: "%.2f", viewModel.totalDistanceMoved / 1000)) KM"
            )
            .font(.system(size: 60, weight: .semibold, design: .monospaced))
            .foregroundColor(.black)
            .padding()

            Spacer()

            if viewModel.isRunning {
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
            } else {
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

        }.fullScreenCover(isPresented: $viewModel.presentCountDown) {
            CountDownView().environmentObject(viewModel)
        }
    }
}

#Preview {
    RunTrackerView(trackManger: TrackManager())
}
