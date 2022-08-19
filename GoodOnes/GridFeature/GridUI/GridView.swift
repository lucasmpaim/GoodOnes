//
//  GridView.swift
//  GoodOnes
//
//  Created by Lucas Paim on 18/08/22.
//

import SwiftUI
import Popovers

struct GridView: View {
    
    @State var photos: [PhotoCell.Model]
    
    @State var isShowing: Bool = false
    @State var selectedDate = Date()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: makeColumns()) {
                    ForEach(photos, id: \.self) { photo in
                        PhotoCell(model: photo)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            .navigationTitle("Doggos")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button {
                        isShowing = true
                    } label: {
                        VStack {
                            Text("It's me!")
                            Image(systemName: "chevron.down")
                                .rotationEffect(.degrees( isShowing ? 180 : 0))
                                .animation(isShowing ? Animation.linear(duration: 0.3) : .none)
                        }
                    }
                    .popover(
                        present: $isShowing,
                        attributes: {
                            $0.sourceFrameInset.top = -8
                            $0.position = .absolute(
                                                originAnchor: .bottom,
                                                popoverAnchor: .top
                                            )
                        }
                    ) {
                        Templates.Container(
                            arrowSide: .top(.centered),
                            backgroundColor: .white
                        ) {
                            DatePicker(selection: $selectedDate, in: ...Date()) {
                                Text("Select Date")
                            }.datePickerStyle(.graphical)
                                .frame(maxHeight: 400)

                        }
                    }
                }
            }
        }
        .foregroundColor(.black)
    }
    
    fileprivate func makeColumns() -> [GridItem] {
        [
            .init(.adaptive(minimum: 150, maximum: 300))
        ]
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(photos: [
            PhotoCell.Model(
                id: 1,
                image: UIImage(named: "grid-image-1")!.pngData()!,
                name: "A dog 1!"
            ),
            PhotoCell.Model(
                id: 2,
                image: UIImage(named: "grid-image-1")!.pngData()!,
                name: "A dog 2!"
            ),
            PhotoCell.Model(
                id: 3,
                image: UIImage(named: "grid-image-1")!.pngData()!,
                name: "A dog 3!"
            ),
            PhotoCell.Model(
                id: 4,
                image: UIImage(named: "grid-image-1")!.pngData()!,
                name: "A dog 4!"
            ),
            PhotoCell.Model(
                id: 5,
                image: UIImage(named: "grid-image-1")!.pngData()!,
                name: "A dog 5!"
            ),
            PhotoCell.Model(
                id: 6,
                image: UIImage(named: "grid-image-1")!.pngData()!,
                name: "A dog 6!"
            )
        ])
        .previewInterfaceOrientation(.portrait)
    }
}
