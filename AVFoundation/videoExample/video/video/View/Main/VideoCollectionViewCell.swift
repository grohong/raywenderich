//
//  VideoCollectionViewCell.swift
//  video
//
//  Created by Seong ho Hong on 2018. 4. 22..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var videoThumbnailImage: UIImageView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var videoTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func putVideo(info: UIImage) {
        videoThumbnailImage.image = info
        userImage.image = #imageLiteral(resourceName: "Add_Butt")
        videoTitleLabel.text = "승아야~~~~"
    }
}
