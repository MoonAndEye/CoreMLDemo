//
//  GalleryViewController.swift
//  FindWally
//
//  Created by Moon on 2018/10/18.
//  Copyright © 2018 Moon. All rights reserved.
//

import UIKit

protocol GalleryVCDelegate: class {
    func visionRequest(_ name: String)
}

class GalleryViewController: UIViewController {

    weak var delegate: GalleryVCDelegate?
    
    let cellIdentifier = "WallyCell"
    
    let wallyArray = ["Wally1", "Wally2", "Wally3", "Wally4", "Wally5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return wallyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! WallyCollectionViewCell
        
        let imageName = wallyArray[indexPath.row]
        
        if let image = UIImage(named: imageName) {
            cell.titleLabel.text = imageName
            cell.wallyImageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedName = wallyArray[indexPath.row]
        delegate?.visionRequest(selectedName)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
