//
//  RootTabBarController.swift
//  diningHall
//
//  Created by Diwas  Timilsina on 7/11/15.
//  Copyright (c) 2015 Diwas  Timilsina. All rights reserved.
//

import UIKit
import Foundation

class RootTabBarController: UITabBarController {

    // for the tab index
    var dayDictionary = ["Mon": 0, "Tue": 1, "Wed": 2, "Thu": 3, "Fri": 4, "Sun": -1, "Sat": -1]
    
    //dayIndex
    var days = ["Sun": 7, "Mon":1, "Tue":2, "Wed":3, "Thu":4,"Fri":5,"Sat":6]
    
    // complete data dictionary
    // [tab_index: "Ga" :[Lunch:[....fooditems...], "Soup":[....fooditems...]], "Wick":.... ]
    var dataDictionary = [Int:[String:[String:[String]]]]()
    
    // to get data from the websites
    var urlSession: NSURLSession!
    // current date
    var date = NSDate(dateString:"2015-09-16")
    
    //for ga and wick
    var menuItemDict = [String :[String]]()
    var menuItemDict2 = [String :[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        var dateFormatter = NSDateFormatter()
        
        //Parsing the websited data
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSession = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        //passing the date to the url to get data
        dateFormatter.dateFormat = "EEE"
        var dayString = dateFormatter.stringFromDate(date)
        
        // get the next five days [Mon-Fri]
        var dayInt = dayDictionary[dayString]
        
        var countFront = dayInt!
        var countBack = dayInt!
     
        if dayString == "Sun" {
            date = getNextDate(1)
            countFront = 0
            countBack = 0
            dayInt = 0
        }else if dayString == "Sat" {
            date = getNextDate(2)
            countFront = 0
            countBack = 0
            dayInt = 0
        }
        
        var start = countFront
        
        //Format the date accordingly
        dateFormatter.dateFormat = "EEE"
        dayString = dateFormatter.stringFromDate(date)
        dateFormatter.dateFormat = "MM/dd/yy"
        var dateStringGa = dateFormatter.stringFromDate(date)
        dateFormatter.dateFormat = "yyyyMMdd"
        var dateStringWick = dateFormatter.stringFromDate(date)
        
        fetchDataFromGa(dateStringGa, selectDay: days[dayString]!)
        fetchDataFromWick(dateStringWick)
        dataDictionary[countFront] = ["GA":menuItemDict,"Wick":menuItemDict2]
        println(dataDictionary)
        countFront++
        countBack--
     
        var dummyDate: NSDate!
        
        while (countFront < 5 || countBack > -1) {
            if countBack > -1 {
                
                menuItemDict = [String :[String]]()
                menuItemDict2 = [String :[String]]()
                
                dummyDate = getNextDate((start-countBack) * -1)
                
                dateFormatter.dateFormat = "EEE"
                dayString = dateFormatter.stringFromDate(dummyDate)
                dateFormatter.dateFormat = "MM/dd/yy"
                dateStringGa = dateFormatter.stringFromDate(dummyDate)
                dateFormatter.dateFormat = "yyyyMMdd"
                dateStringWick = dateFormatter.stringFromDate(dummyDate)
                
                //fetchDataFromGa(dateStringGa, selectDay: days[dayString]!)
                //fetchDataFromWick(dateStringWick)
                dataDictionary[countFront] = ["GA":menuItemDict,"Wick":menuItemDict2]
            }
            if countFront < 5 {
                
                menuItemDict = [String :[String]]()
                menuItemDict2 = [String :[String]]()
                
                dummyDate = getNextDate(countFront-start)
                
                dateFormatter.dateFormat = "EEE"
                dayString = dateFormatter.stringFromDate(dummyDate)
                dateFormatter.dateFormat = "MM/dd/yy"
                dateStringGa = dateFormatter.stringFromDate(dummyDate)
                dateFormatter.dateFormat = "yyyyMMdd"
                dateStringWick = dateFormatter.stringFromDate(dummyDate)
                
                //fetchDataFromGa(dateStringGa, selectDay: days[dayString]!)
                //fetchDataFromWick(dateStringWick)
                
                dataDictionary[countFront] = ["GA":menuItemDict,"Wick":menuItemDict2]
                
            }
            countFront++
            countBack--
        }
        
        //println(dataDictionary)
        
        // select the tab
        if dayInt != nil {
            self.selectedIndex = dayInt!
        }
    }
    
    // function to get the next date
    func getNextDate(difference: Int) -> NSDate {
        let components: NSDateComponents = NSDateComponents()
        components.setValue(difference, forComponent: NSCalendarUnit.CalendarUnitDay);
        let nextDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))
        return nextDate!
    }
    
    // MARK: Scraping for Schools
    
    // Fetch the html section with the menu in it
    // from the website and pass it
    func fetchDataFromGa(dateString:String, selectDay:Int){
        var parsedMenu = " "
        //*[@id="table_calendar_week"]/tbody/tr
        if selectDay < 6 {
            let urlBase = "http://www.myschooldining.com/ga/?cmd=menus"
            var urlString = urlBase+String(dateString)
            var url = NSURL(string: urlString)
            let dataTask = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error in
                if error != nil {
                    println("Error in Connection! Check your Internet Connection!")
                } else {
                    println("Ga url fetched")
                    var menuDict = [String:[String]]()
                    var parser = TFHpple(HTMLData: data)
                    //var queryName = "/html/body//div[6]/div[2]"
                    //*[@id="greenwichacademy_schoolclosed"]/span/span
                    var queryName = "//*[@id='content_2015-09-15']"
                    //*[@id="content_2015-09-15"]
                    //*[@id="greenwichacademy_lunch_soup_pastafagioli"]/span
                    //*[@id="greenwichacademy_lunch_soup"]/span
                    //*[@id="91515"]
                    //*[@id="flik_calendar_week"]
                    ///html/body/div[6]
                    //*[@id="table_calendar_week"]/tbody/tr
                    //var queryName = "/html/body//div[1]/div[2]/fieldset/table[1]/tr[3]/td[\(selectDay)]"
                    //var queryName = "/html/body//div[1]/div[2]/fieldset/table[1]"
                    var foundNamesArray = parser.searchWithXPathQuery(queryName) as! [TFHppleElement]
                    println( " length is \(foundNamesArray.count)")
                    for node in foundNamesArray{
                        let textData = node.content.stringByTrimmingLeadingAndTrailingWhitespace()
                        //let separators = NSCharacterSet(charactersInString: "\t\n")
                        //var words = textData.stringByTrimmingLeadingAndTrailingWhitespace().componentsSeparatedByCharactersInSet    (separators)
                        println(textData)
//                        for word in words{
//                            if count(word) > 0 {
//                                println(word)
//                                parsedMenu = parsedMenu + word + "\n"
//                            }
//                        }
                        
                    }
                }
                self.parseMenuDaily(parsedMenu)
            })
            dataTask.resume()
        } else {
            parsedMenu = "School Closed"
        }
        println(parsedMenu)
    }
    
    
    // fetch data from wick website
    func fetchDataFromWick(dateString:String){
        // wick
        let urlBase = "http://my.brunswickschool.org/Page/Calendars/Dining-Hall-Calendar?sDate="
        var urlString = urlBase+String(dateString)
        var url = NSURL(string: urlString)
        let dataTask = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error in
            if error != nil {
                println("Error in Connection! Check your Internet Connection!")
            } else {
                //println(data)
                var parser = TFHpple(HTMLData: data)
                // var queryName = ""
                //*[@id="content_324328"]/div/div/ul/li/div/div
                //*[@id="content_324328"]/div/div/ul/li/div
                var queryName = "//li[@class='group date-break']//div[@class='event-detail left non-athletic-event']"
                var foundNamesArray = parser.searchWithXPathQuery(queryName) as! [TFHppleElement]
                
                self.parseMenu(foundNamesArray)
                //println(foundNamesArray)
            }
        })
        
        dataTask.resume()
    }
    
    
    // get's section with the menu as an array,
    // passes it to parseTitle and ParseMenuList to
    // parse title and Menu List respectively
    func parseMenu(fetchedData: [TFHppleElement]){
        if (fetchedData.count) > 0 {
            for node in fetchedData {
                let lunchTitleChild = node.children[1] as! TFHppleElement
                parseTitle(lunchTitleChild)
                let lunchMenuChild = node.children[5] as! TFHppleElement
                parseMenuList(lunchMenuChild)
            }
        }else {
            println("NO EVENT")
        }
    }
    
    // parse Title of the menu
    func parseTitle(data: TFHppleElement) {
        //println(data.firstChild.content)
    }
    
    // parse food items in the Menu
    func parseMenuList(data: TFHppleElement){
        var menu:String = data.firstChild.content
        let separators = NSCharacterSet(charactersInString: "\n")
        var words = menu.componentsSeparatedByCharactersInSet(separators)
        var lunchIndex = words.indexesOf("Lunch")
        
        // for Lunch
        var index:Int = 0
        if (lunchIndex != -1) {
            index = lunchIndex + 1
            var lunchList = [String]()
            while index < words.count {
                if (count(words[index]) > 0) {
                    lunchList.append(words[index])
                }
                index++
            }
            menuItemDict2["Lunch Menu"] = lunchList
        }
        //menuItemDictKeys2 = menuItemDict2.keys.array
        //tableViewWick.reloadData()
    }
    
    
    //parsed individual day for Greenwich school
    func parseMenuDaily(fetchedData:String){
        let separators = NSCharacterSet(charactersInString: "\n")
        var words = fetchedData.componentsSeparatedByCharactersInSet(separators)
        var soupIndex = words.indexesOf("Soups")
        var entreeIndex = words.indexesOf("Entree")
        var sideIndex = words.indexesOf("Sides")
        
        // for soups
        var index:Int = 0
        if (soupIndex != -1) {
            index = soupIndex + 1
            var soupList = [String]()
            while index < entreeIndex {
                if (count(words[index]) > 0) {
                    let separators = SwiftRegEx(initWithPattern:"»")
                    if let word = separators?.replace(words[index], with: ""){
                        soupList.append(word)
                    }
                }
                index++
            }
            menuItemDict["Soups"] = soupList
        }
        
        // for entree
        if (entreeIndex != -1) {
            index = entreeIndex + 1
            var entreeList = [String]()
            while index < sideIndex {
                if (count(words[index]) > 0) {
                    let separators = SwiftRegEx(initWithPattern:"»")
                    if let word = separators?.replace(words[index], with: ""){
                        entreeList.append(word)
                    }
                }
                index++
            }
            menuItemDict["Entree"] = entreeList
        }
        
        
        // for side
        if (sideIndex != -1) {
            index = sideIndex + 1
            var sideList = [String]()
            while index < words.count {
                if (count(words[index]) > 0) {
                    let separators = SwiftRegEx(initWithPattern:"»")
                    if let word = separators?.replace(words[index], with: ""){
                        sideList.append(word)
                    }
                }
                index++
            }
            menuItemDict["Sides"] = sideList
        }
        println(menuItemDict)
    }
    
}
