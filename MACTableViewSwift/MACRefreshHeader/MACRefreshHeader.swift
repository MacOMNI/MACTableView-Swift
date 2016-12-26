//
//  MACRefreshHeader.swift
//  MACTableViewSwift
//
//  Created by MacKun on 2016/12/26.
//  Copyright © 2016年 com.soullon. All rights reserved.
//

import UIKit

class MACRefreshHeader: MACRefreshGifHeader {

    override func prepare() {
        super.prepare()
        let idleImages = [UIImage.init(named: "icon_refresh_1")!]
        let refreshImages = [
            UIImage.init(named: "icon_refresh_1")!,
            UIImage.init(named: "icon_refresh_2")!,
            UIImage.init(named: "icon_refresh_3")!]
        self.setImages(idleImages, for: .idle)
        self.setImages(refreshImages, for: .pulling)
        self.setImages(refreshImages, for: .refreshing)
        self.lastUpdatedTimeLabel.isHidden = true

    }
    public override class func initialize(){
        super.registerMACRefresh()
    }
}

