//
//  StringParser.swift
//  StringParser
//
//  Created by Diwas  Timilsina on 7/19/15.
//  Copyright (c) 2015 Diwas  Timilsina. All rights reserved.
//

import Foundation
import UIKit

/*
 * SwiftRegEx is a simple wrapper library for the NSRegularExpression Class
 * The following are the supported functions:
 *
 *
 *  - isMatch("string") to check if the string matches the regex
 *  - getIndex("string") to check of the string that matches the regex
 *  - split("delimeter") to split the given string based on given delimeter
 *  - replace("inputString", "replaceString") to replace strings in inputString with replaceString based on the regex pattern
 * - replace("inputString", block) to replace strings in inputString using block based on the regex pattern
 * - match("inputString") to return an array of strings that match the regex in the inputString
 * - firstMatch("inputString") to return the first string in inputString that matches the regex in the inputString
 *
*/

class SwiftRegEx: NSRegularExpression {
 
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // initialize SwiftRegEx from a string
    // var regEx = SwiftRegEx(pattern: "\d+")
    init?(initWithPattern pattern: String){
        super.init(pattern: pattern, options: NSRegularExpressionOptions(0), error: nil)
    }
    
    // initialize swiftRegEx object from a string.
    // if caseSensative switch can also be changed with this initializer
    init?(initWithPattern pattern:String, caseSensative: Bool){
        super.init(pattern:pattern, options: caseSensative ? NSRegularExpressionOptions(0): NSRegularExpressionOptions.CaseInsensitive, error: nil)
    }
    
    //initialize swiftRegEx object from a string and option
    init?(initWithPattern pattern:String, options: NSRegularExpressionOptions){
        super.init(pattern:pattern, options: options, error: nil)
    }

    //return true if the string matches the regex
    func isMatch(matchExpression: String) -> Bool {
      return self.numberOfMatchesInString(matchExpression, options: NSMatchingOptions(0), range: NSMakeRange(0, count(matchExpression))) > 0
    }
    
    //get the index of the string that matches the regex pattern
    func getIndex(matchString: String) -> Int {
        let range: NSRange = self.rangeOfFirstMatchInString(matchString, options: NSMatchingOptions(0), range: NSMakeRange(0, count(matchString)))
        return range.location == NSNotFound ? -1: range.location
    }
    
  
    //split the given string using the regular expression delimeters
    func split(inputString: String) -> [String] {
        let inputStringNSString = inputString as NSString
        let all = NSRange(location: 0, length: inputStringNSString.length)
        var matches = self.matchesInString(inputString, options: NSMatchingOptions(0), range: all)
        var matchResults = [String]()
        for match in matches {
            var result = match as! NSTextCheckingResult
            matchResults.append(inputStringNSString.substringWithRange(result.range))
        }
        return matchResults
    }
    
    //replace string with another string
    func replace(inputString:String, with replaceString:String)-> String {
        return self.stringByReplacingMatchesInString(inputString, options: NSMatchingOptions(0), range: NSRange(location: 0,length: count(inputString)), withTemplate: replaceString)
    }
    
   //replace string by passing in a block
    func replace(inputString: String, withBlock replacer: String -> String) -> String {
        var strCpy: NSMutableString = inputString.mutableCopy() as! NSMutableString
        let inputStringNSString = inputString as NSString
        let all = NSRange(location: 0, length: inputStringNSString.length)
        let matches = self.matchesInString(inputString, options: NSMatchingOptions(0), range: all)
        for match in matches {
            let result = match as! NSTextCheckingResult
            let matchString:NSString = inputStringNSString.substringWithRange(result.range)
            let replaceString: String = replacer(matchString as String)
            strCpy.replaceCharactersInRange(result.range, withString: replaceString)
        }
        return strCpy as String
    }
    
    //return an array of matched strings
    func matches(inputString: String) -> [String]{
        var matches = [String]()
        let inputStringNSString = inputString as NSString
        let all = NSRange(location: 0, length: inputStringNSString.length)
        let results = self.matchesInString(inputString, options: NSMatchingOptions(0), range: all)
        for result in results{
            let res = result as! NSTextCheckingResult
            let match = inputStringNSString.substringWithRange(res.range)
            matches.append(match)
        }
        return matches
    }
    
    //return the first match of the given string
    func firstMatch(inputString: String) -> String {
        let inputStringNSString = inputString as NSString
        let all = NSRange(location: 0, length: inputStringNSString.length)
        let match: NSTextCheckingResult = self.firstMatchInString(inputString, options: NSMatchingOptions(0), range: all)!
        return inputStringNSString.substringWithRange(match.range)
    }
}