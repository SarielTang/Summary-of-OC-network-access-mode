//
//  ViewController.swift
//  SimpleWebSearch
//
//  Created by xl_bin on 15/5/9.
//  Copyright (c) 2015年 Sariel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var webView: UIWebView!
    var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let urlBaidu = "http://m.baidu.com"
        loadData(urlBaidu)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func loadData(urlStr:String){
        let url = NSURL(string: urlStr);
        let request = NSURLRequest(URL: url!);
        self.webView.loadRequest(request);
    }  
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        if(urlString.hasPrefix("http://")){
            urlString.stringByAppendingString(searchBar.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        loadData(urlString)
    }
}

