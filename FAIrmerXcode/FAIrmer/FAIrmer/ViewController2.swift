//
//  ViewController2.swift
//  FAIrmer
//
//  Created by Harshith Sadhu on 10/21/23.
//

import UIKit
import WebKit

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://appapp-m7ydoonpd6j4jzvtolajz9.streamlit.app/") {
                let request = URLRequest(url: url)
            webView.loadRequest(request)
            }
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var webView: UIWebView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
