//
//  AnnotationAttributeTransformer.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 26/12/20.
//

import UIKit

class AnnotationAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        [Paths.self]
    }
    
    static func register() {
        let className = String(describing: AnnotationAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = AnnotationAttributeTransformer()
        
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
