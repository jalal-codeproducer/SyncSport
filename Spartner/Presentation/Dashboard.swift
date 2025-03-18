//
//  Home.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 08.03.25.
//

import SwiftUI

struct Dashboard: View {
    @StateObject private var viewModel = DependencyInjection.shared
        .provideAuthViewModel()
    
    @EnvironmentObject var trackManger: TrackManager

    var body: some View {
        VStack(alignment: .center) {
            Text("Hey, \(viewModel.user?.name ?? "User")!")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding(.leading)
                .padding(.bottom, 20)
                         
                         
            RunTrackerView(trackManger: trackManger)
           

        }
        .background(Color.white)
    }
}

#Preview {
    Dashboard()
        .environmentObject(TrackManager())
}
