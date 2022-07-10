//
//  MLImageHandler.swift
//  ClothesFinder
//
//  Created by Phil John on 1/29/22.
//


import UIKit
import CoreML
import Vision

class MLImageHandler {
    
    var tags: [String] = []
    
    func processImage(image: UIImage) throws {
        var resultTags = [VNClassificationObservation]()
        guard let ciImage = CIImage(image: image) else {
            fatalError("Error converting to CIImage")
        }
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Error creating model from Inceptionv3")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Error casting results to VNClassificationObservation Objects")
            }
            resultTags = results
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        do {
            try handler.perform([request])
            processTags(mlResultInfo: resultTags)
        } catch {
            throw error
        }
    }
    
    func processTags(mlResultInfo: [VNClassificationObservation]){
        if let resultString =  mlResultInfo.first?.identifier.filter { !$0.isWhitespace } {
            let resultStringArray = resultString.components(separatedBy: ",")
            tags = resultStringArray
        }
    }
}
