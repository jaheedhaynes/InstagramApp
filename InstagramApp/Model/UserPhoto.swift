//
//  Model.swift
//  InstagramApp
//
//  Created by Jaheed Haynes on 3/8/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import UIKit

struct UserPhoto {
    let imageURL: String
    let photoCaption: String
    let photoId: String
    let listedDate: Date
    let userNamePosted: String
    let userIDPhotoPost: String
}

extension UserPhoto {
    init(_ dictionary: [String: Any]) {
        self.imageURL = dictionary["imageURL"] as? String ?? "no image url"
        self.photoCaption = dictionary["photoCaption"] as? String ?? "no photo caption"
        self.photoId = dictionary["photoId"] as? String ?? "no photoId"
        self.listedDate = dictionary["listedDate"] as? Date ?? Date()
        self.userNamePosted = dictionary["userNamePosted"] as? String ?? "no user name"
        self.userIDPhotoPost = dictionary["userIDPhotoPost"] as? String ?? "no user ID"
    }
}
