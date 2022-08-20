//
//  CornerRadius+SpecificCorners.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .zero
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct RoundedCornerModifier: ViewModifier {

    var radius: CGFloat = .zero
    var corners: UIRectCorner = .allCorners

    func body(content: Content) -> some View {
        content
            .clipShape(
                RoundedCorner(radius: radius, corners: corners)
            )
    }
    
}

extension View {
    func cornerRadius( _ radius: CGFloat = .zero, corners: UIRectCorner = .allCorners) -> some View {
        modifier(RoundedCornerModifier(radius: radius, corners: corners))
    }
}

struct CornerRadius_SpecificCorners_Previews: PreviewProvider {
    static var previews: some View {
        Color.red
            .cornerRadius(10, corners: [.topLeft, .bottomRight])
            .ignoresSafeArea(.all)
    }
}
