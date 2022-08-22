//
//  ImageDetail.swift
//  GoodOnes
//
//  Created by Lucas Paim on 21/08/22.
//

import SwiftUI


struct ImageDetailMeta {
    let title: String
    let description: String
}


enum ImageDetailState {
    case loading, idle(UIImage), error
}

protocol ImageDetailViewModeling: ObservableObject {
    var meta: [ImageDetailMeta] { get }
    var state: ImageDetailState { get }
}

struct ImageDetail: View {
    
    @State var isShowingMeta: Bool = false
    @State var meta: [ImageDetailMeta] = []
    
    @State var image: UIImage? = nil
    
    @State var state: ImageDetailState = .loading
    
    //MARK: - Drawing properties
    @State var isDrawing: Bool = true
    @State var lines: [Line] = []

    
    var body: some View {
        switch state {
        case .loading:
            LoadingView()
        case .idle(let uIImage):
            ZStack {
                idle(image: uIImage)
                Drawing(isDrawing: $isDrawing, lines: $lines)
            }
        case .error:
            ErrorScreen()
        }
    }
    
    @ViewBuilder
    fileprivate func idle(image: UIImage) -> some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
            if isShowingMeta {
                VStack {
                    metaView()
                }
            }
        }
        .navigationTitle("Detail")
        .toolbar(content: {
            ToolbarItem(placement: isDrawing ? .navigationBarLeading : .navigationBarTrailing, content: {
                Button {
                    isDrawing.toggle()
                    isShowingMeta = false
                } label: {
                    Image(systemName: isDrawing ? "stop.circle" : "pencil.tip.crop.circle")
                }
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                if !isDrawing {
                    EyeButton(isShowing: $isShowingMeta)
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
                    Button { } label: {
                        Image(systemName: "qrcode.viewfinder")
                    }
                }
            })
            ToolbarItem(placement: .navigationBarLeading, content: {
                if !isDrawing {
                    Button { } label: {
                        Image(systemName: "doc.text.image.fill")
                    }
                }
            })
        })
    }
    
    @ViewBuilder
    fileprivate func metaView() -> some View {
        Spacer()
            .background(Color.clear)
        ScrollView {
            VStack(spacing: 15) {
                ForEach(Array(meta.enumerated()), id: \.offset) { (offset, element) in
                    HStack(alignment: .top) {
                        let needTopPadding = offset == 0
                        Text(element.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(needTopPadding ? [.top, .leading] : [.leading])
                            .font(Font.body.bold())
                        Text(element.description)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(needTopPadding ? [.top, .trailing] : [.trailing])
                    }
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                }
            }
        }
        .aspectRatio(contentMode: .fit)
        .transition(.slide)
    }
    
}

struct ImageDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImageDetail(meta: [
                .init(title: "Created At", description: Date().fullDate ?? ""),
                .init(title: "Some Title", description: "Some description")
            ],
            state: .idle(UIImage(named: "grid-image-1")!)
            )
        }
    }
}
