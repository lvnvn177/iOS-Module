//
//  File.swift
//  
//
//  Created by 이영호 on 11/20/24.
//

import Kingfisher
import SwiftUI

struct KFImageManager {
    static func loadImage(url: String?, placeholder: UIImage? = nil) -> some View {
        KFImage(URL(string: url ?? ""))
            .placeholder {
                Image(uiImage: placeholder ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .scaledToFit()
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}
