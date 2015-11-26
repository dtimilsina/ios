//
//  MainViewController.swift
//  diningHall
//
//  Created by Diwas  Timilsina on 7/11/15.
//  Copyright (c) 2015 Diwas  Timilsina. All rights reserved.
//

import UIKit
import QuartzCore

var keyPopoverViewController: WYPopoverController!
var likePopoverViewController: WYPopoverController!
var searchPopoverViewController: WYPopoverController!

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WYPopoverControllerDelegate{

    // table view for both schools
    @IBOutlet weak var tableViewWick: UITableView!
    @IBOutlet weak var tableViewGA: UITableView!
    
    var currentDate = NSDate(dateString: "2015-05-26")
    
    //dayIndex
    var days = ["Sunday": 7, "Monday":1, "Tuesday":2, "Wednesday":3, "Thursday":4,"Friday":5,"Saturday":6]
    
    // day index dictionary
    var dayDictionary = ["Monday": 0, "Tuesday": 1, "Wednesday": 2, "Thurday": 3, "Friday": 4]
    
    var menuItemDict = [String :[String]]()
    var menuItemDict2 = [String :[String]]()
    var menuItemDictKeys = [String]()
    var menuItemDictKeys2 = [String]()
    var urlSession: NSURLSession!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var keyButton = UIBarButtonItem(image: UIImage(named:"key"), style: .Plain, target: self, action: "keyButtonPressed:")
        var likeButton = UIBarButtonItem(image: UIImage(named:"like"), style: .Plain, target: self, action: "likeButtonPressed:")
        
        // Set 26px of fixed space between the two UIBarButtonItems
        var fixedSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        fixedSpace.width = 0.0
        
        // Set -7px of fixed space before the two UIBarButtonItems so that they are aligned to the edge
        var negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpace.width = 10.0
     
        var myButtons:[NSObject] = NSArray(arrayLiteral: negativeSpace,likeButton ,fixedSpace, keyButton) as! [UIBarButtonItem]
        self.navigationItem.rightBarButtonItems = myButtons
        
        // setup tableview
        tableViewGA.delegate = self
        tableViewGA.dataSource = self
        tableViewWick.delegate = self
        tableViewWick.dataSource = self
        
    
        // add line
        var lineView = UIView(frame: CGRectMake(10,338,350,1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.blackColor().CGColor
        self.view.addSubview(lineView)
        
        
        //Parsing the websited data
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSession = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        //passing the date to the url to get data
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        var dayString = dateFormatter.stringFromDate(NSDate(dateString: "2015-05-24"))
        
        dateFormatter.dateFormat = "MM/dd/yy"
        var dateStringGa = dateFormatter.stringFromDate(currentDate)

        dateFormatter.dateFormat = "yyyyMMdd"
        var dateStringWick = dateFormatter.stringFromDate(currentDate)
        
        fetchDataFromGa(dateStringGa, selectDay: 3)
        //fetchDataFromGa(dateStringGa, selectDay: days[dayString]!)
        fetchDataFromWick("20150806", selectDay: 1)
        //fetchDataFromWick(dateStringWick, selectDay: "20150806")
    }

    func keyButtonPressed(sender: UIBarButtonItem!){
        performSegueWithIdentifier("keyPopoverSegue", sender: sender)
    }

    
    func likeButtonPressed(sender: UIBarButtonItem!){
        performSegueWithIdentifier("likePopoverSegue", sender: sender)
    }
    
    
    @IBAction func searchButtonTap(sender: AnyObject) {
        performSegueWithIdentifier("searchPopoverSegue", sender: sender)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var selectedIndex = self.tabBarController?.selectedIndex
        var difference = 0
        
        var date = NSDate(dateString:"2015-05-26")
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE"
        var dayString = dateFormatter.stringFromDate(date)
        
        var dayInt = dayDictionary[dayString]
        if dayInt != nil {
            difference = dayInt! - selectedIndex!
        }

        currentDate = getNextDate(difference)
    }
    
    // function to get the next date
    func getNextDate(difference: Int) -> NSDate {
        let components: NSDateComponents = NSDateComponents()
        components.setValue(difference, forComponent: NSCalendarUnit.CalendarUnitDay);
        let date: NSDate = NSDate()
        let nextDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))
        return nextDate!
    }

    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (tableView == tableViewGA) {
            return menuItemDictKeys.count
        } else {
            return menuItemDictKeys2.count
        }
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        //return menuItemDictKeys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
            //var sectionValue = menuItemDictKeys[section]
        //return menuItemDict[sectionValue]!.count
        if (tableView == tableViewGA) {
            var sectionValue = menuItemDictKeys[section]
            return menuItemDict[sectionValue]!.count
        } else {
            var sectionValue = menuItemDictKeys2[section]
            return menuItemDict2[sectionValue]!.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return menuItemDictKeys[section]
        if (tableView == tableViewGA) {
            return menuItemDictKeys[section]
        } else {
            return menuItemDictKeys2[section]        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        if (tableView == tableViewGA) {
            cell = tableView.dequeueReusableCellWithIdentifier("ga_cell", forIndexPath: indexPath) as! UITableViewCell
            var sectionKey:String = menuItemDictKeys[indexPath.section]
            var sectionValues:[String] = menuItemDict[sectionKey]!
            cell.textLabel?.text = sectionValues[indexPath.row]
            //println("returning cell")
            
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("wick_cell", forIndexPath: indexPath) as! UITableViewCell
            var sectionKey:String = menuItemDictKeys2[indexPath.section]
            var sectionValues:[String] = menuItemDict2[sectionKey]!
            cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.text = sectionValues[indexPath.row]
        }
        
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (tableView == tableViewGA) {
            var sectionKey:String = menuItemDictKeys[indexPath.section]
            var sectionValues:[String] = menuItemDict[sectionKey]!
            let value: String = sectionValues[indexPath.row]
            if count(value) < 30{
                return 45
            }else{
                return 65
            }
        }
            var sectionKey:String = menuItemDictKeys2[indexPath.section]
            var sectionValues:[String] = menuItemDict2[sectionKey]!
            let value: String = sectionValues[indexPath.row]
            if count(value) < 30{
                return 45
            }else{
                return 65
            }
    }
    
    
    // MARK: Scraping for Schools
    
    // Fetch the html section with the menu in it
    // from the website and pass it
    func fetchDataFromGa(dateString:String, selectDay:Int){
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
                    //var queryName = "/html/body//div[1]/div[2]/fieldset/table[1]"
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
    }
    
    
    // fetch data from wick website
    func fetchDataFromWick(dateString:String, selectDay:Int){
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
        menuItemDictKeys2 = menuItemDict2.keys.array
        tableViewWick.reloadData()
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
        
        menuItemDictKeys = menuItemDict.keys.array
        tableViewGA.reloadData()
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "keyPopoverSegue" {
          
            var popoverSegue: WYStoryboardPopoverSegue = segue as! WYStoryboardPopoverSegue
            keyPopoverViewController = popoverSegue.popoverControllerWithSender(sender, permittedArrowDirections: WYPopoverArrowDirection() , animated: true)
            keyPopoverViewController.delegate = self
            
        }
        if (segue.identifier == "likePopoverSegue") {
            
            var popoverSegue: WYStoryboardPopoverSegue = segue as! WYStoryboardPopoverSegue
            likePopoverViewController = popoverSegue.popoverControllerWithSender(sender, permittedArrowDirections: WYPopoverArrowDirection() , animated: true)
            likePopoverViewController.delegate = self
            
        }
        
        if (segue.identifier == "searchPopoverSegue") {
            var popoverSegue: WYStoryboardPopoverSegue = segue as! WYStoryboardPopoverSegue
            searchPopoverViewController = popoverSegue.popoverControllerWithSender(sender, permittedArrowDirections: WYPopoverArrowDirection() , animated: true)
            searchPopoverViewController.delegate = self
        }
        
        
    }

    
    func popoverControllerDidPresentPopover(controller: WYPopoverController) {
        //println("popoverControllerDidPresentPopover")
    }
    
    func popoverControllerShouldDismissPopover(controller: WYPopoverController) -> Bool {
        return true
    }
    
    func popoverControllerDidDismissPopover(controller: WYPopoverController) {
    
        if keyPopoverViewController != nil {
            if controller == keyPopoverViewController {
                keyPopoverViewController.delegate = nil
                keyPopoverViewController = nil
            }
        }
        
        if likePopoverViewController != nil {
            if (controller == likePopoverViewController) {
                likePopoverViewController.delegate = nil
                likePopoverViewController = nil
            }
        }
        
        if searchPopoverViewController != nil {
            if (controller == searchPopoverViewController) {
                searchPopoverViewController.delegate = nil
                searchPopoverViewController = nil
            }
        }
    }
    
    func popoverControllerShouldIgnoreKeyboardBounds(popoverController: WYPopoverController) -> Bool {
        return true
    }
}
