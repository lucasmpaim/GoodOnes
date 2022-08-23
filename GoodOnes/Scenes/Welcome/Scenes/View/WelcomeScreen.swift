//
//  WelcomeScreen.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import SwiftUI

struct WelcomeScreen<VM: WelcomeViewModeling>: View {
    
    @ObservedObject var viewModel: VM
    
    var body: some View {
        switch viewModel.state {
        case .idle: idle()
        case .loading: LoadingView()
        case .error(let error):
            ErrorScreen(
                errorMessage: error,
                retryTitle: "Close",
                showRetry: true,
                retryAction: { [weak viewModel] in
                    viewModel?.closeError()
                }
            )
        }
    }
}

fileprivate extension WelcomeScreen {
    @ViewBuilder
    func idle() -> some View {
        GeometryReader { proxy in
            ZStack {
                backgroundImage(proxy: proxy)
                VStack {
                    Spacer()
                    welcomeContent(proxy: proxy)
                }
            }
        }.ignoresSafeArea(.all)
    }
}

fileprivate extension WelcomeScreen {
    @ViewBuilder
    func welcomeContent(proxy: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Spacer()
            (
                Text("Welcome do Good Ones App\n") +
                Text("Don't care about your photos, we take care of everything for you")
            ).padding()
             .foregroundColor(.black)
            Spacer()
            HStack(alignment: .center) {
                Button("Gallery Photos") {
                    viewModel.selectGallery()
                }
                    .buttonStyle(DefaultButtonStyle())
                Button("Google Photos") {
                    viewModel.selectGPhotos()
                }
                    .buttonStyle(DefaultButtonStyle())
            }.frame(maxWidth: .infinity)
            Spacer()
        }
        .frame(
            width: proxy.frame(in: .global).width,
            height: 250
        )
        .background(
            Color.white.ignoresSafeArea(.all)
                .cornerRadius(15, corners: [.topLeft, .topRight])
        )
    }
}

fileprivate extension WelcomeScreen {
    @ViewBuilder
    func backgroundImage(proxy: GeometryProxy) -> some View {
        let screenSize = proxy.frame(in: .global)
        Image("welcome-background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
                width: screenSize.width,
                height: screenSize.height
            ).ignoresSafeArea(.all)
            .blur(radius: 3)
    }
}

#if DEBUG
struct WelcomeScreen_Previews: PreviewProvider {
    final class FakeViewModel: WelcomeViewModeling {
        var state: WelcomeViewState = .idle
        func selectGallery() { }
        func selectGPhotos() { }
        func closeError() { }
    }
    
    static var previews: some View {
        WelcomeScreen(viewModel: FakeViewModel())
    }

}
#endif
