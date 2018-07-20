//
//  DataManager.swift
//  ProblemStatement-1
//
//  Created by snehal_lalwani on 20/07/18.
//  Copyright © 2018 snehal_lalwani. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    func makeDataModel(_ responseDict : NSDictionary) ->  NSMutableArray
    {
        let appArray : NSMutableArray = NSMutableArray()
        
        if (responseDict.object(forKey: "feed") != nil)
        {
            let feedDict = responseDict.object(forKey: "feed") as! NSDictionary
            
            if (feedDict.object(forKey: "results") != nil)
            {
                let resutArray = feedDict.object(forKey: "results") as! NSArray
                
                for dict in resutArray
                {
                    let resultObj = dict as! NSDictionary
                    
                    let appObj : AppObject = AppObject()
                    
                    if let artistName = resultObj["artistName"] as? String {
                        appObj.artistName = artistName
                    }
                    
                    if let kind = resultObj["kind"] as? String {
                        appObj.kind = kind
                    }
                    
                    if let artworkUrl100 = resultObj["artworkUrl100"] as? String {
                        appObj.artworkUrl100 = artworkUrl100
                    }
                    
                    appArray.add(appObj)
                }
                
            }
        }
        
        return appArray;
    }
}

