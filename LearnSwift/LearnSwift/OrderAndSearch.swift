//
//  OrderAndSearch.swift
//  LearnSwift
//
//  Created by ECOOP－09 on 16/9/9.
//  Copyright © 2016年 ECOOP－09. All rights reserved.
//

import Foundation

/**
  判断字符串是否为中英文
 */
func isChineseOrEnglish(_ text : String) -> Bool {
    
        if text.isEmpty || text == "" {
            return false
        }
        
        let textRegex = "^[A-Za-z\\u4e00-\\u9fa5]{0,}$"
        
        let pred = NSPredicate.init(format: "SELF MATCHES %@",textRegex)
    
        return pred.evaluate(with: text)
    }


/**
 *  将中文数组转换为拼音数组
 */
public func turnLetter(_ chineseArr : NSArray) -> NSArray {
    if chineseArr.count == 0 {
        return NSArray.init(objects: "")
    }
    
    let letterArr = NSMutableArray()
    for i in 0..<chineseArr.count {
        let text = chineseArr[i]
        let ms = NSMutableString.init(string: String(describing: text))
        
        if CFStringTransform(ms, nil, kCFStringTransformToLatin, false) {
            //含有声调
        }
        if CFStringTransform(ms, nil, kCFStringTransformToLatin, false) {
            //不含声调
            letterArr.add(ms)
        }
        
    }
    return letterArr
}

/**
 *  中文排序方法：
 *
 *  @param array 中文（可带英文，按字母排序）数组
 *
 *  @return 排好序的数组
 */
public func letterOrderArray(_ array : NSArray) ->NSArray{

    if array.count == 0 {
        return NSArray.init(objects: "")
    }
    let letterArr = turnLetter(array)
    let letterDic = NSDictionary.init(objects: array as [AnyObject], forKeys: letterArr as! [NSCopying])
    let arr = letterArr.sortedArray(using: #selector(NSString.compare(_:)))
    let order = NSMutableArray()
    for i in 0..<arr.count {
        order.add(letterDic.object(forKey: arr[i])!)
    }
    
   return order
}

/**
 *  中英文搜索方法：
 *
 *  @param textArray 所有内容
 *  @param text  想要搜索的文本
 *
 *  @return 所有搜索的结果
 */
public func searchTextWithArray(_ textArray : NSArray, search text : String) ->(searchResult:NSArray, dictionary: NSMutableDictionary){
    if textArray.count == 0 || text == ""{
        return (NSArray(),NSMutableDictionary())
    }
    let letterArr = turnLetter(textArray)
    let letterDic = NSDictionary.init(objects: textArray as [AnyObject], forKeys: letterArr as! [NSCopying])
    let searchResult = NSMutableArray()
    
    let searchDic = NSMutableDictionary()
    var num = 0
    for i in 0..<textArray.count {
        let chineseRange = (textArray[i] as AnyObject).range(of: text , options: .caseInsensitive)
        let letterRange = (letterArr[i] as AnyObject).range(of: text, options: .caseInsensitive)
        if chineseRange.location != NSNotFound {
            searchResult.add(textArray[i])
            searchDic.setValue("\(i)", forKey: "\(num)")
            num += 1

        }else if(letterRange.location != NSNotFound){
        
        searchResult.add(letterDic.object(forKey: letterArr[i])!)
            searchDic.setValue("\(i)", forKey: "\(num)")
            num += 1

        }
        
    }
    return (searchResult,searchDic)
    
}

















