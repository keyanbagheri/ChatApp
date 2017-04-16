//
//  ImageTableViewCell.swift
//  ChatApp
//
//  Created by Max Jala on 11/04/2017.
//  Copyright © 2017 Key + Max. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var chatImageView: UIImageView! {
        didSet{
//            
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImage))
//            chatImageView.isUserInteractionEnabled = true
//            chatImageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeSentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showImage() {
        //        let bigImageView = UIImageView(image: self.image)
        //        bigImageView.contentMode = UIViewContentMode.scaleAspectFit
        //        bigImageView.frame = (self.inputView?.frame)!
        //        self.inputViewController?.view.addSubview(bigImageView)
//        print("HELLOOOOOO!!")
    }
    
    

}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        // Check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage as? UIImage
            return
        }
        
        // Otherwise fire off a new download
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url as! URL, completionHandler: { (data, response, error) in
            
            // Dowload hit an error so let's return out
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
    

    
}
