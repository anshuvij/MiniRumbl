//
//  VideoTableViewCell.swift
//  MiniRumbl
//
//  Created by Anshu Vij on 15/05/21.
//

import UIKit
import AVFoundation

protocol VideoTableViewCellDelegate {
    func selectedDevice(category : String, value: String, index : Int, rowNumber : Int)
}

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate : VideoTableViewCellDelegate?
    var sectionName : String?
    var rowNumber = 0
    var sectionValue : [Node]? {
        didSet {
            collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.allowsMultipleSelection = false
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 5);
        self.collectionView.register(UINib(nibName:Constants.videoCollectionViewCell , bundle: nil), forCellWithReuseIdentifier: Constants.videoCollectionViewCell)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func previewImageFromVideo(url: URL) -> UIImage? {
        let url = url as URL
        let request = URLRequest(url: url)
        let cache = URLCache.shared

        if
            let cachedResponse = cache.cachedResponse(for: request),
            let image = UIImage(data: cachedResponse.data)
        {
            return image
        }

        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = CGSize(width: 150, height: 150)

//        var time = asset.duration
//        time.value = min(time.value, 1)
        let time = CMTime(seconds: 0.0, preferredTimescale: 600)

        var image: UIImage?

        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            image = UIImage(cgImage: cgImage)
        } catch { }

        if
            let image = image,
            let data = image.pngData(),
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        {
            let cachedResponse = CachedURLResponse(response: response, data: data)
            
            cache.storeCachedResponse(cachedResponse, for: request)
        }

        return image
    }
    
    
}
extension VideoTableViewCell : UICollectionViewDelegate {
    
}

extension VideoTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // print("sectionName:\(sectionName) : \(Constants.applianceData[sectionName!]!.count)")
       // return Constants.applianceData[sectionName!]!.count
        return sectionValue?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.videoCollectionViewCell, for: indexPath) as! VideoCollectionViewCell
        
        let url = sectionValue?[indexPath.row].video.encodeURL
//        AVAsset(url: URL(string: url!)!).generateThumbnail { [weak self] (image) in
//                    DispatchQueue.main.async {
//                        guard let image = image else { return }
//                        cell.thumbnail.image = image
//                    }
//                }
        
        DispatchQueue.main.async {
            guard let image =  self.previewImageFromVideo(url: URL(string: url!)!) else { return }
            cell.thumbnail.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.selectedDevice(category: sectionName ?? "Trending", value: (sectionValue?[indexPath.row].video.encodeURL)!, index: indexPath.row,rowNumber: rowNumber)
        
        
    }
    
    
}

extension VideoTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250)
    }
}
