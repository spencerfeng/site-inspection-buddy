//
//  Paths.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 25/12/20.
//

import UIKit

public class Paths: NSObject, NSCoding {
    public var paths: [Path] = []
    
    enum Key: String {
        case paths = "paths"
    }
    
    init(paths: [Path]) {
        self.paths = paths
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(paths, forKey: Key.paths.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mPaths = aDecoder.decodeObject(forKey: Key.paths.rawValue) as! [Path]
        
        self.init(paths: mPaths)
    }
}
