//
//  ScanViewController.swift
//  Devreden
//
//  Created by Engin KUK on 17.07.2020.
//  Copyright © 2020 Silverback Inc. All rights reserved.
//

import Foundation
import VisionKit
import Vision
import UIKit

class ScanViewController: UIViewController, VNDocumentCameraViewControllerDelegate  {

    var image: UIImage?
    var textRecognitionRequest = VNRecognizeTextRequest()
    var recognizedText = ""
    @IBOutlet var lotoResults: UITextView!
    
    @IBAction func scanLoto(_ sender: Any) {
            let documentCameraViewController = VNDocumentCameraViewController()
            documentCameraViewController.delegate = self
            self.present(documentCameraViewController, animated: true, completion: nil)
    }
        
        
    
override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Lotonu Tarat"
    
    textRecognitionRequest.recognitionLevel = .fast
 
    textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
         if let results = request.results, !results.isEmpty {
             if let requestResults = request.results as? [VNRecognizedTextObservation] {
                 self.recognizedText = ""
                 for observation in requestResults {
                     guard let candidiate = observation.topCandidates(1).first else { return }
                       self.recognizedText += candidiate.string
                     self.recognizedText += "\n"
                 }
                self.lotoResults.text = self.recognizedText
             }
         }
     })
}
     
   
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        image = scan.imageOfPage(at: 0)
        let handler = VNImageRequestHandler(cgImage: image!.cgImage!, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
        controller.dismiss(animated: true)
    }
    
}
