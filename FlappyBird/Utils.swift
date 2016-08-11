import Foundation
import UIKit

public extension CGFloat {
    
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    public static func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
}

public extension Int {
    
    public static func random01() -> Int {
        return Int(CGFloat.random() + 0.5)
    }
    
    public static func random02() -> Int {
        return Int(CGFloat.random(min:0, max: 2.999))
    }
    
}