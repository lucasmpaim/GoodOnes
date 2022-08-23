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
    func selectGPhotos()
}

final class WelcomeViewModel: WelcomeViewModeling {
    @Published var state: WelcomeViewState = .idle
 
    private let galleryPermissionUseCase: GalleryPermissionUseCase
    private let gPhotosPermissionUseCase: GPhotosPermissionUseCase
    let coorditor: WelcomeViewCoordinable
    
    private var cancellables = Set<AnyCancellable>()

    init(
        galleryPermissionUseCase: GalleryPermissionUseCase = GalleryPermissionUseCaseImpl(),
        gPhotosPermissionUseCase: GPhotosPermissionUseCase = GPhotosPermissionUseCaseImpl(),
        coorditor: WelcomeViewCoordinable
    ) {
        self.galleryPermissionUseCase = galleryPermissionUseCase
        self.gPhotosPermissionUseCase = gPhotosPermissionUseCase
        self.coorditor = coorditor
    }
    
    func selectGallery() {
        galleryPermissionUseCase
            .askPermission()
            .sink(receiveCompletion: { [weak self] status in
                guard case .failure(let error) = status else {
                    self?.coorditor.selectGallery()
                    return
                }
                
                self?.state = .error(error == .denied ? "We can't to anything without the permission 😔" : nil)
            }, receiveValue: { })
            .store(in: &cancellables)
    }
    
    func selectGPhotos() {
        gPhotosPermissionUseCase
            .askPermission()
            .sink(receiveCompletion: { [weak self] status in
                guard case .failure(let error) = status else {
                    self?.coorditor.selectGPhotos()
                    return
                }
                
                self?.state = .error(error == .denied ? "We can't to anything without the permission 😔" : nil)
            }, receiveValue: { })
            .store(in: &cancellables)
    }
    
    func closeError() {
        state = .idle
    }

}
