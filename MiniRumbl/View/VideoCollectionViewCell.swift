//
//  VideoCollectionViewCell.swift
//  MiniRumbl
//
//  Created by Anshu Vij on 15/05/21.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {

    //MARK: - Properties
   // @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var thumbnail: ImageLoader!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.thumbnail.layer.masksToBounds = true
        self.thumbnail.layer.cornerRadius = 8
    }

}
