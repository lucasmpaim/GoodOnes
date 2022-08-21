//
//  TutorialViewModel.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation

protocol TutorialCoordinable {
    func didFinishTutorial()
}

protocol TutorialScreenViewModeling : ObservableObject {
    func didFinishTutorial()
    func didSkipTutorial()
    var content: [TutorialScreenModel] { get }
}

final class TutorialViewModel : TutorialScreenViewModeling {
    
    private let coordinator: TutorialCoordinable
    private let tutorialContentRepository: TutorialContentProvidable
    private var appState: GeneralStateStorage
    
    @Published var content: [TutorialScreenModel]
    
    internal init(
        coordinator: TutorialCoordinable,
        tutorialContentRepository: TutorialContentProvidable = TutorialContentProvider(),
        appState: GeneralStateStorage = GeneralStateRepository()
    ) {
        self.coordinator = coordinator
        self.tutorialContentRepository = tutorialContentRepository
        self.appState = appState
        self.content = tutorialContentRepository.content
    }
    
    func didFinishTutorial() {
        //analytics?
        finishTutorial()
    }
    
    func didSkipTutorial() {
        //analytics?
        finishTutorial()
    }
    
    fileprivate func finishTutorial() {
        appState[.tutorialIsDone] = true
        coordinator.didFinishTutorial()
    }

}
