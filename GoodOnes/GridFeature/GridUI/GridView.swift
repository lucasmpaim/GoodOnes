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
                ForEach(Array(viewModel.photos.enumerated()), id: \.offset) { (offset, element) in
                    let cell = PhotoCell(model: element)
                        .frame(width: 120, alignment: .center)
                        .aspectRatio(1, contentMode: .fill)
                        .clipped()
                    NavigationLink(destination: viewModel.photoDetailDestination(at: offset)) {
                        cell
                    }.onAppear(perform: {
                        if(Float(offset) >= Float(viewModel.photos.count) * 0.8) {
                            viewModel.nextPage()
                        }
                    })
                    
                }
            }.padding()
        }
        .navigationTitle(screenTitle)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    viewModel.isShowing = true
                } label: {
                    VStack {
                        Text(viewModel.selectedDate.uiFormat ?? "")
                        withAnimation(.easeIn(duration: 0.3)) {
                            Image(systemName: "chevron.down")
                                .rotationEffect(.degrees( viewModel.isShowing ? 180 : 0))
                        }
                    }
                }
                .popover(
                    present: $viewModel.isShowing,
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
                            selection: $viewModel.selectedDate,
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
    
    final class StubViewModel: GridViewModeling {
        
        @Published var selectedDate: Date = .now
        var selectedDateBinding: Binding<Date> {
            Binding(get: { self.selectedDate }, set: { self.selectedDate = $0 })
        }
        
        @Published var isShowing: Bool = false
        var isShowingBinding: Binding<Bool> {
            Binding(get: { self.isShowing }, set: { self.isShowing = $0 })
        }

        var state: GridViewState = .idle
        @Published var photos: [PhotoCell.Model] = (0...99).map { _ in
            PhotoCell.Model(
                image: UIImage(named: "grid-image-1")!
            )
        }
        
        func close() {
            
        }
        
        func nextPage() { }
        
        func photoDetailDestination(at index: Int) -> AnyView {
            return AnyView { EmptyView() }
        }
    }
    
    static var previews: some View {
        NavigationView {
            GridView(viewModel: StubViewModel())
            .previewInterfaceOrientation(.portrait)
        }
    }
}
#endif
