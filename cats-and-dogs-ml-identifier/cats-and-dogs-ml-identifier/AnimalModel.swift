//
//  AnimalModel.swift
//  CatsAndDogsV1
//
//  Created by Jackson Wiese on 3/27/23.
//

import Foundation

//LOOK HERE FOR ERROR
class AnimalModel: ObservableObject{
    
    @Published var animal = Animal()
    
    //These are standard 4 steps for API call
    func getAnimal(){
        let stringUrl = Bool.random() ? catUrl: dogUrl //These are standard 4 steps for API call
        
        //1. creat the url object
        let url = URL(string: stringUrl)
        
        //2. check oif url is empty
        guard url != nil else{
            print("couldn't create url")
            return}
        
        //3.get url
        let session = URLSession.shared
        
        //4. create data task
        let dataTask = session.dataTask(with: url!) {(data, response, error) in
            if error == nil && data != nil{
                do{
                    if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as?[[String: Any]] {
                        let item = json.isEmpty ? [:] : json[0]
                        
                        if let animal = Animal(json: item){
                            
                            //puts this on command the main thread, esspecially good for core function: use this for microphone of app for Tol
                            DispatchQueue.main.async {
                                
                                //delays until the image is downloaded AND waits to know which class
                                //CHANGED FROM NIL FOR IMAGE TO DOWNLOAD TO CHECKING TO SEE IF THE CLASS IS EMPTY
                                while animal.results.isEmpty {}
                                
                                self.animal = animal
                            }//end of dispatch queue
                        }//end of if item
                    }//end of if let json
                } //ends do stmt
                catch{
                    print("json parse failed")
                }
                
            }
        } //end of let dataTask
        //5. resume data task
        dataTask.resume()
    }//end of function get animal
}
