//
//  GPhotosViewModel.swift
//  GoodOnes
//
//  Created by Lucas Paim on 22/08/22.
//

import Foundation
import SwiftUI
import Combine
import GPhotos

final class GPhotosViewModel: GridViewModeling {
    
    @Published var state: GridViewState = .loading
    @Published var photos: [PhotoCell.Model] = []
    @Published var isShowing: Bool = false
    @Published var selectedDate: Date = .now
    
    private var isFetching: Bool = false
    private var mediaItems: [MediaItem] = []
    
    private let coordinator: GridViewCoordinable
    private let fetchGPhotosUseCase: GPhotosImageSearchUseCase
    private let api = GPhotosApi.mediaItems
    private var cancellables = Set<AnyCancellable>()
    private let urlSession: URLSession
    init(
        coordinator: GridViewCoordinable,
        fetchGPhotosUseCase: GPhotosImageSearchUseCase = GPhotosImageSearchUseCaseImpl(),
        session: URLSession = .shared
    ) {
        self.coordinator = coordinator
        self.fetchGPhotosUseCase = fetchGPhotosUseCase
        self.urlSession = session
        observeDate()
    }
    
    func photoDetailDestination(at index: Int) -> AnyView {
        return coordinator.photoDetailDestination(loader: {
            return Just<UIImage>(self.photos[index].image)
                .setFailureType(to: ImageLoadError.self)
                .eraseToAnyPublisher()
        }, meta: [
            .init(title: "Creation Date", description: self.mediaItems[index].mediaMetadata?.creationTime?.uiFormat ?? "-"),
            .init(title: "Camera Model", description: self.mediaItems[index].mediaMetadata?.photo?.cameraModel ?? "-")
        ], photoId: self.mediaItems[index].id)
    }
    
    func nextPage() {
        guard !isFetching else { return }
        self.isFetching = true
        
        self.fetchGPhotosUseCase.search(request: .init(date: selectedDate, page: .next))
            .eraseToAnyPublisher()
            .flatMap { self.loadThumbnails(from: $0) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in
                self.isFetching = false
            }, receiveValue: { images in
                self.photos.append(contentsOf: images.map { .init(image: $0.0) })
                self.mediaItems.append(contentsOf: images.map { $0.1 })
            }).store(in: &cancellables)
    }
    
    func close() {
        coordinator.close()
    }
    
}

extension GPhotosViewModel {
    func observeDate() {
        $selectedDate
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { _ in
                self.isFetching = true
                self.isShowing = false
                self.state = .loading
            })
            .flatMap {
                self.fetchGPhotosUseCase.search(request: .init(date: $0, page: .reload))
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
                self.mediaItems = images.map { $0.1 }
                self.state = .idle
                self.isFetching = false
            })
            .store(in: &cancellables)
    }
}

extension GPhotosViewModel {
    func loadThumbnails(from assets: [MediaItem]) -> AnyPublisher<[(UIImage, MediaItem)], URLError> {
        let requests = assets.compactMap { asset -> AnyPublisher<(UIImage, MediaItem), URLError>? in
            guard let url = asset.baseUrl else { return nil }
            return urlSession.dataTaskPublisher(for: url)
                .map { (UIImage(data: $0.data) ?? UIImage(), asset) }
                .eraseToAnyPublisher()
        }
        return Publishers.ZipMany(requests).eraseToAnyPublisher()
    }
}
