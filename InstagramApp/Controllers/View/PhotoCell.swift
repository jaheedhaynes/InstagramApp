//
//  PhotoCell.swift
//  InstagramApp
//
//  Created by Jaheed Haynes on 3/10/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var postedDateLabel: UILabel!
    
    public func configureCell(for photo: UserPhoto) {
           photoImage.kf.setImage(with: URL(string: photo.imageURL))
           nameLabel.text = photo.photoCaption
           usernameLabel.text = "Posted by user @\(photo.userNamePosted)"
           
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
           
           if let date = formatter.date(from: photo.listedDate.description) {
               print(date)
               
               let displayFormatter = DateFormatter()
               displayFormatter.dateFormat = "MM/dd/yyyy HH:mm"
               print(displayFormatter.string(from: date))
               postedDateLabel.text = displayFormatter.string(from: date)
           }
       }
}
