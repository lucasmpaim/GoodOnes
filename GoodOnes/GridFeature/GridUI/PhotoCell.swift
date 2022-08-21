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
            .overlay(NameLabel(), alignment: .bottom)
    }
    
    @ViewBuilder
    func NameLabel() -> some View {
        Text(model.name)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
            .background(Color.black)
            .opacity(0.8)
    }
}


extension PhotoCell {
    struct Model : Identifiable, Hashable {
        let id: Int
        let image: UIImage
        let name: String
    }
}


struct PhotoCell_Previews: PreviewProvider {
    static var previewImage = PhotoCell.Model(
        id: 1,
        image: UIImage(named: "grid-image-1")!,
        name: "A dog!"
    )
    static var previews: some View {
        PhotoCell(model: previewImage)
    }
}
