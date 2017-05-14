//
//  ImagesController.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 14.05.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import UIKit

class ImagesController: UIViewController,UICollectionViewDataSource {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    var imagesLinks = [String]()
    let sender = RequestSender()
    var images = [UIImage]()
    var imageViewToChange:UIImageView?
    let apiKey = "5362134-e2d4049a6ac9debeccc51b448"
    fileprivate let sectionInsets = UIEdgeInsets(top: 30.0, left: 20.0, bottom: 30.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 3
    var link_downloader:LinksDownloader?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        link_downloader = LinksDownloader(apiKey: apiKey)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        link_downloader?.requestImagesLinks(tag: "erotic", closure: self.handleData)
        
        // Do any additional setup after loading the view.
    }

    
    
    func handleData(data:[String]){
        print("Data recieved \(data.count)")
        imagesLinks = data
        images = Array(repeating: UIImage(named:"placeholder")!, count: data.count)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UICollectionViewDataSource
extension ImagesController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return imagesLinks.count
    }
    
    func congfigurateCell(index:IndexPath){
        //self.collectionView.reloadItems(at: [index])
        //return
        if self.images[index.row] == UIImage(named:"placeholder"){
        sender.send(url: URL(string:imagesLinks[index.row])!) { (data, error) in
            if let data = data{
                self.images[index.row] = UIImage(data:data)!
                    DispatchQueue.main.async() { () -> Void in
                    self.collectionView.reloadItems(at: [index])
                }
            }
        }
    }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath) as! ImageCollectionViewCell
        cell.backgroundColor = UIColor.black
        // Configure the cell
        cell.mainView.image = self.images[indexPath.row]
        congfigurateCell(index: indexPath)
        //cell.configure(path:imagesLinks[indexPath.row])
        return cell
    }
    
}

extension ImagesController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageViewToChange?.image = images[indexPath.row]
        self.dismiss(animated: true, completion: nil)
    }
}
