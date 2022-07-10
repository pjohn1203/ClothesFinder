//
//  ViewController.swift
//  ClothesFinder
//
//  Created by Phil John on 1/29/22.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var AppTitle: UILabel!
    @IBOutlet weak var clothingImageView: UIImageView!
    
    // Buttons
    @IBOutlet weak var appTitleView: UIView!
    @IBOutlet weak var takePhotoView: UIView!
    @IBOutlet weak var uploadPhotoView: UIView!
    @IBOutlet weak var findView: UIView!
    @IBOutlet weak var matchingClothingButton: UIButton!
    
    
    
    
    // Delegate/Swift Controllers variables
    private let imagePicker = UIImagePickerController()
    private var networkManager = NetworkManager()
    var jsonArrayItemCount = 2
    var didChangeDefaultImage: Bool = false
    var jsonArray: JSON = [
                [
                    "position": 1,
                    "title": "Men Distressed Skinny Jeans,34",
                    "link": "https://www.google.com/aclk?sa=L&ai=DChcSEwiEq_3zzt31AhWNjMgKHcpICpIYABABGgJxdQ&sig=AOD64_18KpoRoKpwh2-mKZHVMObY7jBjDg&ctype=5&q=&ved=0ahUKEwizhPjzzt31AhW1qXIEHUGXCp8Qg-UECI0M&adurl=",
                    "source": "SHEIN",
                    "price": "$22.99",
                    "extracted_price": 22.99,
                    "extensions": [
                        "LOW PRICE"
                    ],
                    "thumbnail": "https://serpapi.com/searches/61f8b03124e88e2cc3ffdbe8/images/18557f72bcf97a01af4422975ddc2e7b10a209c90ed0bf33728d0220f4bbc944.webp",
                    "tag": "LOW PRICE",
                    "delivery": "$3.99 delivery"
                ],
                [
                    "position": 2,
                    "title": "Guys Ripped Jeans,34",
                    "link": "https://www.google.com/aclk?sa=L&ai=DChcSEwiEq_3zzt31AhWNjMgKHcpICpIYABADGgJxdQ&sig=AOD64_1ComJ6eHPSKrV7HVoHuKFNZab9VA&ctype=5&q=&ved=0ahUKEwizhPjzzt31AhW1qXIEHUGXCp8Qg-UECJsM&adurl=",
                    "source": "SHEIN",
                    "price": "$23.75",
                    "extracted_price": 23.75,
                    "extensions": [
                        "PRICE DROP"
                    ],
                    "thumbnail": "https://serpapi.com/searches/61f8b03124e88e2cc3ffdbe8/images/18557f72bcf97a01af4422975ddc2e7b4157f5c0330beb52b354a1fec2b5728e.webp",
                    "tag": "PRICE DROP",
                    "delivery": "$3.99 delivery"
                ],
                [
                      "position": 6,
                      "title": "Men Zipper Fly Ripped Skinny Jeans,32",
                      "link": "https://www.google.com/aclk?sa=L&ai=DChcSEwiEq_3zzt31AhWNjMgKHcpICpIYABALGgJxdQ&sig=AOD64_2O16eq9Sdf2GsNq-C0VQDLZJucvg&ctype=5&q=&ved=0ahUKEwizhPjzzt31AhW1qXIEHUGXCp8Qg-UECM8M&adurl=",
                      "source": "SHEIN",
                      "price": "$21.99",
                      "extracted_price": 21.99,
                      "extensions": [
                        "LOW PRICE"
                      ],
                      "thumbnail": "https://serpapi.com/searches/61f8b03124e88e2cc3ffdbe8/images/18557f72bcf97a01af4422975ddc2e7b6f631266f1267d0832e29ee114d43361.webp",
                      "tag": "LOW PRICE",
                      "delivery": "$3.99 delivery"
                    ],
    ]
    
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        checkSerpAPIKey()
        
        imagePicker.delegate = self
        networkManager.delegate = self
        
        appTitleView.layer.cornerRadius = 20
        appTitleView.layer.masksToBounds = true
        
        takePhotoView.layer.cornerRadius = 20
        takePhotoView.layer.masksToBounds = true
        
        uploadPhotoView.layer.cornerRadius = 20
        uploadPhotoView.layer.masksToBounds = true
    
        findView.layer.cornerRadius = 20
        findView.layer.masksToBounds = true
    
        
        
//        clothingImageView.image = .system
    }

    @IBAction func onTakePhotoPressed(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        didChangeDefaultImage = true
    }
    
    @IBAction func onUploadPhotoPressed(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        didChangeDefaultImage = true
    }
    
    @IBAction func onFindMatchingClothing(_ sender: Any) {
        print("Backend Called!")
        // Step 1: Run through model
        let mlImageHandlerInstance = MLImageHandler()
        
       
        if checkSerpAPIKey() == true {
            if didChangeDefaultImage {
                if let image = clothingImageView.image {
                    do {
                        try mlImageHandlerInstance.processImage(image: image)
                        networkManager.performGETRequest(queryItems: mlImageHandlerInstance.tags, serviceName: "SerpAPI")
                    } catch {
                        print("Issues with processing image")
                    }
                }
            } else {
                let alertController = UIAlertController(title: "No Image Selected", message: "Please upload or take a photo of an item of clothing.", preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
                alertController.addAction(closeAction)
                present(alertController, animated: true, completion: nil)
            }
        }
        
        
        // Step 2: Collect generated tags
        // Step 3: Create Request to Web Scraper
        // Step 4: Parse Successful Request data
        // Step 5: Segue to UIListView
    }
    
    //MARK: - Segue Preparation Implementationsq
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueToShoppingResults {
            let destinationVC = segue.destination as! ShoppingTableViewController
                        
            destinationVC.shoppingResultsJSON = self.jsonArray
            print(self.jsonArray.count)
            destinationVC.shoppingResultsJSONCount = self.jsonArray.count
            
            // Pass JSON data from segue here
        }
    }
    
    func checkSerpAPIKey() -> Bool {
        if NetworkConstants.SerpAPI.serpAPIKey.isEmpty {
            let alertController = UIAlertController(title: "No SerpAPI Key Available", message: "Please add a SerpAPI Key in order to use the shopping features.", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            alertController.addAction(closeAction)
            present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
}

//MARK: - UINavigationControllerDelegate Implementation
extension ViewController: UINavigationControllerDelegate {}


//MARK: - UIImagePickerControllerDelegate Implementation
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            clothingImageView.image = image
        }
        
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - NetworkManagerDelegate Implementation
extension ViewController: NetworkManagerDelegate {
    func didSuccessfulNetworkCall(shoppingResultsJson: JSON) {
        DispatchQueue.main.async {
            print(shoppingResultsJson)
            self.jsonArray = shoppingResultsJson
            self.jsonArrayItemCount = shoppingResultsJson.count
            self.performSegue(withIdentifier: K.segueToShoppingResults, sender: self)
        }
    }
    
    func didFailWithError(with error: Error) {
        DispatchQueue.main.async {
            print("Error with network call: \(error)")
        }
    }
}

