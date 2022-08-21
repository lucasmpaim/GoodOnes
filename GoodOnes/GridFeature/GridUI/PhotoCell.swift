//
//  PhotoCell.swift
//  GoodOnes
//
//  Created by Lucas Paim on 18/08/22.
//

import SwiftUI

struct PhotoCell: View {
    var model: Model
    var body: some View {
        Image(uiImage: model.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
            .background(
                Color.black
                    .shadow(color: .black, radius: 3, x: 0, y: 5)
                    .blur(radius: 3)
            )
    }

}


extension PhotoCell {
    struct Model {
        let image: UIImage
    }
}


struct PhotoCell_Previews: PreviewProvider {
    static var previewImage = PhotoCell.Model(
        image: UIImage(named: "grid-image-1")!
    )
    static var previews: some View {
        PhotoCell(model: previewImage)
    }
}
