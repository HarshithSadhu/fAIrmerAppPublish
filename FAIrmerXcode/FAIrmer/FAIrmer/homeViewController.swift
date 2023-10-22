//
//  homeViewController.swift
//  FAIrmer
//
//  Created by Harshith Sadhu on 10/22/23.
//

import UIKit

class homeViewController: UIViewController {
    
    struct Crop: Codable {
        var acres: String
        var consumerID: String
        var crop: String
        var expectedRevenuePerYear: String
    }
    
    struct JSONContainer: Codable {
        var cropData: [Crop]
    }

    var newRegionID : Int = 0
    var newAcres : String = ""
    let deviceID = UIDevice.current.identifierForVendor?.uuidString
    var cropData : [Crop] = []

    @IBOutlet weak var ROILBL: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var growthLbl: UILabel!
    @IBOutlet weak var yieldLbl: UILabel!
    @IBOutlet weak var cropName: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var imgView: UIImageView!
    
    var index = 0
    var prices = [2.20, 1.20, 1.50, 9.80, 6.40]
    var yield = [25, 35, 15, 85, 67]
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveUserPreferences()
        if let url = URL(string: "https://app2-wxzm2y6jsx7nqzenvekqkz.streamlit.app/") {
                let request = URLRequest(url: url)
            webView.loadRequest(request)
            }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Code to be executed after a one-second delay
            print("One second has passed!")
        }
        
        updateFields()

        // Do any additional setup after loading the view.
    }
    
    // Retrieve acres and regionID from UserDefaults
    func retrieveUserPreferences() {
        let userDefaults = UserDefaults.standard
        if let acres = userDefaults.string(forKey: "acres") {
            newAcres = acres
        }
        sendPostRequest(regionID: 1, acres: Int(newAcres)!)
//        if let regionID = userDefaults.integer(forKey: "regionID") {
//            newRegionID = regionID
//        }
    }

    
    func updateFields(){
        cropName.text = cropData[index].crop
        
        var newName : String = cropData[index].crop + ".jpg"
        print(newName)
        imgView.image = UIImage(named: newName)
        
        imgView.layer.cornerRadius = 10
        
        growthLbl.text = "+$" +  cropData[index].expectedRevenuePerYear + " revenue this year"
        
        priceLbl.text = "$" + String(prices[index]) + " per crop"
        
        yieldLbl.text = "Expected to return " + String(yield[index]) + "% yield"
        
        ROILBL.text = cropData[index].crop + " Growth Production Model has proven to be quite significant in its production. Planting between October and November will output the most yield."
    }
    @IBAction func backBtn(_ sender: Any) {
        
        
        print(cropData)
        if(index > 0){
            index = index - 1
            updateFields()
            
            
        }
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        
        print(cropData)
        if(index < cropData.count - 1){
            index = index + 1
            updateFields()
            
        }
        
        
    }
    
    @IBAction func refresh(_ sender: Any) {
        sendPostRequest(regionID: 1, acres: Int(newAcres)!)
        updateFields()
    }
    func sendPostRequest(regionID: Int, acres: Int){
        let url = URL(string: "https://pushcustomer-4kqfzi5n.uc.gateway.dev/getCropData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let parameters: [String: Any] = [
            
            "consumerID": 1,
            "regionID": 1
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error encoding JSON: \(error)")
            
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                semaphore.signal()
                return
            }
            
            if let data = data {
                do {
                    // Convert the Data object to a string
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Received JSON data as string:\n\(jsonString)")
                        
                        // Attempt to decode the JSON using Codable
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode(JSONContainer.self, from: data)
                            print("JSON data parsed successfully")
                            
                            // Access the 'cropData' array
                            let cropData = decodedData.cropData
                            // Now you have an array of 'Crop' objects in 'cropData'
                            self.cropData = cropData
                        } catch {
                            print("Failed to decode JSON data: \(error)")
                        }
                    } else {
                        print("Failed to convert Data to string.")
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
                
                
                
                semaphore.signal()
            }
        }
        task.resume()
        
        semaphore.wait()
        
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
