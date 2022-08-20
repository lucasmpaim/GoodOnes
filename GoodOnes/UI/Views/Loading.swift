//
//  Loading.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import SwiftUI
import Lottie

struct LoadingView: View {
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.cyan
                    .ignoresSafeArea(.all)
                    .blur(radius: 30)
                VStack {
                    let size = proxy.frame(in: .local).size.width * 0.8
                    LottieView(animation: SharedAnimation.waiting)
                        .frame(maxWidth: size)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    Text("Wait your data is coming soon...")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#if DEBUG
struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
#endif
