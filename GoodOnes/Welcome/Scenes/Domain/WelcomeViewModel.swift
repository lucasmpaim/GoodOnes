//
//  WelcomeViewModel.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation
import Combine


enum WelcomeViewState {
    case error(String?)
    case idle
    case loading
}

protocol WelcomeViewModeling: ObservableObject {
    var state: WelcomeViewState { get }
    func selectGallery()
    func selectGPhotos()
    func closeError()
}

protocol WelcomeViewCoordinable {
    func selectGallery()
}

final class WelcomeViewModel: WelcomeViewModeling {
    @Published var state: WelcomeViewState = .idle
 
    private let galleryPermissionUseCase: GalleryPermissionUseCase
    
    let coorditor: WelcomeViewCoordinable
    
    var galleryCancelationToken: AnyCancellable? = nil
    
    init(
        galleryPermissionUseCase: GalleryPermissionUseCase = GalleryPermissionUseCaseImpl(),
        coorditor: WelcomeViewCoordinable
    ) {
        self.galleryPermissionUseCase = galleryPermissionUseCase
        self.coorditor = coorditor
    }
    
    func selectGallery() {
        galleryCancelationToken = galleryPermissionUseCase
            .askPermission()
            .sink(receiveCompletion: { [weak self] status in
                guard case .failure(let error) = status else {
                    self?.coorditor.selectGallery()
                    return
                }
                
                self?.state = .error(error == .denied ? "We can't to anything without the permission 😔" : nil)
            }, receiveValue: { })
            
    }
    
    func selectGPhotos() {
        
    }
    
    func closeError() {
        state = .idle
    }

}
