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
    func photoDetailDestination(
        loader: @escaping ImageDetailViewModel.ImageLoader,
        meta: [ImageDetailMeta],
        photoId: String
    ) -> AnyView
    func close()
}

protocol GridViewModeling : ObservableObject {
    var state: GridViewState { get }
    var photos: [PhotoCell.Model] { get }
    
    var isShowing: Bool { get set }
    var selectedDate: Date { get set }
    
    func photoDetailDestination(at index: Int) -> AnyView
    
    func nextPage()
    
    func close()
}


final class CameraRollGridViewModel: GridViewModeling {
    
    @Published var selectedDate: Date = .now
    @Published var isShowing: Bool = false
 
    @Published var photos = [PhotoCell.Model]()
    @Published var isFetching: Bool = false
    @Published var state: GridViewState = .loading
    
    private unowned let coordinator: GridViewCoordinable
    private let fetchAssetsUseCase: FetchCameraAssetsUseCase
    private let fetchAssetImageUseCase: FetchCameraAssetImageUseCase
    
    private var assets = [PHAsset]()
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
    
    func photoDetailDestination(at index: Int) -> AnyView {
        return coordinator.photoDetailDestination(loader: {
            return self.fetchAssetImageUseCase.fetchImage(
                .init(
                    asset: self.assets[index],
                    targetSize: UIScreen.main.bounds.size,
                    imageType: .full
                )
            )
        }, meta: [
            .init(title: "Creation Date", description: self.assets[index].creationDate?.fullDate ?? "-"),
            .init(title: "Modify Date", description: self.assets[index].modificationDate?.fullDate ?? "-")
        ], photoId: self.assets[index].localIdentifier)
    }
    
    func nextPage() {
        guard !isFetching,
              // this is a dump logic to not duplicate the last photo, in production some best logic is necessary
              let dateFromLastImage = assets.last?.creationDate?.adjust(second: -1)
        else { return }
        self.isFetching = true
        
        self.fetchAssetsUseCase.fetchCameraPhotos(.init(type: .image, date: dateFromLastImage))
            .eraseToAnyPublisher()
            .flatMap { self.loadThumbnails(from: $0) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in
                self.isFetching = false
            }, receiveValue: { images in
                self.photos.append(contentsOf: images.map { .init(image: $0.0) })
                self.assets.append(contentsOf: images.map { $0.1 })
            }).store(in: &cancellables)
    }
}

fileprivate extension CameraRollGridViewModel {
    
    func loadThumbnails(from assets: [PHAsset]) -> AnyPublisher<[(UIImage, PHAsset)], ImageLoadError> {
        let requests = assets.map { asset in
            self.fetchAssetImageUseCase.fetchImage(
                .init(asset: asset, targetSize: .init(width: 120, height: 120), imageType: .thumbnail)
            )
                .flatMap { Just(($0, asset)) }
                .eraseToAnyPublisher()
        }
        return Publishers.ZipMany(requests).eraseToAnyPublisher()
    }
    
    func observeDateAndFetchAssets() {
        $selectedDate
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { _ in
                self.isFetching = true
                self.isShowing = false
                self.state = .loading
            })
            .flatMap { value in
                self.fetchAssetsUseCase.fetchCameraPhotos(.init(type: .image, date: value))
            }
            .flatMap {
                self.loadThumbnails(from: $0)
            }
            .delay(for: 2, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in
            }, receiveValue: { images in
                self.photos = images.map { .init(image: $0.0) }
                self.assets = images.map { $0.1 }
                self.state = .idle
                self.isFetching = false
            })
            .store(in: &cancellables)
    }
}

