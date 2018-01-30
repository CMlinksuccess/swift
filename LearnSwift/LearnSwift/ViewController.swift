//
//  ViewController.swift
//  LearnSwift
//
//  Created by ECOOP－09 on 16/8/4.
//  Copyright © 2016年 ECOOP－09. All rights reserved.
//

import UIKit


public let kScreenWidth = UIScreen.mainScreen().bounds.width
public let kScreenHeight = UIScreen.mainScreen().bounds.height

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UIActionSheetDelegate,UITextViewDelegate{

    
    var textView = UITextView()
    
    var tableView = UITableView()
    
    var array = NSMutableArray()
    
    var detailView : UIView?
    
    var currentRow : Int = -1
    
    var searchBar = UISearchBar()
    
    var searchArray = NSMutableArray()
    
    var issearch : Bool = false
    
    var searchOver : UIButton?
    
    var searchDic : NSMutableDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //读取文件内容
        let plistArr = NSMutableArray.init(contentsOfFile: self.readPlist())
        if plistArr != nil {
            self.array = plistArr!
        }
        
        searchBar = UISearchBar.init(frame: CGRectMake(0, 20, kScreenWidth, 35))
        searchBar.placeholder = "请输入搜索内容.."
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        //..
        textView = UITextView.init(frame:CGRectMake(10, 60, kScreenWidth - 20, 100))
        textView.backgroundColor = UIColor.lightGrayColor()
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.delegate = self
     
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(ViewController.handleTapGesture(_:)))
        textView.addGestureRecognizer(tapGesture)
        self.view.addSubview(textView)
        //..
        let button = UIButton.init(frame: CGRectMake(10, 165, 80, 30))
        button.setTitle("加入表格", forState: .Normal)
        button.backgroundColor = UIColor.redColor()
        self.setOvalView(button)
        button.addTarget(self, action: #selector(ViewController.buttonClick), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        //..
        let detailButton = UIButton.init(frame: CGRectMake(120, 165, 80, 30))
        detailButton.setTitle("查看", forState: .Normal)
        detailButton.backgroundColor = UIColor.redColor()
        self.setOvalView(detailButton)
        detailButton.addTarget(self, action: #selector(ViewController.createDetailView), forControlEvents: .TouchUpInside)
        self.view.addSubview(detailButton)
        //..
        let cleanButton = UIButton.init(frame: CGRectMake(230, 165, 80, 30))
        cleanButton.setTitle("清空", forState: .Normal)
        cleanButton.backgroundColor = UIColor.redColor()
        self.setOvalView(cleanButton)
        cleanButton.addTarget(self, action: #selector(ViewController.clean), forControlEvents: .TouchUpInside)
        self.view.addSubview(cleanButton)
        //..
        self.tableView = UITableView.init(frame:CGRectMake(0, 200, kScreenWidth, kScreenHeight - 200))
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.view.addSubview(self.tableView)
      
      // 监听键盘通知
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillChange), name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillChange), name: UIKeyboardWillHideNotification, object: nil)
    }
   
   /**
    设置椭圆
    */
   func setOvalView(view: UIView){
      
      view.layer.cornerRadius = 10
      view.layer.masksToBounds = true
      
   }
   
   
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        if issearch == true{
            return
        }
        issearch = true
        tableView.reloadData()
        searchOver = UIButton.init(frame: CGRectMake(-45, 20, 45, 35))
        searchOver!.setTitle("完成", forState: .Normal)
        searchOver!.setTitleColor(UIColor.blackColor(), forState: .Normal)
        searchOver!.tag = 10000
        searchOver!.addTarget(self, action: #selector(ViewController.searchOverAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(searchOver!)
        UIView.animateWithDuration(0.5) {
            self.searchOver!.transform = CGAffineTransformMakeTranslation(45, 0)
            self.searchBar.frame =  CGRectMake(45, 20, kScreenWidth - 45, 35)
        }
    
    }
    func searchOverAction(){
        let searchOver = self.view.viewWithTag(10000)
        UIView.animateWithDuration(0.5, animations: {
            
            searchOver!.transform = CGAffineTransformIdentity
            self.searchBar.frame =  CGRectMake(0, 20, kScreenWidth, 35)
            
            }) { (true) in
                self.issearch = false
                self.searchBar.text = nil
                self.searchBar.endEditing(false)
                self.tableView.reloadData()
                searchOver!.removeFromSuperview()
        }
    
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
     
        self.issearch = true
        let search = searchTextWithArray(array, search: searchText)
        self.searchArray =  NSMutableArray.init(array: search.searchResult)
         searchDic = search.dictionary
        self.tableView.reloadData()
    }

      /**
         键盘搜索按钮
     */
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
    
        searchBar.endEditing(true)
    }
    /**
        清除内容
     */
    func clean(){
    
    self.textView.text = nil
        
    }
    /**
         单击手势
     */
    func handleTapGesture(tap:UITapGestureRecognizer){
    
      self.textView.editable = true
      self.textView.endEditing(true)
    }

    /**
         添加到表格按钮事件
     */
     func buttonClick(){
        self.textView.endEditing(true)

        if !textView.text.isEmpty {
            for string in self.array {
             // 去前后空格
             let stringTrim = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
             let textViewTrim = textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
         
                if stringTrim == textViewTrim {
                    if #available(iOS 8.0, *) {
                        let alert = UIAlertController.init(title: "提示", message: "已存在，不可重复添加", preferredStyle: .Alert)
                        let acSure = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                           
                        }
                        
                        alert.addAction(acSure)
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertView.init(title: "提示", message: "已存在，不可重复添加", delegate: self, cancelButtonTitle: "确定")
                        alert.show()
                    }
                  
                    return
                }
            }

        self.array.addObject(textView.text)
        self.tableView.reloadData()
     
        array.writeToFile(self.readPlist(), atomically: true)
        self.showTip("添加成功！")
            
        }
    }
    /**
        提示显示
     */
    func showTip(text: String){
    
        let window = UIApplication.sharedApplication().keyWindow
        let tipLabel = UILabel.init(frame: CGRectMake((kScreenWidth - 120)/2, (kScreenHeight - 35 - 20)/2, 120, 35))
        tipLabel.text = text
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.backgroundColor = UIColor.grayColor()
        tipLabel.textAlignment = NSTextAlignment.Center
        tipLabel.layer.cornerRadius = 15
        tipLabel.layer.masksToBounds = true
        window?.addSubview(tipLabel)
        
        UIView.animateWithDuration(3, animations: {
            
            tipLabel.alpha = 0
            
            }, completion: { (ture) in
                
                tipLabel.removeFromSuperview()
        })
        }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       
        if issearch {
            return searchArray.count
        }
        return array.count;
    
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let indentifier = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(indentifier)
        if cell == nil {
            
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: indentifier)
        }
        if issearch {
            cell!.textLabel?.text = searchArray[indexPath.row] as? String
        }else{
            cell!.textLabel?.text = array[indexPath.row] as? String
        }
      
      //增加长按手势
      let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(ViewController.longPressAction(_:)))
      cell!.addGestureRecognizer(longPress)
         
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {

            if issearch {

                let numStr = searchDic?.objectForKey("\(indexPath.row)")
                let num = numStr!.integerValue
                self.array.removeObjectAtIndex(num)
                array.writeToFile(self.readPlist(), atomically: true)
               
               let search = searchTextWithArray(array, search: searchBar.text!)
               self.searchArray =  NSMutableArray.init(array: search.searchResult)
               self.tableView.reloadData()
            }else{
                
                self.array.removeObjectAtIndex(indexPath.row)
                array.writeToFile(self.readPlist(), atomically: true)
               tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if issearch {
            
            self.textView.text = self.searchArray[indexPath.row] as! String
        }else{
            
            self.textView.text = self.array[indexPath.row] as! String
        }
      self.textView.editable = false
      self.textView.dataDetectorTypes = UIDataDetectorTypes.All
      self.textView.selectable = true
        self.currentRow = indexPath.row
      
    }
   /**
     增加长按事件
    */
   func longPressAction(longPress:UILongPressGestureRecognizer){
      if longPress.state == UIGestureRecognizerState.Ended{
         
         return;
         
      } else if longPress.state == UIGestureRecognizerState.Began{
         
      //获取点击的行
     let cellPoint = longPress.locationInView(self.tableView)
     let cellIndexPath = self.tableView.indexPathForRowAtPoint(cellPoint)
   
      //调用系统自带分享功能
      let shareCtrl = UIActivityViewController.init(activityItems: [array[cellIndexPath!.row] as! String, NSURL.init(string: "http://www.baidu.com")!], applicationActivities: nil)
      //禁止显示类型
      // shareCtrl.excludedActivityTypes = [UIActivityTypeAirDrop,UIActivityTypeCopyToPasteboard,UIActivityTypeAddToReadingList]
      self.presentViewController(shareCtrl, animated: true, completion: nil)
      
      }
   }
    /**
        创建查看视图
     */
    func createDetailView(){
        if issearch {
            
            issearch = false
            self.searchOverAction()
        }
        //
        detailView = UIView.init(frame: textView.frame)
        detailView?.backgroundColor = UIColor.grayColor()
        self.view.addSubview(detailView!)
        //
        let backButton = UIButton.init(frame: CGRectMake(10, 10, 40, 40))
        backButton.setTitle("返回", forState: .Normal)
        backButton.addTarget(self, action: #selector(backButtonClick), forControlEvents: .TouchUpInside)
        detailView!.addSubview(backButton)
        //
        let  updateButton = UIButton.init(frame: CGRectMake(kScreenWidth - 150, 10, 80, 40))
        updateButton.setTitle("修改完成", forState: .Normal)
        updateButton.addTarget(self, action: #selector(updateButtonClick), forControlEvents: .TouchUpInside)
        detailView!.addSubview(updateButton)
        //
        let editButton = UIButton.init(frame: CGRectMake(kScreenWidth - 40, 10, 40, 40))
        editButton.setTitle("新增", forState: .Normal)
        editButton.addTarget(self, action: #selector(buttonClick), forControlEvents: .TouchUpInside)
        detailView!.addSubview(editButton)
        self.detailView!.addSubview(self.textView)
        self.detailView!.hidden = false
        
        UIView.animateWithDuration(0.5) {
            
            self.textView.frame = CGRectMake(0, 60, kScreenWidth, kScreenHeight - 80)
        }
        self.detailView?.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20)
      
    }
    
    func updateButtonClick(){
      
        if currentRow > -1 && self.textView.text != "" && self.textView.text != self.array[currentRow] as? String {
            self.array[currentRow] = self.textView.text
            let indexPath = NSIndexPath.init(forRow: currentRow, inSection: 0)
            let indexPathArr = NSArray.init(object: indexPath)
            self.tableView.reloadRowsAtIndexPaths(indexPathArr as! [NSIndexPath], withRowAnimation: .None)
            
            array.writeToFile(self.readPlist(), atomically: true)
        }else{
        
            self.showTip("未修改")
        }
        self.backButtonClick()
    
    }
    /**
        返回按钮事件
     */
    func backButtonClick(){
        self.textView.endEditing(false)
         UIView.animateWithDuration(0.5, animations: {
            self.textView.frame = CGRectMake(10, 60, kScreenWidth - 20, 100)
            self.view.addSubview(self.textView)

            }) { (true) in
            
                self.textView.setContentOffset(CGPointMake(0, 0), animated: true)
        }

        self.detailView?.removeFromSuperview()
        self.detailView?.hidden = true
    
    }
    
    /**
        键盘改变事件
     */
    func keyboardWillChange(info: NSNotification){
      
        if (self.detailView?.hidden == true) || (self.detailView == nil){
         
         if info.name == UIKeyboardWillHideNotification {
            self.textView.editable = false
            self.textView.dataDetectorTypes = UIDataDetectorTypes.All
            self.textView.selectable = true
         }
            return
        }
        
        let keyboardinfo = info.userInfo![UIKeyboardFrameBeginUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        
        if info.name == UIKeyboardWillShowNotification {
            UIView.animateWithDuration(0.25) {
                self.textView.frame = CGRectMake(0, 60, kScreenWidth, kScreenHeight - keyboardheight - 80)
            }
            
        }else if info.name == UIKeyboardWillHideNotification {
        
         UIView.animateWithDuration(0.25, animations: {
            self.textView.frame = CGRectMake(0, 60, kScreenWidth, kScreenHeight - 80)

            }, completion: { (true) in
               self.textView.editable = false
               self.textView.dataDetectorTypes = UIDataDetectorTypes.All
               self.textView.selectable = true
         })
         
        }

    }

    /**
        读取文件目录
     */
    func readPlist() -> String{
    
        let home = NSHomeDirectory()
        let filepath = home.stringByAppendingString("/Documents/file.plist")
        return filepath;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

