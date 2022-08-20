//
//  GridView.swift
//  GoodOnes
//
//  Created by Lucas Paim on 18/08/22.
//

import SwiftUI
import Popovers

protocol GridViewCoordinable {
    func didSelectPhoto(id: Int) -> AnyView
}

protocol GridViewModeling : ObservableObject {
    
}

struct GridView: View {
    
    @State var photos: [PhotoCell.Model]
    @State var isShowing: Bool = false
    @State var selectedDate = Date()
    @State private var selection: String? = nil
    
    let coordinator: GridViewCoordinable
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: makeColumns()) {
                ForEach(photos, id: \.self) { photo in
                    let cell = PhotoCell(model: photo)
                        .aspectRatio(contentMode: .fit)
                    NavigationLink(destination:  coordinator.didSelectPhoto(id: photo.id)) {
                        cell
                    }
                }
            }.padding()
        }
        .navigationTitle("Doggos")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    isShowing.toggle()
                } label: {
                    VStack {
                        Text("It's me!")
                        withAnimation(.easeIn(duration: 0.3)) {
                            Image(systemName: "chevron.down")
                                .rotationEffect(.degrees( isShowing ? 180 : 0))
                        }
                    }
                }
                .popover(
                    present: $isShowing,
                    attributes: {
                        $0.sourceFrameInset.top = 20
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
                        DatePicker(
                            selection: $selectedDate,
                            in: ...Date(),
                            displayedComponents: .date
                        ) {
                            Text("Select Date")
                        }.datePickerStyle(.graphical)
                            .frame(maxHeight: 400)
                        
                    }
                }
            }
        }
        .foregroundColor(.black)
    }
    
    fileprivate func makeColumns() -> [GridItem] {
        return Array(repeating: GridItem(.flexible()), count: 3)
    }
}

#if DEBUG
struct GridView_Previews: PreviewProvider {
    
    struct FakeCoordinator: GridViewCoordinable {
        func didSelectPhoto(id: Int) -> AnyView {
            AnyView(EmptyView())
        }
    }
    
    static var previews: some View {
        NavigationView {
            GridView(photos: (0...99).map {
                PhotoCell.Model(
                    id: $0,
                    image: UIImage(named: "grid-image-1")!.pngData()!,
                    name: "A dog \($0)!"
                )
            }, coordinator: FakeCoordinator())
            .previewInterfaceOrientation(.portrait)
        }
    }
}
#endif
