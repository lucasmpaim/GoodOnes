//
//  Drawing.swift
//  GoodOnes
//
//  Created by Lucas Paim on 22/08/22.
//

import SwiftUI

struct Line {
    var points: [CGPoint]  = []
    let color: Color       = .red
    let lineWidth: CGFloat = 2
    
    mutating func addPoint(_ point: CGPoint) {
        points.append(point)
    }
}

struct Drawing: View {

    @Binding var isDrawing: Bool
    @Binding var lines: [Line]
    @State var newShape: Bool = true
    
    var body: some View {
        Canvas { context, size in
            for (offset, line) in lines.enumerated() {
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
            }
        }.gesture(drawGesture())
    }
    
    fileprivate func drawGesture() -> _EndedGesture<_ChangedGesture<DragGesture>> {
        return DragGesture(minimumDistance: .zero)
            .onChanged { value in
                guard isDrawing else { return }
                if newShape {
                    newShape = false
                    lines.append(Line())
                }
                lines[lines.count - 1].addPoint(value.location)
            }
            .onEnded { _ in
                newShape = true
            }
    }
}

struct Drawing_Previews: PreviewProvider {
    @State static var isDrawing = true
    @State static var lines = [Line]()
    static var previews: some View {
        Drawing(isDrawing: $isDrawing, lines: $lines)
    }
}
