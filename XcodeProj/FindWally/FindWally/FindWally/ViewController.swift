//
//  ViewController.swift
//  FindWally
//
//  Created by Moon on 2018/10/18.
//  Copyright © 2018 Moon. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let mlmodel = Wally1000()
    
    var inputImage: CIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "Wally3") else { return }
        
        imageView.image = image
    }
    
    private func showAlert() {
        
        let alertController = UIAlertController(title: "這張圖裡面沒有威利", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    private func clearRecognizedView() {
        
        for subview in imageView.subviews {
            subview.removeFromSuperview()
        }
    }
    
   private func drawRect(_ observations:[VNRecognizedObjectObservation]) {
        
        let widthInPixels = self.imageView.frame.width
        let heightInPixels = self.imageView.frame.height
        
        for observation in observations {
            
            let normalizedX = observation.boundingBox.origin.x
            let normalizedY = observation.boundingBox.origin.y
            let normalizedWidth = observation.boundingBox.size.width
            let normalizedHeight = observation.boundingBox.size.height
            
            let convertedX = normalizedX
            let convertedY = 1.0 - normalizedY - normalizedHeight
            let convertedWidth = normalizedWidth
            let convertedHeight = normalizedHeight
            
            let realX = convertedX * widthInPixels
            let realY = convertedY * heightInPixels
            let realWidth = convertedWidth * widthInPixels
            let realHeight = convertedHeight * heightInPixels
            
            let recognizedRect = CGRect(x: realX, y: realY, width: realWidth, height: realHeight)
            
            let reccognizedView = UIView(frame: recognizedRect)
            
            reccognizedView.backgroundColor = .yellow
            reccognizedView.alpha = 0.7
            
            self.imageView.addSubview(reccognizedView)
        }
    }
    
    private func recognizing() {
        
        clearRecognizedView()
        
        print("Start Recognizing")
        
        guard
            let image = imageView.image,
            let ciImage = CIImage(image: image),
            // You can find dected object labels from line 90
            let userDefined: [String: String] = mlmodel.model.modelDescription.metadata[MLModelMetadataKey.creatorDefinedKey] as? [String : String]
            else { return }

        
        _ = userDefined["classes"]!.components(separatedBy: ",")
        
        // you can set threshold if you don't want to show the low confidence result
//        let nmsThreshold = Float(userDefined["non_maximum_suppression_threshold"]!) ?? 0.5
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        guard let model = try? VNCoreMLModel(for: mlmodel.model) else { return }
        
        let vnRequest: VNCoreMLRequest = VNCoreMLRequest(model: model) { [weak self] (request, error) in
            
            guard let observations = request.results as? [VNRecognizedObjectObservation] else {
                
                print("Observations is nil")
                return
            }
            
            if observations.count == 0 {
                
                DispatchQueue.main.async {
                    self?.showAlert()
                    return
                }
            }
            
            DispatchQueue.main.async {
                self?.drawRect(observations)
            }
        }
        
        vnRequest.imageCropAndScaleOption = .scaleFill
        
        do {
            try handler.perform([vnRequest])
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func startRecognizing(_ sender: Any) {
        
        recognizing()
        
    }
    
    @IBAction func fromDeviceButtonTapped(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func fromGalleryButtonTapped(_ sender: Any) {
        
        guard let galleryVC = storyboard?.instantiateViewController(withIdentifier: "GalleryViewController") as? GalleryViewController else { return }
        
        galleryVC.delegate = self
        self.navigationController?.pushViewController(galleryVC, animated: true)
    }
    
}

extension ViewController: GalleryVCDelegate {
    
    func visionRequest(_ name: String) {
        
        guard let image = UIImage(named: name) else { return }
        imageView.image = image
        clearRecognizedView()
    }
    
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated:true, completion: nil)
        
    }
    
}
