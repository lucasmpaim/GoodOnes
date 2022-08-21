//
//  TutorialScreen.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import SwiftUI




struct TutorialScreen<VM: TutorialScreenViewModeling>: View {

    @ObservedObject var viewModel: VM
    @State var selectionPage: Int = .zero
    
    var body: some View {
        ZStack {
            
            Color.cyan
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $selectionPage) {
                    ForEach(Array(viewModel.content.enumerated()), id: \.offset) {
                        tutorialPage(model: $0.element)
                            .tag($0.offset)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                finishButton()
            }
        }
    }
    
    @ViewBuilder
    func finishButton() -> some View {
        let isLastPage = selectionPage == viewModel.content.count - 1
        
        Button {
            isLastPage ? viewModel.didFinishTutorial() : viewModel.didSkipTutorial()
        } label: {
            Text( isLastPage ? "Enter on App" : "Skip Tutorial")
        }.buttonStyle(DefaultButtonStyle())
            .padding()
    }
    
    @ViewBuilder
    fileprivate func tutorialPage(model: TutorialScreenModel) -> some View {
        GeometryReader { proxy in
            let animationWidth = proxy.frame(in: .local).width * 0.8
            VStack(alignment:.center) {
                LottieView(animation: model.animation)
                    .frame(maxWidth: animationWidth)
                    .aspectRatio(contentMode: .fit)
                Text(model.title)
                    .padding()
                    .font(.title.bold())
                Text(model.description)
            }.padding()
                .foregroundColor(.black)
        }
    }
}

#if DEBUG
struct TutorialScreen_Previews: PreviewProvider {
    final class FakeViewModel: TutorialScreenViewModeling {
        func didFinishTutorial() { }
        
        func didSkipTutorial() { }
        
        var content: [TutorialScreenModel] = TutorialContentProvider().content
    }
    static var previews: some View {
        TutorialScreen(viewModel: FakeViewModel())
    }
}
#endif
