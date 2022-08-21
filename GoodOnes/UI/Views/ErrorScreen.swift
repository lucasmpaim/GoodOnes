//
//  ErrorScreen.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import SwiftUI

struct ErrorScreen: View {
    
    var errorMessage: String? = nil
    var retryTitle: String = "Retry"
    @State var showRetry: Bool = false
    var retryAction: (() -> Void)? = nil
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.red
                    .blur(radius: 30)
                VStack {
                    let size = proxy.frame(in: .local).size.width * 0.8
                    LottieView(animation: SharedAnimation.alienHypnotize)
                        .frame(maxWidth: size)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    Text(errorMessage ?? "You don't see any error\nthis is just a mirage...")
                        .foregroundColor(.white)
                    if showRetry {
                        retryButton(proxy: proxy)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func retryButton(proxy: GeometryProxy) -> some View {
        Button {
            retryAction?()
        } label: {
            Text(retryTitle)
                .frame(minWidth: proxy.frame(in: .local).width * 0.8)
        }.buttonStyle(DefaultButtonStyle())

    }
    
}

#if DEBUG
struct ErrorScreen_Previews: PreviewProvider {
    static var previews: some View {
        ErrorScreen(showRetry: true)
    }
}
#endif
