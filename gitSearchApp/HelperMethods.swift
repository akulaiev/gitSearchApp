//
//  HelperMethods.swift
//  CocktailDB
//
//  Created by Anna Kulaieva on 06.09.2020.
//  Copyright © 2020 Anna Kulaieva. All rights reserved.
//

import Foundation
import UIKit

class HelperMethods {
    
    class func showFailureAlert(title: String, message: String, controller: UIViewController?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let controller = controller {
            controller.present(alertVC, animated: true)
        }
        else {
            let viewController = UIApplication.shared.windows.first!.rootViewController as! SearchViewController
            viewController.present(alertVC, animated: true)
        }
    }
    
    class func resizeImage(originalImage: UIImage, resizeRatio: CGFloat) -> UIImage? {
        let size = originalImage.size
        var newSize: CGSize
        newSize = CGSize.init(width: size.width * resizeRatio, height: size.height * resizeRatio)
        let rect = CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        originalImage.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
