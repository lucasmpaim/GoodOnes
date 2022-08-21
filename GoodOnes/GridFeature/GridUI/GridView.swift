//
//  GridView.swift
//  GoodOnes
//
//  Created by Lucas Paim on 18/08/22.
//

import SwiftUI
import Popovers


enum GridViewState {
    case loading, error, idle
}

struct GridView<VM: GridViewModeling>: View {
    
    @State var isShowing: Bool = false
    @State var selectedDate = Date()
    @State private var selection: String? = nil
    
    @ObservedObject var viewModel: VM
    
    @State var screenTitle: String = ""
    
    var body: some View {
        switch viewModel.state {
        case .loading: LoadingView()
        case .error: ErrorScreen()
        case .idle: idle()
        }
    }
    
    fileprivate func makeColumns() -> [GridItem] {
        return Array(repeating: GridItem(.flexible()), count: 3)
    }
}

fileprivate extension GridView {
    @ViewBuilder
    func idle() -> some View {
        ScrollView {
            LazyVGrid(columns: makeColumns()) {
                ForEach(Array(viewModel.photos.enumerated()), id: \.offset) {
                    let cell = PhotoCell(model: $0.element)
                        .frame(width: 80, alignment: .center)
                        .aspectRatio(1, contentMode: .fill)
                        .clipped()
                    NavigationLink(destination: viewModel.photoDetailDestination(at: $0.offset)) {
                        cell
                    }
                }
            }.padding()
        }
        .navigationTitle(screenTitle)
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
                        arrowSide: .top(.centered)
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.viewModel.close()
                } label: {
                    Image(systemName: "arrow.backward.square")
                        .rotationEffect(.degrees(180))
                }
            }
        }
    }
}

#if DEBUG
struct GridView_Previews: PreviewProvider {
    
    final class FakeViewModel: GridViewModeling {
        var state: GridViewState = .idle
        @Published var photos: [PhotoCell.Model] = (0...99).map {
            PhotoCell.Model(
                id: $0,
                image: UIImage(named: "grid-image-1")!,
                name: "A dog \($0)!"
            )
        }
        
        func close() {
            
        }
        
        func photoDetailDestination(at index: Int) -> AnyView {
            return AnyView { EmptyView() }
        }
    }
    
    static var previews: some View {
        NavigationView {
            GridView(viewModel: FakeViewModel())
            .previewInterfaceOrientation(.portrait)
        }
    }
}
#endif
