//
//  VideoPlayerVC.swift
//  MiniRumbl
//
//  Created by Anshu Vij on 16/05/21.
//

import UIKit
import AVFoundation


class VideoPlayerVC: UIViewController {
    
    var swipeView = UIView()
    var currentIndex = 0
    var playUrl = ""
    var nodes = [Node]()
    var player : AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = .right
        self.swipeView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = .left
        self.swipeView.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = .up
        self.swipeView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        self.swipeView.addGestureRecognizer(swipeDown)
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemGray6
        } else {
            self.view.backgroundColor = .systemGray
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        
        playVideo(with: playUrl)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        player?.pause()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.transform = CGAffineTransform.identity
        })
    }
    func playVideo(with urlString : String) {
        if MiniRumbltUtils.isInternetAvaible() {
        if urlString.count > 0 {
            let videoURL = URL(string: urlString )
            player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            playerLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(playerLayer)
            swipeView.frame = self.view.frame
            swipeView.backgroundColor = .clear
            self.view.addSubview(swipeView)
            self.view.bringSubviewToFront(swipeView)
            player?.play()
        }
        }else {
            alertNoInternet()
        }
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
                //self.navigationController?.popViewController(animated: true)
                let transition: CATransition = CATransition()
                transition.duration = 0.3
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                transition.type = CATransitionType.fade
                transition.subtype = CATransitionSubtype.fromBottom
                self.view.window!.layer.add(transition, forKey: nil)
                self.dismiss(animated: false, completion: nil)
            case .down:
                player?.pause()
                if currentIndex > 0 {
                    currentIndex -= 1
                }
                else {
                    currentIndex =  nodes.count-1
                }
                playVideo(with: nodes[currentIndex].video.encodeURL)
            case .left:
                print("Swiped left")
            case .up:
                player?.pause()
                if currentIndex < nodes.count-1 {
                    currentIndex += 1
                }
                else {
                    currentIndex = 0
                }
                playVideo(with: nodes[currentIndex].video.encodeURL)
            default:
                break
            }
        }
    }
}
