//
//  ImageDetailViewModel.swift
//  GoodOnes
//
//  Created by Lucas Paim on 22/08/22.
//

import Foundation
import Combine
import UIKit

protocol ImageDetailViewModeling: ObservableObject {
    var meta: [ImageDetailMeta] { get }
    var state: ImageDetailState { get }
    var isShowingMeta: Bool { get set }
    
    func load()
    func classify()
    func copyPhotoIdToPasteboard()
    func savePhotoWithDraw(canvasImage: UIImage)
}

final class ImageDetailViewModel: ImageDetailViewModeling {
    @Published var meta: [ImageDetailMeta] = []
    @Published var state: ImageDetailState = .loading
    @Published var isShowingMeta: Bool = false
    
    typealias ImageLoader = () -> AnyPublisher<UIImage, ImageLoadError>
    
    private var cancellables = Set<AnyCancellable>()
    
    private var loadFullImage: ImageLoader
    
    private var classifyImageUseCase: ImageClassificationUseCase
    private var saveImageUseCase: SaveImageUseCase
    
    private var isPredicting: Bool = false
    private var hasSucessDonePrediction: Bool = false
    private let photoId: String
    private var pasteboard: Pasteboard
    
    init(
        loadFullImage: @escaping ImageLoader,
        meta: [ImageDetailMeta],
        photoId: String,
        classifyImageUseCase: ImageClassificationUseCase = VisionImageClassificationUseCaseImpl(),
        pasteboard: Pasteboard = UIPasteboard.general,
        saveImageUseCase: SaveImageUseCase = SaveImageUseCaseImpl()
    ) {
        self.loadFullImage = loadFullImage
        self.classifyImageUseCase = classifyImageUseCase
        self.photoId = photoId
        self.meta = meta
        self.pasteboard = pasteboard
        self.saveImageUseCase = saveImageUseCase
    }
    
    func load() {
        state = .loading
        loadFullImage()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                if case .failure(ImageLoadError.cantLoadImage) = $0 {
                    self.state = .error
                }
            }, receiveValue: {
                self.state = .idle($0)
            })
            .store(in: &cancellables)
    }
    
    func classify() {
        guard !isPredicting, !hasSucessDonePrediction else { return }
        guard case .idle(let image) = state else {
            return
        }
        
        self.isPredicting = true
        classifyImageUseCase
            .predict(image)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: {
                self.isPredicting = false
                guard case .failure(let error) = $0 else {
                    self.hasSucessDonePrediction = true
                    self.isShowingMeta = true
                    return
                }
                self.state = .error
                debugPrint(error)
            }, receiveValue: { predictions in
                self.meta.append(contentsOf: predictions.map { .init(title: $0.label, description: $0.confidence) })
            })
            .store(in: &cancellables)
    }
    
    func copyPhotoIdToPasteboard() {
        pasteboard.string = photoId
    }
    
    func savePhotoWithDraw(canvasImage: UIImage) {
        guard case .idle(let image) = state else {
            return
        }
        let mergedImage = saveImageUseCase.merge(canvasImage: canvasImage, image: image)
        saveImageUseCase.save(image: mergedImage)
    }
}

protocol Pasteboard {
    var string: String? { get set }
}

extension UIPasteboard : Pasteboard { }
