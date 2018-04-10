//
//  ViewController.swift
//  LearnSwift
//
//  Created by ECOOP－09 on 16/8/4.
//  Copyright © 2016年 ECOOP－09. All rights reserved.
//

import UIKit


public let kScreenWidth = UIScreen.main.bounds.width
public let kScreenHeight = UIScreen.main.bounds.height

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
        
        searchBar = UISearchBar.init(frame: CGRect(x: 0, y: 20, width: kScreenWidth, height: 35))
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "请输入搜索内容.."
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        //..
        textView = UITextView.init(frame:CGRect(x: 10, y: 60, width: kScreenWidth - 20, height: 100))
        textView.backgroundColor = UIColor.lightGray
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.delegate = self
     
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(ViewController.handleTapGesture(_:)))
        textView.addGestureRecognizer(tapGesture)
        self.view.addSubview(textView)
        //..
        let button = UIButton.init(frame: CGRect(x: 10, y: 165, width: 80, height: 30))
        button.setTitle("加入表格", for: UIControlState())
        button.backgroundColor = UIColor.red
        self.setOvalView(button)
        button.addTarget(self, action: #selector(ViewController.buttonClick), for: .touchUpInside)
        self.view.addSubview(button)
        //..
        let detailButton = UIButton.init(frame: CGRect(x: 120, y: 165, width: 80, height: 30))
        detailButton.setTitle("查看", for: UIControlState())
        detailButton.backgroundColor = UIColor.red
        self.setOvalView(detailButton)
        detailButton.addTarget(self, action: #selector(ViewController.createDetailView), for: .touchUpInside)
        self.view.addSubview(detailButton)
        //..
        let cleanButton = UIButton.init(frame: CGRect(x: 230, y: 165, width: 80, height: 30))
        cleanButton.setTitle("清空", for: UIControlState())
        cleanButton.backgroundColor = UIColor.red
        self.setOvalView(cleanButton)
        cleanButton.addTarget(self, action: #selector(ViewController.clean), for: .touchUpInside)
        self.view.addSubview(cleanButton)
        //..
        self.tableView = UITableView.init(frame:CGRect(x: 0, y: 200, width: kScreenWidth, height: kScreenHeight - 200))
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.view.addSubview(self.tableView)
      
      // 监听键盘通知
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
   
   /**
      设置椭圆
    */
   func setOvalView(_ view: UIView){
      
      view.layer.cornerRadius = 10
      view.layer.masksToBounds = true
   
   }
   
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        if issearch == true{
            return
        }
        issearch = true
        tableView.reloadData()
        searchOver = UIButton.init(frame: CGRect(x: -45, y: 20, width: 45, height: 35))
        searchOver!.setTitle("完成", for: UIControlState())
        searchOver!.setTitleColor(UIColor.black, for: UIControlState())
        searchOver!.tag = 10000
        searchOver!.addTarget(self, action: #selector(ViewController.searchOverAction), for: .touchUpInside)
        self.view.addSubview(searchOver!)
        UIView.animate(withDuration: 0.5, animations: {
            self.searchOver!.transform = CGAffineTransform(translationX: 45, y: 0)
            self.searchBar.frame =  CGRect(x: 45, y: 20, width: kScreenWidth - 45, height: 35)
        }) 
    
    }
    func searchOverAction(){
        let searchOver = self.view.viewWithTag(10000)
        UIView.animate(withDuration: 0.5, animations: {
            
            searchOver!.transform = CGAffineTransform.identity
            self.searchBar.frame =  CGRect(x: 0, y: 20, width: kScreenWidth, height: 35)
            
            }, completion: { (true) in
                self.issearch = false
                self.searchBar.text = nil
                self.searchBar.endEditing(false)
                self.tableView.reloadData()
                searchOver!.removeFromSuperview()
        }) 
    
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
     
        self.issearch = true
        let search = searchTextWithArray(array, search: searchText)
        self.searchArray =  NSMutableArray.init(array: search.searchResult)
         searchDic = search.dictionary
        self.tableView.reloadData()
    }
    /**
         键盘搜索按钮
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
    
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
    func handleTapGesture(_ tap:UITapGestureRecognizer){
    
      self.textView.isEditable = true
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
             let stringTrim = (string as AnyObject).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
             let textViewTrim = textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
         
                if stringTrim == textViewTrim {
                    if #available(iOS 8.0, *) {
                        let alert = UIAlertController.init(title: "提示", message: "已存在，不可重复添加", preferredStyle: .alert)
                        let acSure = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                           
                        }
                        
                        alert.addAction(acSure)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertView.init(title: "提示", message: "已存在，不可重复添加", delegate: self, cancelButtonTitle: "确定")
                        alert.show()
                    }
                  
                    return
                }
            }

        self.array.add(textView.text)
        self.tableView.reloadData()
     
        array.write(toFile: self.readPlist(), atomically: true)
        self.showTip("添加成功！")
            
        }
    }
    /**
        提示显示
     */
    func showTip(_ text: String){
    
        let window = UIApplication.shared.keyWindow
        let tipLabel = UILabel.init(frame: CGRect(x: (kScreenWidth - 120)/2, y: (kScreenHeight - 35 - 20)/2, width: 120, height: 35))
        tipLabel.text = text
        tipLabel.textColor = UIColor.white
        tipLabel.backgroundColor = UIColor.darkGray
        tipLabel.textAlignment = NSTextAlignment.center
        tipLabel.layer.cornerRadius = 15
        tipLabel.layer.masksToBounds = true
        window?.addSubview(tipLabel)
        
        UIView.animate(withDuration: 3, animations: {
            
            tipLabel.alpha = 0
            
            }, completion: { (ture) in
                
                tipLabel.removeFromSuperview()
        })
        }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       
        if issearch {
            return searchArray.count
        }
        return array.count;
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let indentifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: indentifier)
        if cell == nil {
            
            cell = UITableViewCell.init(style: .default, reuseIdentifier: indentifier)
        }
        if issearch {
            cell!.textLabel?.text = searchArray[(indexPath as NSIndexPath).row] as? String
        }else{
            cell!.textLabel?.text = array[(indexPath as NSIndexPath).row] as? String
        }
      
      //增加长按手势
      let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(ViewController.longPressAction(_:)))
      cell!.addGestureRecognizer(longPress)
         
        return cell!
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {

            if issearch {

               let numStr = searchDic?.object(forKey: "\((indexPath as NSIndexPath).row)") as! NSNumber
               let num = numStr.intValue
                self.array.removeObject(at: num)
                array.write(toFile: self.readPlist(), atomically: true)
               
               let search = searchTextWithArray(array, search: searchBar.text!)
               self.searchArray =  NSMutableArray.init(array: search.searchResult)
               self.tableView.reloadData()
            }else{
                
                self.array.removeObject(at: (indexPath as NSIndexPath).row)
                array.write(toFile: self.readPlist(), atomically: true)
               tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }

        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        if issearch {
            
            self.textView.text = self.searchArray[(indexPath as NSIndexPath).row] as! String
        }else{
            
            self.textView.text = self.array[(indexPath as NSIndexPath).row] as! String
        }
        self.currentRow = (indexPath as NSIndexPath).row
        self.dataDetector()
      
    }
    /**
        增加长按事件
    */
   func longPressAction(_ longPress:UILongPressGestureRecognizer){
      textView.endEditing(true)
      if longPress.state == UIGestureRecognizerState.ended{
         
         return;
         
      } else if longPress.state == UIGestureRecognizerState.began{
         
         let cellPoint = longPress.location(in: self.tableView)
         let cellIndexPath = self.tableView.indexPathForRow(at: cellPoint)
         
          //调用系统自带分享功能
         let shareCtrl = UIActivityViewController.init(activityItems: [array[(cellIndexPath! as NSIndexPath).row] as! String, URL.init(string: "http://www.baidu.com")!], applicationActivities: nil)
         //默认都显示，以下声明不要显示的分享平台
         //shareCtrl.excludedActivityTypes = [UIActivityType.postToFacebook,UIActivityType.postToWeibo,UIActivityType.copyToPasteboard,UIActivityType.airDrop,UIActivityType.message];
         self.present(shareCtrl, animated: true, completion: nil)
         
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
        //..
        detailView = UIView.init(frame: textView.frame)
        detailView?.backgroundColor = UIColor.white
        self.view.addSubview(detailView!)
        //..
        let backButton = UIButton.init(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        backButton.setTitle("返回", for: UIControlState())
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        detailView!.addSubview(backButton)
        //..
        let  updateButton = UIButton.init(frame: CGRect(x: kScreenWidth - 150, y: 10, width: 80, height: 40))
        updateButton.setTitle("修改完成", for: UIControlState())
        updateButton.setTitleColor(UIColor.black, for: .normal)
        updateButton.addTarget(self, action: #selector(updateButtonClick), for: .touchUpInside)
        detailView!.addSubview(updateButton)
        //..
        let editButton = UIButton.init(frame: CGRect(x: kScreenWidth - 40, y: 10, width: 40, height: 40))
        editButton.setTitle("新增", for: UIControlState())
        editButton.setTitleColor(UIColor.black, for: .normal)
        editButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        detailView!.addSubview(editButton)
        self.detailView!.addSubview(self.textView)
        self.detailView!.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.textView.frame = CGRect(x: 0, y: 60, width: kScreenWidth, height: kScreenHeight - 80)
        }) 
        self.detailView?.frame = CGRect(x: 0, y: 20, width: kScreenWidth, height: kScreenHeight - 20)
   }
    /**
        修改选中内容
    */
    func updateButtonClick(){
      
        if currentRow > -1 && self.textView.text != "" && self.textView.text != self.array[currentRow] as? String {
            self.array[currentRow] = self.textView.text
            let indexPath = IndexPath.init(row: currentRow, section: 0)
            let indexPathArr = NSArray.init(object: indexPath)
            self.tableView.reloadRows(at: indexPathArr as! [IndexPath], with: .none)
            
            array.write(toFile: self.readPlist(), atomically: true)
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
         UIView.animate(withDuration: 0.5, animations: {
            self.textView.frame = CGRect(x: 10, y: 60, width: kScreenWidth - 20, height: 100)
            self.view.addSubview(self.textView)

            }, completion: { (true) in
            
                self.textView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }) 

        self.detailView?.removeFromSuperview()
        self.detailView?.isHidden = true
    
    }
    /**
        键盘改变事件
     */
    func keyboardWillChange(_ info: Notification){
      
        if (self.detailView?.isHidden == true) || (self.detailView == nil){
         
         if info.name == NSNotification.Name.UIKeyboardWillHide {
            self.dataDetector()
         }
            return
        }
        
        let keyboardinfo = (info as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey]
        
        let keyboardheight:CGFloat = ((keyboardinfo as AnyObject).cgRectValue.size.height)
        
        if info.name == NSNotification.Name.UIKeyboardWillShow {
            UIView.animate(withDuration: 0.25, animations: {
                self.textView.frame = CGRect(x: 0, y: 60, width: kScreenWidth, height: kScreenHeight - keyboardheight - 80)
            }) 
            
        }else if info.name == NSNotification.Name.UIKeyboardWillHide {
        
         UIView.animate(withDuration: 0.25, animations: {
            self.textView.frame = CGRect(x: 0, y: 60, width: kScreenWidth, height: kScreenHeight - 80)

            }, completion: { (true) in
               self.dataDetector()
         })
         
        }
    }
    /**
        特殊字符事件
    */
    func dataDetector(){
      self.textView.isEditable = false
      self.textView.dataDetectorTypes = UIDataDetectorTypes.all
      self.textView.isSelectable = true
   
   }
    /**
        读取文件目录
     */
    func readPlist() -> String{
    
        let home = NSHomeDirectory()
        let filepath = home + "/Documents/file.plist"
        return filepath;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

