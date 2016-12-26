//
//  ViewController.swift
//  MACTableViewSwift
//
//  Created by MacKun on 2016/12/23.
//  Copyright © 2016年 com.soullon. All rights reserved.
//

import UIKit


class ViewController: UIViewController{
    
    var dataArr = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    lazy var  tableView :MACTableView = {
        
       let tableView = MACTableView.init(frame: self.view.bounds)
        tableView.macTableViewDelegate  = self
        tableView.emptyImage = UIImage.init(named: "placeholder_dropbox")!
        tableView.emptyTitle = "This is your Dashboard."

        return tableView
    }()
    func initUI(){
        self.view.addSubview(tableView)
    }
    func initData(){
        dataArr = ["张三","李四","王五","赵六","冯七"];
        self.tableView.beginLoading()
    }
      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController:MACTableViewDelegate{
    func loadDataRefreshOrPull(state: MACRefreshState) {
       
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 5), execute: {
            if state == .refreshing {
                self.dataArr = ["张三","李四","王五","赵六","冯七"]
            }else if state == .pulling{
                self.dataArr.removeAll()
            }
            self.tableView.endLoading()

        });
       
    }
}
extension ViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = dataArr[indexPath.row]
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("cell " + String(indexPath.row));
    }

}
