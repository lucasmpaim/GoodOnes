//
//  WelcomeScreen.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import SwiftUI

struct WelcomeScreen: View {
    var body: some View {
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
            Spacer()
            HStack(alignment: .center) {
                Button("Gallery Photos") {}
                    .buttonStyle(DefaultButtonStyle())
                Button("Google Photos") {}
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
                .cornerRadius(30, corners: [.topLeft, .topRight])
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
    static var previews: some View {
        WelcomeScreen()
    }
}
#endif
