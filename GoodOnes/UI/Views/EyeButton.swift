//
//  EyeButton.swift
//  GoodOnes
//
//  Created by Lucas Paim on 21/08/22.
//

import SwiftUI

enum EyeIcon : String {
    case open = "eye", closed = "eye.slash"
}

struct EyeButton: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        Button {
            withAnimation {
                isShowing.toggle()
            }
        } label: {
            Image(systemName: isShowing ? EyeIcon.open.rawValue : EyeIcon.closed.rawValue)
        }
    }
}

struct EyeButton_Previews: PreviewProvider {
    @State static var isShowing: Bool = false
    static var previews: some View {
        EyeButton(isShowing: $isShowing)
    }
}
