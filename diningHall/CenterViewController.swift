//
//  ViewController.swift
//  diningHall
//
//  Created by Diwas  Timilsina on 6/29/15.
//  Copyright (c) 2015 Diwas  Timilsina. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var mealSelection: UISegmentedControl!
    @IBOutlet weak var schoolSelection: UISegmentedControl!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    
    var days = ["Sunday": 7, "Monday":1, "Tuesday":2, "Wednesday":3, "Thursday":4,"Friday":5,"Saturday":6]
    
    var menuItemDict = [String :[String]]()
    var menuItemDictKeys = [String]()
    var urlSession: NSURLSession!
    var currentDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
            self.menuTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "listMenuCell")
            
            //self.addGroup.delegate = self
            //tableView.delegate = self
            //tableView.dataSource = self
            menuTableView.delegate = self
            menuTableView.dataSource = self
            
            //Parsing the websited data
            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            urlSession = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
            
            //passing the date to the url to get data
            var dateFormatter = NSDateFormatter()
            if schoolSelection.selectedSegmentIndex == 0 {
                dateFormatter.dateFormat = "MM/dd/yy"
            }else{
                dateFormatter.dateFormat = "yyyyMMdd"
            }
            
            var dateString = dateFormatter.stringFromDate(currentDate)
            println(dateString)
            dateFormatter.dateFormat = "EEEE"
            var dayString = dateFormatter.stringFromDate(currentDate)
            schoolSelection.addTarget(self, action:"schoolChanged:" , forControlEvents: .ValueChanged)
            //fetchDataFromSchool(dateString,selectDay: days[dayString]!)
            fetchDataFromSchool("5/26/15",selectDay: 2)
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return menuItemDictKeys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var sectionValue = menuItemDictKeys[section]
        return menuItemDict[sectionValue]!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menuItemDictKeys[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listMenuCell", forIndexPath: indexPath) as! UITableViewCell
        var sectionKey:String = menuItemDictKeys[indexPath.section]
        var sectionValues:[String] = menuItemDict[sectionKey]!
        cell.textLabel?.text = sectionValues[indexPath.row]
        println("returning cell")
        
        return cell
    }
    
    
    
    // MARK: Scraping for Schools
    
    // Fetch the html section with the menu in it
    // from the website and pass it
    func fetchDataFromSchool(dateString:String, selectDay:Int){
        
        if schoolSelection.selectedSegmentIndex == 0 {
            var parsedMenu = " "
            if selectDay < 6 {
                let urlBase = "http://www.myschooldining.com/ga/?cmd=menus&currDT="
                var urlString = urlBase+String(dateString)
                var url = NSURL(string: urlString)
                
                let dataTask = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error in
                    if error != nil {
                        println("Error in Connection! Check your Internet Connection!")
                    } else {
                        
                        var menuDict = [String:[String]]()
                        var parser = TFHpple(HTMLData: data)
                        var queryName = "/html/body//div[1]/div[2]/fieldset/table[1]/tr[3]/td[\(selectDay)]"
                        var foundNamesArray = parser.searchWithXPathQuery(queryName) as! [TFHppleElement]
                        for node in foundNamesArray{
                            let textData = node.content.stringByTrimmingLeadingAndTrailingWhitespace()
                            let separators = NSCharacterSet(charactersInString: "\t\n")
                            var words = textData.stringByTrimmingLeadingAndTrailingWhitespace().componentsSeparatedByCharactersInSet    (separators)
                            for word in words{
                                if count(word) > 0 {
                                    parsedMenu = parsedMenu + word + "\n"
                                }
                            }
                            
                        }
                    }
                    self.parseMenuDaily(parsedMenu)
                })
                dataTask.resume()
            } else {
                parsedMenu = "School Closed"
            }
            println(parsedMenu)
            
        } else {
            print("found")
            let urlBase = "http://my.brunswickschool.org/Page/Calendars/Dining-Hall-Calendar?sDate="
            var urlString = urlBase+String(dateString)
            var url = NSURL(string: urlString)
            
            
            let dataTask = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error in
                if error != nil {
                    println("Error in Connection! Check your Internet Connection!")
                } else {
                    //println(data)
                    var parser = TFHpple(HTMLData: data)
                    var queryName = "//li[@class='group date-break']//div[@class='event-detail left non-athletic-event']"
                    var foundNamesArray = parser.searchWithXPathQuery(queryName) as! [TFHppleElement]
                    self.parseMenu(foundNamesArray)
                }
            })
            
            dataTask.resume()
            
        }
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
        println(data.firstChild.content)
    }
    
    // parse food items in the Menu
    func parseMenuList(data: TFHppleElement){
        println(data.firstChild.content)
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
                    soupList.append(words[index])
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
                    entreeList.append(words[index])
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
                    sideList.append(words[index])
                }
                index++
            }
            menuItemDict["Sides"] = sideList
        }
        
        menuItemDictKeys = menuItemDict.keys.array
        menuTableView.reloadData()
    }
    
    
    
    //
    //    //MARK : Scraping for School A
    //
    //    func fetchDataFromSchoolA(dateString:String) {
    //
    //        let urlBase = "http://www.myschooldining.com/ga/?cmd=menus&currDT="
    //        var urlString = urlBase+String(dateString)
    //        var url = NSURL(string: urlString)
    //
    //        let dataTask = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error in
    //            if error != nil {
    //                println("Error in Connection! Check your Internet Connection!")
    //            } else {
    //
    //                var menuDict = [String:[String]]()
    //                var parser = TFHpple(HTMLData: data)
    //                for i in 1..<6 {
    //                    var queryName = "/html/body//div[1]/div[2]/fieldset/table[1]/tr[3]/td[\(i)]"
    //                    var foundNamesArray = parser.searchWithXPathQuery(queryName) as! [TFHppleElement]
    //                    for node in foundNamesArray{
    //                        let textData = node.content.stringByTrimmingLeadingAndTrailingWhitespace()
    //                        let separators = NSCharacterSet(charactersInString: "\t\n")
    //                        var words = textData.stringByTrimmingLeadingAndTrailingWhitespace().componentsSeparatedByCharactersInSet(separators)
    //                        var parsedMenu = " "
    //                        for word in words{
    //                            if count(word) > 0 {
    //                                parsedMenu = parsedMenu + word + "\n"
    //                            }
    //                        }
    //                        print(parsedMenu)
    //                    }
    //                }
    //            }
    //        })
    //        dataTask.resume()
    //    }
    //

    
    func schoolChanged(selectSchool: UISegmentedControl){
        var dateFormatter = NSDateFormatter()
        // School A (GreenWitch school)
        if schoolSelection.selectedSegmentIndex == 0 {
            dateFormatter.dateFormat = "MM/dd/yy"
        }else{ // School B (Brunswick school)
            dateFormatter.dateFormat = "yyyyMMdd"
        }
        
        var dateString = dateFormatter.stringFromDate(currentDate)
        println(dateString)
        dateFormatter.dateFormat = "EEEE"
        var dayString = dateFormatter.stringFromDate(currentDate)
        //fetchDataFromSchool(dateString,selectDay: days[dayString]!)
    }

    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

}


    


