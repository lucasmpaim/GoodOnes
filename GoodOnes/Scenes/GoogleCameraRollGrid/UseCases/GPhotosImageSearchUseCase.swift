//
//  GPhotosImageSearchUseCase.swift
//  GoodOnes
//
//  Created by Lucas Paim on 22/08/22.
//

import Foundation
import GPhotos
import Combine

enum PageType {
    case reload, next
}

struct GPhotosImageSearchRequest {
    let date: Date
    let page: PageType
}

protocol GPhotosImageSearchUseCase {
    func search(request: GPhotosImageSearchRequest) -> AnyPublisher<[MediaItem], Never>
}

final class GPhotosImageSearchUseCaseImpl : GPhotosImageSearchUseCase {
    func search(request: GPhotosImageSearchRequest) -> AnyPublisher<[MediaItem], Never> {
        let filter = self.makeFilter(for: request)
        return request.page == .reload ? reload(filter: filter) : nextPage(filter: filter)
    }
}

fileprivate extension GPhotosImageSearchUseCaseImpl {
    
    func nextPage(filter: Filters) -> AnyPublisher<[MediaItem], Never> {
        return Future { promise in
            GPhotosApi.mediaItems
                .search(with: MediaItemsSearch.Request.init(albumId: nil, filters: filter), completion: { items in
                    promise(.success(items))
                })
        }.eraseToAnyPublisher()
    }
    
    func reload(filter: Filters) -> AnyPublisher<[MediaItem], Never> {
        return Future { promise in
            GPhotosApi.mediaItems
                .reloadSearch(with: MediaItemsSearch.Request.init(albumId: nil, filters: filter), completion: { items in
                    promise(.success(items))
                })
        }.eraseToAnyPublisher()
    }
    
    func makeFilter(for request: GPhotosImageSearchRequest) -> Filters {
        let range = DateFilter.DateRange()
        range.startDate = DateFilter.Date(from: Date(timeIntervalSince1970: .zero))
        range.endDate = DateFilter.Date(from: request.date)
        
        return Filters(
            dateFilter: DateFilter(with: [range]),
            mediaTypeFilter: .init([.photo])
        )
    }
}

extension MediaTypeFilter {
    convenience init(_ mediaTypes: [MediaType]) {
        self.init()
        self.mediaTypes = mediaTypes
    }
}

extension Filters {
    convenience init(dateFilter: DateFilter? = nil, mediaTypeFilter: MediaTypeFilter? = nil) {
        self.init()
        self.mediaTypeFilter = mediaTypeFilter
        self.dateFilter = dateFilter
    }
}
