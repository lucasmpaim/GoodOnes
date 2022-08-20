//
//  DefaultButtonStyle.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import SwiftUI

struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(.white)
            .padding()
            .background(Color.black)
            .clipShape(Capsule())
    }
}

#if DEBUG
struct DefaultButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Press") { }
            .buttonStyle(DefaultButtonStyle())
    }
}
#endif
