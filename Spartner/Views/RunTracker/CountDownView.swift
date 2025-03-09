//
//  CountDownVIew.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 09.03.25.
//

import SwiftUI

struct CountDownView: View {
    @EnvironmentObject var viewModel: RunTrackerViewModel
    @State var timer: Timer?
    @State var countDown = 3

    var body: some View {
        Text("\(countDown)")
            .font(.system(size: 128))
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue)
            .onAppear {
                setupCountDown()
            }
    }

    func setupCountDown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            _ in
            Task { @MainActor in
                if countDown <= 1 {
                    timer?.invalidate()
                    timer = nil
                    viewModel.presentCountDown = false
                } else {
                    countDown -= 1
                }
            }
        }
    }
}

#Preview {
    CountDownView()
}
