//
//  ShoppingWebViewController.swift
//  ClothesFinder
//
//  Created by Phil John on 2/4/22.
//

import UIKit
import WebKit

class ShoppingWebViewController: UIViewController, WKUIDelegate {

    // webKit
    @IBOutlet weak var webView: WKWebView!
    var link: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let safeLink = link {
            if let safeUrl = URL(string: safeLink) {
                print(safeUrl)
                let request = URLRequest(url: safeUrl)
                webView.load(request)
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
