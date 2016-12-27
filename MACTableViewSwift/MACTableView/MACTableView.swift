//
//  MACTableView.swift
//  MACTableViewSwift
//
//  Created by MacKun on 2016/12/23.
//  Copyright © 2016年 com.soullon. All rights reserved.
//

import UIKit
import MJRefresh
import DZNEmptyDataSet
enum MACRefreshState{
   case refreshing /** 下拉刷新的状态 */
    case pulling  /** pull 加载更多刷新中的状态 */
}
enum MACCanLoadState {
    case none /**不支持下拉和加载更多*/
    case refresh /**只支持下拉刷新*/
    case all /** 同时支持下拉和加载更多*/
}

protocol MACTableViewDelegate:class {
    func loadDataRefreshOrPull(state:MACRefreshState)
}

class MACTableView: UITableView {
    
   @IBInspectable var showEmpty = true  /**  是否展示空白页,默认展示*/
   @IBInspectable var emptyTitle = ""  /**  空白标题 默认为 "",不显示*/
   @IBInspectable var emptySubTitle = "暂无数据"  /**  空白页展位图名称 默认为 nil,不显示*/
   @IBInspectable var emptyImage = UIImage.init() /**  空白页展位图名称 默认为 nil,不显示*/
   @IBInspectable var emptyAttributedTitle:NSAttributedString? /**  空白自定义标题 默认不显示*/
   @IBInspectable var emptyAttributedSubTitle:NSAttributedString? /** 空白自定义副标题 默认不显示*/
   
   var emptyColor = UIColor.clear   /**  空白页颜色 默认为 clear*/

   var macCanLoadState = MACCanLoadState.all {
        
        didSet {
            switch macCanLoadState {
            case .all:
                self.setRefreshFooter()
                self.setRefreshHeader()
                break
            case .refresh:
                self.setRefreshHeader()
                self.mj_footer = nil
                break
            default:
                self.mj_footer = nil
                self.mj_header = nil
                break
            }
        }
    }
  
   weak open var macTableViewDelegate: MACTableViewDelegate? {

        didSet {
            self.delegate = macTableViewDelegate as? UITableViewDelegate
            self.dataSource = macTableViewDelegate as? UITableViewDataSource
        }
    }

    override init(frame: CGRect, style: UITableViewStyle){
        super.init(frame: frame, style: style)

        initUI()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder);
        
        initUI()
    }


    convenience init(frame: CGRect) {
        
        self.init(frame:frame, style:UITableViewStyle.plain);
    }
    
    convenience init(){
        self.init(frame:.zero,style:.plain)
        initUI()
        
    }
    
    func initUI(){
        self.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableFooterView = UIView()
        self.backgroundColor = UIColor.groupTableViewBackground
        self.macCanLoadState = MACCanLoadState.all
    }
    func beginLoading(){

        self.mj_header.beginRefreshing {
            
            if self.showEmpty {
                self.emptyDataSetSource   = self
                self.emptyDataSetDelegate = self
            }
        }
    }
    func endLoading(){
        if self.mj_header.isRefreshing() {
            self.mj_header.endRefreshing()
            self.mj_header.endRefreshing(completionBlock: { 
                self.mac_reloadData()
            });
        }
        if self.mj_footer.isRefreshing() {
            self.mj_footer.endRefreshing(completionBlock: { 
               self.mac_reloadData()
            });
        }
    }
    //MARK:private methods

    func setRefreshHeader(){
        if MACRefreshGifHeader.className.isEmpty {
            self.mj_header = MJRefreshNormalHeader (refreshingBlock: {
                self.refreshData()
            });
        }else {
    
        let gifHeader = NSClassFromString(MACRefreshGifHeader.className) as! MJRefreshGifHeader.Type
    
            let header = gifHeader.init()
             header.setRefreshingTarget(self, refreshingAction: #selector(refreshData))
            self.mj_header = header
            
        }
        self.mj_header.isMultipleTouchEnabled = false
    }
    func setRefreshFooter(){
        self.mj_footer = MJRefreshAutoNormalFooter (refreshingBlock: {
            self.pullData()
        });
        self.mj_footer.isMultipleTouchEnabled = false
    }
    func mac_reloadData(){
        self.reloadData()
        if self.macCanLoadState == .all && self.isEmptyTableView() {
            self.mj_footer.isHidden = true
        } else if self.macCanLoadState == .all {
            self.mj_footer.isHidden = false
        }
    }
    func refreshData() {
        self.macTableViewDelegate?.loadDataRefreshOrPull(state: .refreshing)
    }
    func pullData(){
        self.macTableViewDelegate?.loadDataRefreshOrPull(state: .pulling)
    }
    func isEmptyTableView() -> Bool {
        
        //FIXME:待完善
        let src = self.dataSource
        var sections = 1
        if (src != nil) && (src?.responds(to: #selector(getter: self.numberOfSections)))! {
            sections = (src?.numberOfSections!(in: self))!
        }
        if sections > 1 {
            return false
        }
        for index in 0..<sections {
            let rows = src?.tableView(self, numberOfRowsInSection: index)
            if rows!>0 {
                return false
            }
        }
        
        return true
    }
    
}
//MARK:代理方法

extension MACTableView : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = self.emptyTitle.lengthOfBytes(using: String.Encoding.utf8)>0 ? self.emptyTitle : ""
        let attributes  = [NSFontAttributeName:UIFont.systemFont(ofSize: 18),
                           NSForegroundColorAttributeName:UIColor.darkGray]
        
        return NSAttributedString.init(string: text, attributes: attributes)
        
    }
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return self.emptyImage
    }
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return self.emptyColor
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -20.0
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 0.0
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self .beginLoading()
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        
        let animation = CABasicAnimation.init(keyPath: "transform")
        animation.fromValue = NSValue.init(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue.init(caTransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0, 0, 1))
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        return animation
    }


}
