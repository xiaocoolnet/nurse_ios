//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  JSONJoy.swift
//
//  Created by Dalton Cherry on 9/17/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class JSONDecoder {
    var value: AnyObject?
    
    ///return the value raw
    open var rawValue: AnyObject? {
        return value
    }
    ///print the description of the JSONDecoder
    open var description: String {
        return self.print()
    }
    ///convert the value to a String
    open var string: String? {
        return value as? String
        
//        var str = value as? String
//        str = str?.stringByReplacingOccurrencesOfString("&quot;", withString: "\"")
//        str = str?.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
//        str = str?.stringByReplacingOccurrencesOfString("&lt;", withString: "<")
//        str = str?.stringByReplacingOccurrencesOfString("&gt;", withString: ">")
//        str = str?.stringByReplacingOccurrencesOfString("&nbsp;", withString: " ")
//        return str
    }
    ///convert the value to an Int
    open var integer: Int? {
        return value as? Int
    }
    ///convert the value to an UInt
    open var unsigned: UInt? {
        return value as? UInt
    }
    ///convert the value to a Double
    open var double: Double? {
        return value as? Double
    }
    ///convert the value to a float
    open var float: Float? {
        return value as? Float
    }
    ///convert the value to an NSNumber
    open var number: NSNumber? {
        return value as? NSNumber
    }
    ///treat the value as a bool
    open var bool: Bool {
        if let str = self.string {
            let lower = str.lowercased()
            if lower == "true" || Int(lower) > 0 {
                return true
            }
        } else if let num = self.integer {
            return num > 0
        } else if let num = self.double {
            return num > 0.99
        } else if let num = self.float {
            return num > 0.99
        }
        return false
    }
    //get  the value if it is an error
    open var error: NSError? {
        return value as? NSError
    }
    //get  the value if it is a dictionary
    open var dictionary: Dictionary<String,JSONDecoder>? {
        return value as? Dictionary<String,JSONDecoder>
    }
    //get  the value if it is an array
    open var array: Array<JSONDecoder>? {
        return value as? Array<JSONDecoder>
    }
    //pull the raw values out of an array
    open func getArray<T>(_ collect: inout Array<T>?) {
        if let array = value as? Array<JSONDecoder> {
            if collect == nil {
                collect = Array<T>()
            }
            for decoder in array {
                if let obj = decoder.value as? T {
                    collect?.append(obj)
                }
            }
        }
    }
    ///pull the raw values out of a dictionary.
    open func getDictionary<T>(_ collect: inout Dictionary<String,T>?) {
        if let dictionary = value as? Dictionary<String,JSONDecoder> {
            if collect == nil {
                collect = Dictionary<String,T>()
            }
            for (key,decoder) in dictionary {
                if let obj = decoder.value as? T {
                    collect?[key] = obj
                }
            }
        }
    }
    ///the init that converts everything to something nice
    public init(_ raw: AnyObject) {
        var rawObject: AnyObject = raw
        if let data = rawObject as? Data {
            var response: AnyObject?
            do {
                try response = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
//                try response = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                rawObject = response!
            }
            catch let error as NSError {
                value = error
                return
            }
        }
        if let array = rawObject as? NSArray {
            var collect = [JSONDecoder]()
            for val in array {
                let val2 = val as AnyObject
                collect.append(JSONDecoder(val2))
            }
            value = collect as AnyObject?
        } else if let dict = rawObject as? NSDictionary {
            var collect = Dictionary<String,JSONDecoder>()
            for (key,val) in dict {
                collect[key as! String] = JSONDecoder(val as AnyObject)
            }
            value = collect as AnyObject?
        } else {
            value = rawObject
        }
    }
    ///Array access support
    open subscript(index: Int) -> JSONDecoder {
        get {
            if let array = self.value as? NSArray {
                if array.count > index {
                    return array[index] as! JSONDecoder
                }
            }
            return JSONDecoder(createError("index: \(index) is greater than array or this is not an Array type."))
        }
    }
    ///Dictionary access support
    open subscript(key: String) -> JSONDecoder {
        get {
            if let dict = self.value as? NSDictionary {
                if let value: AnyObject = dict.value(forKey: key) as AnyObject? {
                    return value as! JSONDecoder
                }
            }
            return JSONDecoder(createError("key: \(key) does not exist or this is not a Dictionary type"))
        }
    }
    ///private method to create an error
    func createError(_ text: String) -> NSError {
        return NSError(domain: "JSONJoy", code: 1002, userInfo: [NSLocalizedDescriptionKey: text]);
    }
    
    ///print the decoder in a JSON format. Helpful for debugging.
    open func print() -> String {
        if let arr = self.array {
            var str = "["
            for decoder in arr {
                str += decoder.print() + ","
            }
            str.remove(at: str.characters.index(str.endIndex, offsetBy: -1))
            return str + "]"
        } else if let dict = self.dictionary {
            var str = "{"
            for (key, decoder) in dict {
                str += "\"\(key)\": \(decoder.print()),"
            }
            str.remove(at: str.characters.index(str.endIndex, offsetBy: -1))
            return str + "}"
        }
        if value != nil {
            if let _ = self.string {
                return "\"\(value!)\""
            } else if let _ = value as? NSNull {
                return "null"
            }
            return "\(value!)"
        }
        return ""
    }
}

///Implement this protocol on all objects you want to use JSONJoy with
public protocol JSONJoy {
    init(_ decoder: JSONDecoder)
}
