//
//  WebViewController.swift
//  SunBlocker
//
//  Created by Ricardo Fernandez on 2/3/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: URL(string: "https://www.skincancer.org/skin-cancer-prevention/sun-protection/sunscreen/")!))
        
        }
        
        
    }
    
    

