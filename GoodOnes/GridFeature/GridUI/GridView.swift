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

enum CellSize : Int, CaseIterable {
    case xSmall = 0, small = 1, medium = 2, high = 3
    
    var cellSize: CGFloat {
        switch self {
        case .xSmall:
            return 25
        case .small:
            return 40
        case .medium:
            return 80
        case .high:
            return UIScreen.main.bounds.width * 0.8
        }
    }
}

enum PitchDirection {
    case open, close
}

struct GridView<VM: GridViewModeling>: View {
    
    @State private var selection: String? = nil
    @ObservedObject var viewModel: VM
    @State var screenTitle: String = ""
    
    @State var itemSize: CellSize = .medium
    @State var direction: PitchDirection = .close
    @State var linksEnabled: Bool = true
    
    var body: some View {
        switch viewModel.state {
        case .loading: LoadingView()
        case .error: ErrorScreen()
        case .idle: idle()
        }
    }
    
    fileprivate func makeColumns() -> [GridItem] {
        switch itemSize {
        case .medium:
            return Array(repeating: GridItem(.flexible()), count: 3)
        default:
            return [GridItem(.adaptive(minimum: itemSize.cellSize, maximum: itemSize.cellSize))]
        }
        
    }
    
    func updateCellSize() {
        withAnimation {
            let offset = direction == .close ? -1 : 1
            let maxOffset = CellSize.allCases.map { $0.rawValue }.max()!
            let newValue = min(max(0, itemSize.rawValue + offset), maxOffset)
            self.itemSize = .init(rawValue: newValue) ?? .medium
        }
    }
}

fileprivate extension GridView {
    @ViewBuilder
    func idle() -> some View {
        ScrollView {
            LazyVGrid(columns: makeColumns()) {
                ForEach(Array(viewModel.photos.enumerated()), id: \.offset) { (offset, element) in
                    let cell = PhotoCell(model: element)
                        .frame(width: itemSize.cellSize, alignment: .center)
                        .aspectRatio(1, contentMode: .fill)
                        .clipped()
                        
                    NavigationLink(destination: viewModel.photoDetailDestination(at: offset)) {
                        cell
                    }
                    .onAppear(perform: {
                        if(Float(offset) >= Float(viewModel.photos.count) * 0.8) {
                            viewModel.nextPage()
                        }
                    })
                    .disabled(!linksEnabled)
                    
                    
                }
            }.highPriorityGesture(MagnificationGesture()
                .onChanged({ val in
                    linksEnabled = false
                    direction = val <= 1.3 ? .close : .open
                })
                .onEnded { val in
                    linksEnabled = true
                    self.updateCellSize()
                }
            )
            .padding()
        }
        .delaysTouches(for: 0.3)
        
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
