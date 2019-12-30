//
//  UIImage+FirebaseImage.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 30/12/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit
import AlamofireImage
import Firebase

extension UIImageView {
    func setStorageImage(from urlString: String?, placeholder: UIImage?) {
        if let urlString = urlString {
            StorageManager.shared.getDownloadUrl(for: urlString) { [weak self] url in
                if let url = url {
                    self?.af_setImage(withURL: url, placeholderImage: placeholder)
                } else {
                    self?.image = placeholder
                }
            }
        } else {
            self.image = placeholder
        }
    }
}
