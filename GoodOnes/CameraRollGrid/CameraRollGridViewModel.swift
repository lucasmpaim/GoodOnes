//
//  CameraRollGridViewModel.swift
//  GoodOnes
//
//  Created by Lucas Paim on 21/08/22.
//

import Foundation
import Combine
import SwiftUI
import Photos


protocol GridViewCoordinable: AnyObject {
    func didSelectPhoto(id: Int) -> AnyView
    func close()
}

protocol GridViewModeling : ObservableObject {
    var state: GridViewState { get }
    var photos: [PhotoCell.Model] { get }
    
    func close()
}


final class CameraRollGridViewModel: GridViewModeling {
    
    @Published var selectDate: Date = .now
    @Published var photos = [PhotoCell.Model]()
    @Published var isFetching: Bool = false
    @Published var state: GridViewState = .loading
    
    private unowned let coordinator: GridViewCoordinable
    private let fetchAssetsUseCase: FetchCameraAssetsUseCase
    private let fetchAssetImageUseCase: FetchCameraAssetImageUseCase
    
    private var assets = [PHAsset]()
    
    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    
    init(
        coordinator: GridViewCoordinable,
        fetchAssetsUseCase: FetchCameraAssetsUseCase = FetchCameraAssetsUseCaseImpl(),
        fetchAssetImageUseCase: FetchCameraAssetImageUseCase = FetchCameraAssetImageUseCaseImpl()
    ) {
        self.coordinator = coordinator
        self.fetchAssetsUseCase = fetchAssetsUseCase
        self.fetchAssetImageUseCase = fetchAssetImageUseCase
        self.observeDateAndFetchAssets()
    }
    
    func close() {
        self.coordinator.close()
    }
}

fileprivate extension CameraRollGridViewModel {
    func observeDateAndFetchAssets() {
        $selectDate
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .handleEvents(receiveOutput: { _ in
                self.isFetching = true
                self.state = .loading
            })
            .flatMap { value in
                self.fetchAssetsUseCase.fetchCameraPhotos(.init(type: .image, date: value))
            }
            .flatMap { assets -> AnyPublisher<[(UIImage, PHAsset)], ImageLoadError> in
                let requests = assets.map { asset in
                    self.fetchAssetImageUseCase.fetchImage(.init(asset: asset, targetSize: .init(width: 120, height: 120)))
                        .flatMap { Just(($0, asset)) }
                        .eraseToAnyPublisher()
                }
                return Publishers.ZipMany(requests).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in
                self.isFetching = false
            }, receiveValue: { images in
                self.photos = images.map { .init(id: Int.random(in: 0..<20), image: $0.0, name: "") }
                self.assets = images.map { $0.1 }
                self.state = .idle
            })
            .store(in: &cancellables)
    }
}
