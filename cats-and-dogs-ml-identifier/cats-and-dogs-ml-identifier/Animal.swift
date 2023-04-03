//
//  Animal.swift
//  CatsAndDogsV1
//
//  Created by Jackson Wiese on 3/27/23.
// 1)first file made

import Foundation
import CoreML
import Vision

//struct Result, referenced at the bottom of content view

struct Result: Identifiable{
    var imageLabel: String
    var confidence: Double
    var id = UUID() //aka every animal has a unique identifier number for that animal
}

//class animal to store important features about info it in
class Animal {
    //url for animal's image
    var imgUrl: String
    
    //image data | questionmark maeans this can be null
    var imageData:Data?
    
    //creating an array of all the results
    var results: [Result]
    
    let modelFile = try! MobileNetV2(configuration: MLModelConfiguration())
    
    //creating empty class of animal
    init(){ //initalizer function
        self.imgUrl = "" //no url here yet
        self.imageData = nil //no data in there yet
        self.results = [] //results is equal to empty array
    }
    
    init?(json:[String: Any]){  //bc string for URL AND any data for imageData
        
        //check json has the url we need
        guard let imageUrl = json["url"] as? String else {return nil}
        
        
        //set the animal property (it doesn't like undefined variables so we add them here and in the init() section
        self.imgUrl = imageUrl
        self.imageData = nil
        self.results = []
        
        //download image code
        getImage()
        
    }
    
    //we will come back to this
    func getImage(){
        //1. create url object
        let url = URL(string: imgUrl)
        
        //2. check if url is nuill
        guard url != nil else{print("Could not find url during gauard statement")
            return
        }
        
        //3. get the url session
        let session = URLSession.shared
        
        //4. create the data task
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            //4a: check if there was any errors;
            if error == nil && data != nil {
                self.imageData = data
                self.classifyAnimal() //actual classification call takes place here
    
            }
            
        }
        
        //5. start the data task
        dataTask.resume()
        
    }
    
    func classifyAnimal(){
        //1. get a refernece to the model
        let model = try! VNCoreMLModel(for: modelFile.model)
        
        //2. create an image handler (again ! is to force the data through)
        let handler = VNImageRequestHandler(data: imageData!)
        
        
        //3. create a request to the model
        let request = VNCoreMLRequest(model: model){
            (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                print("Failed to classify animal")
                return
                //Notes: this print will not be front facing rather it's back facing, the user will see the opacity if it fails
            } //end of else for guard
            
 
                //1. Create identifier for what clase we're in / what image we're looking at went up and created varResults + following var
            for classification in results{
                 var identifier = classification.identifier
                 identifier = identifier.prefix(1).capitalized + identifier.dropFirst()
                
      
                //2.
                     //appending label and accuracy
                self.results.append(Result(imageLabel: identifier, confidence: Double(classification.confidence)))
            } //end of for
            
        } //end of let request
        
        //Notes: Handler is an instance to a particular class that is a processing unit that decodes .jpg, .png, .pdf, and etc so that we don't have to in the background
        
        //4. execute the request
        do{
            try handler.perform([request])
            
        } catch {
            print("Image format not support || Error in attenmpt to execute the request")
        }
        
        
    }
}
