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



struct ImageDetail: View {
    
    @State var isShowingMeta: Bool = true
    @State var meta: [ImageDetailMeta] = []
    
    @State var image: UIImage? = nil
    @State var isDrawing: Bool = false
    
    @State var state: ImageDetailState = .loading
    
    var body: some View {
        switch state {
        case .loading:
            LoadingView()
        case .idle(let uIImage):
            idle(image: uIImage)
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
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button {
                    isDrawing.toggle()
                    isShowingMeta = false
                } label: {
                    Image(systemName: "pencil.tip.crop.circle")
                }
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                EyeButton(isShowing: $isShowingMeta)
            })
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button { } label: {
                    Image(systemName: "qrcode.viewfinder")
                }
            })
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button { } label: {
                    Image(systemName: "doc.text.image.fill")
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
        .background(Color.white)
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
