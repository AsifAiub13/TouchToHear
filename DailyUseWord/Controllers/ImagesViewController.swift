//
//  ImagesViewController.swift
//  DailyUseWord
//
//  Created by Muhammad Burhan on 10/12/2017.
//  Copyright © 2017 Burhan Mughal. All rights reserved.
//

import UIKit
//import iCarousel
import SwiftOCR
import AVFoundation
//import ZoomImageView

class ImagesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,/*iCarouselDelegate,iCarouselDataSource,*/UIScrollViewDelegate {

    var dummyImageView : UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var imageView : UIImageView!
    var oldOffSet : CGFloat = 0
    @IBOutlet weak var mainScroll: UIScrollView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var btnItemDetails: UIButton!
//    @IBOutlet weak var carousel: iCarousel!
    
    var audioPlayer         = AVAudioPlayer()
    var itemsNameArray      = [String]()
    var showingHalfImages   = false
    var filesArray          = ["Kitchen","Kitchen","Resrtarant","Resrtarant","Super_Market","Super_Market","Boy_Clothing","Boy_Clothing","Girl_clothes","Girl_clothes","Children_Clothes","Children_Clothes","Hotel","Hotel","Bank","Bank","Bank","Bank","Picnic","Picnic","Picnic","Picnic","Food","Food","Time","Time","Sport","Sport","Transportation","Transportation","Animals","Animals","Family","Family"]
    let imagesArray         = ["Kitchen","Resrtarant","Super_Market","Boy_Clothing","Girl_clothes","Children_Clothes","Hotel","Bank","Bank","Picnic","Transport_Station","Health","Health","Time","Sport","Vehicle","Zoo","Family"]
    let halfImagesArray     = ["Kitchen_Left","Kitchen_Right","Resrtarant_Left","Resrtarant_Right","Super_Market_Left","Super_Market_Right","Boy_Clothing_Left","Boy_Clothing_Right","Girl_clothes_Left","Girl_clothes_Right","Children_Clothes_Left","Children_Clothes_Right","Hotel_Left","Hotel_Right","Bank_Left","Bank_Right","Bank_Left","Bank_Right","Picnic_Left","Picnic_Right","Transport_Left","Transport_Right","Health_Left","Health_Right","Health_Left","Health_Right","Time_Left","Time_Right","Sport_Left","Sport_Right","Vehicle_Left","Vehicle_Right","Zoo_Left","Zoo_Right","Family_Left","Family_Right"]
    var dataSource          = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = imagesArray
        
//        self.carousel.reloadData()
//        self.setUpiCarousel()
        self.changeNamesArray(index:0)
    }
    
    func changeNamesArray(index:Int){
        
//        if index == 0{
//
//        }
        return
        if let rtfPath = Bundle.main.url(forResource: filesArray[index], withExtension: "rtf") {
            do {
                //                let string = try String.init(contentsOf: rtfPath)
                let string = try String.init(contentsOf: rtfPath, encoding: .utf8)
                itemsNameArray = string.components(separatedBy: "\n")
                for i in 6...itemsNameArray.count - 2{
                    let item = itemsNameArray[i]
                    itemsNameArray[i] = item.replacingOccurrences(of: "\\", with: "")
                }
            } catch let error {
                print("Got an error \(error)")
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : ImagesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImagesCollectionViewCell
        cell.imageView.image = UIImage.init(named: dataSource[indexPath.row])
        cell.mainScroll.delegate = self
        
        if showingHalfImages{
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageViewHeightConstraint.constant = cell.mainScroll.bounds.height
        }else{
            cell.imageView.contentMode = .redraw
            cell.imageViewHeightConstraint.constant = cell.mainScroll.bounds.height - 200
        }
        
        cell.imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init()
        tap.addTarget(self, action: #selector(showMoreActions(touch:)))
        tap.numberOfTapsRequired = 1
        tap.accessibilityHint = "\(indexPath.row)"
        cell.imageView.tag = 100
        cell.imageView.addGestureRecognizer(tap)
        cell.mainScroll.minimumZoomScale = 1.0
        cell.mainScroll.maximumZoomScale = 3.0
        
        return cell
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if !showingHalfImages{
            return nil
        }
        return scrollView.viewWithTag(100)
    }
    
    @objc func showMoreActions(touch: UITapGestureRecognizer) {
        
        let touchPoint = touch.location(in: touch.view)
        
        if !showingHalfImages{
            self.changeImages(direction: 0)
            return
        }
        
        let indexPath = IndexPath.init(row: Int(touch.accessibilityHint!)!, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as! ImagesCollectionViewCell
        
//        print(cell.mainScroll.zoomScale)
        
        let swiftOCRInstance = SwiftOCR()
        
        if let newImage = cell.imageView.snapshot(of: CGRect.init(x: touchPoint.x-8, y: touchPoint.y-8, width: 30, height: 30)){
            DispatchQueue.main.async() {
                self.dummyImageView   = UIImageView.init(image: newImage)
                self.dummyImageView.contentMode = .scaleAspectFill
                self.dummyImageView.frame = CGRect.init(x: 10, y: 100, width: 30, height: 30)
                self.view.addSubview(self.dummyImageView)
            }
            swiftOCRInstance.recognize(newImage) { recognizedString in
                print(recognizedString)
                if recognizedString.characters.count > 0{
                    if recognizedString.isNumeric{
                        var name = recognizedString
                        if recognizedString.contains("O"){
                          name = recognizedString.replacingOccurrences(of: "O", with: "0")
                        }
                        if name.contains("I"){
                            name = recognizedString.replacingOccurrences(of: "I", with: "1")
                        }
                        self.playAudio(name: name)
                        DispatchQueue.main.async() {
                            self.showItemNameInfo(index: Int(name)!)
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func playAudio(name:String){
        if let path = Bundle.main.path(forResource: name, ofType: "mp3"){
            let alertSound = URL(fileURLWithPath: path)
            print(alertSound)
            
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try! AVAudioSession.sharedInstance().setActive(true)
            
            try! audioPlayer = AVAudioPlayer(contentsOf: alertSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }

    func showItemNameInfo(index:Int){
        if index + 6 > itemsNameArray.count{
            return
        }
        
        self.btnItemDetails.setTitle("\(index) : \(itemsNameArray[index + 6])", for: .normal)
        self.btnItemDetails.isHidden = false
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(showDetails), userInfo: nil, repeats: false)
    }
    
    @objc func showDetails(){
        self.btnItemDetails.isHidden = true
    }
    
    @IBAction func changeDataSource(_ sender: UIButton) {
        self.changeImages(direction: sender.tag)
    }
    
    func changeImages(direction:Int){
        rightButton.isUserInteractionEnabled = false
        leftButton.isUserInteractionEnabled = false
        dataSource = halfImagesArray
        showingHalfImages = !showingHalfImages
        self.collectionView.reloadData()
        if direction == 0{
            
        }else{
            
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.collectionView.indexPathsForVisibleItems.count == 1{
            return
        }
        adjustCollectionViewCells(scrollView: scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.collectionView.indexPathsForVisibleItems.count == 1{
            return
        }
        adjustCollectionViewCells(scrollView: scrollView)
    }
    
    func adjustCollectionViewCells(scrollView:UIScrollView){
        var fileIndex = 0
        var greaterIndexPath : IndexPath!
        var smallerIndexPath : IndexPath!
        if self.collectionView.indexPathsForVisibleItems.first!.row > self.collectionView.indexPathsForVisibleItems.last!.row{
            greaterIndexPath    = self.collectionView.indexPathsForVisibleItems.first
            smallerIndexPath    = self.collectionView.indexPathsForVisibleItems.last
        }else{
            greaterIndexPath    = self.collectionView.indexPathsForVisibleItems.last
            smallerIndexPath    = self.collectionView.indexPathsForVisibleItems.first
        }
        
        if scrollView.contentOffset.x > oldOffSet{
            if ((scrollView.contentOffset.x) / CGFloat(greaterIndexPath!.row)) > self.view.bounds.width / 2{
                fileIndex = greaterIndexPath.row
                self.collectionView.scrollToItem(at: greaterIndexPath, at: UICollectionViewScrollPosition.left, animated: true)
            }else{
                fileIndex = smallerIndexPath.row
                self.collectionView.scrollToItem(at: smallerIndexPath, at: UICollectionViewScrollPosition.right, animated: true)
            }
        }else{
            if ((scrollView.contentOffset.x) / CGFloat(greaterIndexPath!.row)) > self.view.bounds.width / 2{
                fileIndex = smallerIndexPath.row
                self.collectionView.scrollToItem(at: smallerIndexPath, at: UICollectionViewScrollPosition.left, animated: true)
            }else{
                fileIndex = greaterIndexPath.row
                self.collectionView.scrollToItem(at: greaterIndexPath, at: UICollectionViewScrollPosition.right, animated: true)
            }
        }
        
//        if showingHalfImages{
            self.changeNamesArray(index: fileIndex)
//        }
        
        oldOffSet = scrollView.contentOffset.x
    }
}

extension UIView {
    func snapshot(of rect: CGRect? = nil) -> UIImage? {
        // snapshot entire view
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // if no `rect` provided, return image of whole view
        
        guard let image = wholeImage, let rect = rect else { return wholeImage }
        
        // otherwise, grab specified `rect` of image
        
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
    
}

extension String {
    var isNumeric: Bool {
        guard self.characters.count > 0 else { return false }
        let nums: Set<Character> = ["I","O","0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self.characters).isSubset(of: nums)
    }
}
