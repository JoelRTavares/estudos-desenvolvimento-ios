//
//  ImageUtils.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 26/06/25.
//

import Foundation
import UIKit

class ImageUtils {
    static func loadImage(from url: URL, into imageView: UIImageView) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    imageView.image = UIImage(systemName: DetailsConst.Img.defaultImgNotFound)
                }
                return
            }
            
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}
