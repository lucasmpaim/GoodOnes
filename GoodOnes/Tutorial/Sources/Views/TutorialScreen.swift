//
//  TutorialScreen.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import SwiftUI


protocol TutorialCoordinable {
    func didFinishTutorial()
}

struct TutorialScreen: View {
    
    let coordinator: TutorialCoordinable
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#if DEBUG
struct TutorialScreen_Previews: PreviewProvider {
    struct FakeCoordinator: TutorialCoordinable {
        func didFinishTutorial() { }
    }
    static var previews: some View {
        TutorialScreen(coordinator: FakeCoordinator())
    }
}
#endif
