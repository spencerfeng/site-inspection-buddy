//
//  Path.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 25/12/20.
//

import UIKit

public class Path: NSObject, NSSecureCoding {
    public static var supportsSecureCoding = true
    
    let strokeColor: UIColor
    var points: [CGPoint]
    
    enum Key: String {
        case strokeColor = "strokeColor"
        case points = "points"
    }
    
    init(strokeColor: UIColor, points: [CGPoint]) {
        self.strokeColor = strokeColor
        self.points = points
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mStrokeColor = aDecoder.decodeObject(of: UIColor.self, forKey: Key.strokeColor.rawValue)!
        let mPointsStrArr = aDecoder.decodeObject(of: NSArray.self, forKey: Key.points.rawValue) as! [String]
        
        let mPoints = mPointsStrArr.map { NSCoder.cgPoint(for: $0) }
        
        self.init(strokeColor: mStrokeColor, points: mPoints)
    }
    
    public func encode(with aCoder: NSCoder) {
        let pointsStrArr = points.map { NSCoder.string(for: $0) }
        
        aCoder.encode(strokeColor, forKey: Key.strokeColor.rawValue)
        aCoder.encode(pointsStrArr, forKey: Key.points.rawValue)
    }
}
