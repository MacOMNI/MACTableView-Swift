//
//  MACRefreshGifHeader.swift
//  MACTableViewSwift
//
//  Created by MacKun on 2016/12/26.
//  Copyright © 2016年 com.soullon. All rights reserved.
//

import UIKit
import MJRefresh

class MACRefreshGifHeader: MJRefreshGifHeader {
    static var className = ""
    
    static func registerMACRefresh(){
       className = NSStringFromClass(self)
    }
}
