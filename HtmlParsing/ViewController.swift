//
//  ViewController.swift
//  HtmlParsing
//
//  Created by Lovish Dogra on 10/05/17.
//  Copyright © 2017 Lovish Dogra. All rights reserved.
//

import UIKit
import Kanna
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//MARK: Variables
    var shows : [String] = []
    
//MARK: IBOutlets & IBActions
    @IBOutlet weak var dataTableView: UITableView!
    
    
//MARK: Load cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dataTableView.dataSource = self
        dataTableView.delegate = self
        self.scrapWebsite()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

//MARK: Func for parsing the HTML
    func scrapWebsite() {
        Alamofire.request("http://nycmetalscene.com").responseString { (response) in
            print("\(response.result.isSuccess)")
            if let html = response.result.value{
                self.parseHTML(html:html)
            }
        }
    }
    
    func parseHTML(html: String) -> Void {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            // Search for nodes by CSS selector
            for show in doc.css("td[id^='Text']") {
                
                // Strip the string of surrounding whitespace.
                let showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                // All text involving shows on this page currently start with the weekday.
                // Weekday formatting is inconsistent, but the first three letters are always there.
                let regex = try! NSRegularExpression(pattern: "^(mon|tue|wed|thu|fri|sat|sun)", options: [.caseInsensitive])
                
                if regex.firstMatch(in: showString, options: [], range: NSMakeRange(0, showString.characters.count)) != nil {
                    shows.append(showString)
                    print("\(showString)\n")
                }
            }
        }
        self.dataTableView.reloadData()
    }
}

extension ViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "data", for: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = shows[row]
        
        return cell
    }
    
}
























