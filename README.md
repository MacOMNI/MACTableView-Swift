# MACTableView
##Projects using this library

对 UITableView 空白页文字提示、空白页图片、上拉下拉事件等进行了高度封装，使用简单高效，并命名为MACTableView, 欢迎star & issue

![GIF 1](https://github.com/azheng51714/MACTableView/blob/master/Photos/fvyO81OO7L.gif)
![GIF 2](https://github.com/azheng51714/MACTableView/blob/master/Photos/hmD0r7fU0J.gif)
![GIF 3](https://github.com/azheng51714/MACTableView/blob/master/Photos/MACTableView.png)
### Features
* 支持 多种空白样式：包括是否显示主标题、副标题、空白图以及是否支持上拉下拉代理事件等；
* 基于 MJRefresh & DZNEmptyDataSet 集成设计；
* 支持 Storyboard & Xib;
* 支持 iOS 6 及以上;
* 支持 iPhone & iPad.
* [Objective-c 版本](https://github.com/azheng51714/MACTableView)

## Installation

### cocoapods
 暂未提供

## How to use
* First Step 初始化 MACTableView ；

```Swift
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
```
* Second Step 设置 MACTableView属性 并开始加载；

```Swift
    tableView.macTableViewDelegate  = self
    tableView.emptyImage = UIImage.init(named: "placeholder_dropbox")!
    tableView.emptyTitle = "This is your Dashboard."
    self.tableView.beginLoading()
```

* Final Step 处理上拉下拉代理事件

```Swift
extension ViewController:MACTableViewDelegate{
    func loadDataRefreshOrPull(state: MACRefreshState) {

            if state == .refreshing {//下拉刷新
            //do something
            }else if state == .pulling{//加载更多
             // do other thing
            }
            //异步(网络访问)请求后执行 结束刷新
            self.tableView.endLoading()
    }
}
```
* Additional Remark 对于有自定义 RefreshHeader 需求的，新建一个继承自 MACRefreshGifHeader 的类，设置相关属性，重写 initialize 方法即可
  
```Swift
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
```
![GIF 4](https://github.com/azheng51714/MACTableView/blob/master/Photos/kF4saP4ilk.gif)
![GIF 5](https://github.com/azheng51714/MACTableView/blob/master/Photos/zUsnur8eFq.gif)

### MACTableView

这里对相关的参数变量、枚举类型、代理以及执行方法进行了详细的说明，您只需要根据具体情况设置相关属性，执行相应操作即可。
```Swift
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

 @IBInspectable  var showEmpty = true  /**  是否展示空白页,默认展示*/
   @IBInspectable var emptyTitle = ""  /**  空白标题 默认为 "",不显示*/
   @IBInspectable var emptySubTitle = "暂无数据"  /**  空白页展位图名称 默认为 nil,不显示*/
   @IBInspectable  var emptyImage = UIImage.init() /**  空白页展位图名称 默认为 nil,不显示*/
    
   var emptyColor = UIColor.clear   /**  空白页颜色 默认为 clear*/
   @IBInspectable var emptyAttributedTitle:NSAttributedString? /**  空白自定义标题 默认不显示*/
   @IBInspectable var emptyAttributedSubTitle:NSAttributedString? /** 空白自定义副标题 默认不显示*/
    
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

```
## License
(The MIT License)


