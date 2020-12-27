//
//  StrokePaths.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 25/12/20.
//

import UIKit

public class StrokePaths: NSObject, NSSecureCoding {
    public static var supportsSecureCoding = true
    
    public var paths: [StrokePath] = []
    
    enum Key: String {
        case paths = "paths"
    }
    
    init(paths: [StrokePath]) {
        self.paths = paths
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(paths, forKey: Key.paths.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mPaths = aDecoder.decodeObject(of: [NSArray.self, StrokePath.self], forKey: Key.paths.rawValue) as! [StrokePath]
        
        self.init(paths: mPaths)
    }
}
