//
//  Home.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 08.03.25.
//

import SwiftUI

struct Dashboard: View {
    @StateObject private var viewModel = DependencyInjection.shared
        .provideUserViewModel()

    @EnvironmentObject var trackManger: TrackManager

    var body: some View {
        VStack(alignment: .center) {
            if viewModel.isLoading {
                LottieView(animationFileName: "warmup", loopMode: .loop)
                    .frame(width: 125)
                    .clipShape(.circle)
            } else {
                Text("Hey \(viewModel.user?.name ?? "User")!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.leading)
                    .padding(.bottom, 20)

                RunTrackerView(trackManger: trackManger)
            }

        }
        .background(Color.white)
        .onAppear {
            if viewModel.user == nil {
                viewModel.fetchUser()
            }
        }

    }

}
class MockUserViewModel: UserViewModel {
    override func fetchUser() {
        self.user = SportUser(id: "", name: "", email: "", points: 0)
    }
}

#Preview {
    Dashboard()
        .environmentObject(TrackManager())
}
