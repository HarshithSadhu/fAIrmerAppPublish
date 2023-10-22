//
//  ViewController.swift
//  FAIrmer
//
//  Created by Harshith Sadhu on 10/21/23.
//

import UIKit

class ViewController: UIViewController {

    let deviceID = UIDevice.current.identifierForVendor?.uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let identifierForVendor = UIDevice.current.identifierForVendor {
            // The device identifier exists, and you can use it here
            let deviceID = identifierForVendor.uuidString
            
            print("Device Identifier: \(deviceID)")
        } else {
            // Handle the case where the device identifier is not available
            print("Device Identifier not available")
        }
        print(deviceID as String?)





        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var acresTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true) // This will dismiss the keyboard for any active text field
    }
    
    // Save acres and regionID to UserDefaults
    func saveUserPreferences() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(acresTextField.text, forKey: "acres") // Assuming acresTextField is your text field
        
        

        userDefaults.synchronize() // This step may not be necessary in modern versions of iOS
    }

    @IBAction func submitBtn(_ sender: Any) {
        saveUserPreferences()
        sendPostRequest()
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    func sendPostRequest() {
        guard
                
                  let acresText = acresTextField.text,
                  let acres = Double(acresText) else {
                // Handle invalid input
                return
            }

            let url = URL(string: "https://pushcustomer-4kqfzi5n.uc.gateway.dev/pushCustomer")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
            let parameters: [String: Any] = [
                "consumerID": 1,
                "regionID": 1,
                "acres": acres
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                print("Error encoding JSON: \(error)")
                return
            }

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                if let data = data {
                    do {
                        // You can parse the response data if needed
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("Response: \(jsonResponse)")
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }

            task.resume()
        }


}

