//
//  GoodOnesApp.swift
//  GoodOnes
//
//  Created by Lucas Paim on 18/08/22.
//

import SwiftUI

@main
struct GoodOnesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                GridView(photos: (0...99).map {
                    PhotoCell.Model(
                        id: $0,
                        image: UIImage(named: "grid-image-1")!.pngData()!,
                        name: "A dog \($0)!"
                    )
                }, coordinator: FakeCoordinator())
            }
        }
    }
}

struct FakeCoordinator: GridViewCoordinable {
    func didSelectPhoto(id: Int) -> AnyView {
        return AnyView(EmptyView())
    }
}
