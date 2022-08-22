//
//  ImageDetail.swift
//  GoodOnes
//
//  Created by Lucas Paim on 21/08/22.
//

import SwiftUI
import ToastUI

struct ImageDetailMeta {
    let title: String
    let description: String
}


enum ImageDetailState {
    case loading, idle(UIImage), error
}



struct ImageDetail<VM: ImageDetailViewModeling>: View {
    
    @ObservedObject var viewModel: VM
    
    @State var showingCopyToast: Bool = false
    
    //MARK: - Drawing properties
    @State var isDrawing: Bool = false
    @State var lines: [Line] = []
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                LoadingView()
            case .idle(let uIImage):
                ZStack {
                    idle(image: uIImage)
                    Drawing(isDrawing: $isDrawing, lines: $lines)
                }
            case .error:
                ErrorScreen(
                    showRetry: true,
                    retryAction: {
                        self.viewModel.load()
                    }
                )
            }
        }.onAppear(perform: {
            viewModel.load()
        })
    }
    
    @ViewBuilder
    fileprivate func idle(image: UIImage) -> some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
            if viewModel.isShowingMeta {
                metaView()
            }
        }
        .navigationTitle("Detail")
        .toolbar(content: {
            ToolbarItem(placement: isDrawing ? .navigationBarLeading : .navigationBarTrailing, content: {
                Button {
                    isDrawing.toggle()
                    viewModel.isShowingMeta = false
                } label: {
                    Image(systemName: isDrawing ? "stop.circle" : "pencil.tip.crop.circle")
                }
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                if !isDrawing {
                    EyeButton(isShowing: $viewModel.isShowingMeta)
                }
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                if isDrawing {
                    Button { } label: {
                        Image(systemName: "square.and.arrow.down.fill")
                    }
                }
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                if isDrawing {
                    Button {
                        lines = lines.dropLast()
                    } label: {
                        Image(systemName: "arrow.uturn.backward.circle")
                    }
                }
            })
            ToolbarItem(placement: .navigationBarLeading, content: {
                if !isDrawing {
                    Button {
                        self.viewModel.classify()
                    } label: {
                        Image(systemName: "doc.text.image.fill")
                    }
                }
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button {
                    self.viewModel.copyPhotoIdToPasteboard()
                    showingCopyToast = true
                } label: {
                    Image(systemName: "doc.on.doc.fill")
                }
            })
        })
        .toast(isPresented: $showingCopyToast, dismissAfter: 2, content: {
            ToastView {
                HStack {
                    Image(systemName: "doc.on.doc")
                    Text("Copied to Clipboard")
                }.padding()
            }
        })
    }
    
    @ViewBuilder
    fileprivate func metaView() -> some View {
        VStack {
            Spacer()
                .background(Color.clear)
            VStack(spacing: 15) {
                ForEach(Array(viewModel.meta.enumerated()), id: \.offset) { (offset, element) in
                    HStack(alignment: .top) {
                        let needTopOffset = offset == .zero
                        Text(element.title)
                            .padding(needTopOffset ? [.top, .leading] : .leading)
                            .frame(alignment: .leading)
                            .font(Font.body.bold())
                        Text(element.description)
                            .padding(needTopOffset ? [.top, .trailing] : .trailing)
                            .frame(alignment: .trailing)
                    }.frame(maxWidth: .infinity)
                }
            }
            .background(Color.white)
            .aspectRatio(contentMode: .fit)
        }
    }
    
}

struct ImageDetail_Previews: PreviewProvider {
    
    final class StubViewModel: ImageDetailViewModeling {
        @Published var isShowingMeta: Bool = false
        @Published var meta: [ImageDetailMeta] = [
            .init(title: "Created At", description: Date().fullDate ?? ""),
            .init(title: "Some Title", description: "Some description")
        ]
        @Published var state: ImageDetailState = .idle(UIImage(named: "grid-image-1")!)
        
        func load() { }
        func classify() { }
        func copyPhotoIdToPasteboard() { }
    }
    
    static var previews: some View {
        NavigationView {
            ImageDetail(viewModel: StubViewModel())
        }
    }
}
