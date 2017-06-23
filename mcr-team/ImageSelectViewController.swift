//
//  ImageSelectViewController.swift
//  mcr-team
//
//  Created by LIKIT on 2/4/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//
import ImagePicker
import UIKit

class ImageSelectViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , ImagePickerDelegate {

    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! ImageCollectionViewCell
        
        cell.image = images[indexPath.row]
        
        return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding =  10.0
        let collectionViewSize : Double = Double(collectionView.frame.size.width) - padding
        
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
        
    }
    
    
    //    func collectionView(collectionView: UICollectionView!,
    //                                 cellForItemAtIndexPath indexPath: IndexPath!) ->
    //        UICollectionViewCell! {
    //
    //            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell",
    //            forIndexPath: indexPath)
    //
    //            // Configure the cell
    //            //let image = UIImage(named: carImages[indexPath.row])
    //            cell.imageView.image = image
    //
    //            return cell
    //    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func btnUpload_TouchUpInside(_ sender: Any) {
        
        let imagePicker = ImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        self.images = images
        
        collectionView.reloadData()
        
        
        
    }
    
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    }
    
}


extension ImageSelectViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let totalwidth = collectionView.bounds.size.width;
        let numberOfCellsPerRow = 2
        let oddEven = indexPath.row / numberOfCellsPerRow % 2
        let dimensions = CGFloat(Int(totalwidth) / numberOfCellsPerRow)
        if (oddEven == 0) {
            return CGSize(width : dimensions, height : dimensions)
        } else {
            return CGSize(width : dimensions, height : dimensions / 2)
        }
    }
}

