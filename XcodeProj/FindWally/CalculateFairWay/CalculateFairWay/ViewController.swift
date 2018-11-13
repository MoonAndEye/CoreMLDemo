//
//  ViewController.swift
//  CalculateFairWay
//
//  Created by Moon on 2018/10/21.
//  Copyright © 2018 Moon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var saturationBar: UISlider!
    
    @IBOutlet weak var contrastBar: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testImage = UIImage(named: "Test1")
        
        imageView.image = testImage
        
    }
    
    func applyFilter(_ saturationValue: Double, _ contrastValue: Double) {
        
        let image = UIImage(named: "Test1")
        let ciImage = CIImage(image: image!)
        let blackAndWhiteImage = ciImage!.applyingFilter("CIColorControls", parameters: ["inputSaturation": saturationValue, "inputContrast": contrastValue])
        
        imageView.image = UIImage(ciImage: blackAndWhiteImage)
        
    }
    

    @IBAction func saturateValueChange(_ sender: Any) {
        
        applyFilter(Double(saturationBar!.value), Double(contrastBar!.value))
        
    }
    
    @IBAction func contrastValueChange(_ sender: Any) {
        applyFilter(Double(saturationBar!.value), Double(contrastBar!.value))
    }
    
    
}



extension UIImage {
    func applying(contrast value: NSNumber) -> UIImage? {
        guard
            let ciImage = CIImage(image: self)?.applyingFilter("CIColorControls", parameters: [kCIInputContrastKey: value])
            else { return nil } // Swift 3 uses withInputParameters instead of parameters
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        UIImage(ciImage: ciImage).draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
