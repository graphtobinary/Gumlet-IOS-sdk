//
//  GumletVideoPlayer.swift
//  GumletDRMProtectedVideoPlayerSDK
//
//  Created by Khushboo Sharma on 29/01/26.
//
//

import UIKit
import AVFoundation

public final class GumletVideoPlayer: UIView {

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var drmManager: FairPlayDRMManager?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .black
    }

    /// Load DRM-protected stream
       public func loadDRMVideo(url: URL,
                                drmConfiguration: DRMConfiguration) {

           let asset = AVURLAsset(url: url)

           drmManager = FairPlayDRMManager(configuration: drmConfiguration)
           drmManager?.addAsset(asset)

           let item = AVPlayerItem(asset: asset)
           player = AVPlayer(playerItem: item)

           playerLayer = AVPlayerLayer(player: player)
           playerLayer?.videoGravity = .resizeAspect

           if let layer = playerLayer {
               layer.frame = bounds
               self.layer.addSublayer(layer)
           }
       }

    /// Configure player with video URL
    ///
    
    
//    public func loadVideo(url: URL) {
//            player = AVPlayer(url: url)
//            playerLayer = AVPlayerLayer(player: player)
//            playerLayer?.videoGravity = .resizeAspect
//
//            if let layer = playerLayer {
//                layer.frame = bounds
//            self.layer.addSublayer(layer)
//        }
//    }

    /// Play video
    public func play() {
        player?.play()
    }

    /// Pause video
    public func pause() {
        player?.pause()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}

