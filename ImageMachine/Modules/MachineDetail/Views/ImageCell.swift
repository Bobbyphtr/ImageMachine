//
//  ImageCell.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 01/08/21.
//

import SwiftUI

struct ImageCell: View {
    
    @State var image : UIImage
    @State var index : Int
    
    init(image : UIImage, index : Int) {
        self.image = image
        self.index = index
    }
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 68, height: 68.0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ImageCell_Previews: PreviewProvider {
    static var previews: some View {
        ImageCell(image: UIImage(systemName: "house")!, index: 0)
    }
}
