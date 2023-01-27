//
//  Network.swift
//  UnsplashApp
//
//  Created by Mac on 21.01.2023.
//

import Foundation

class getData: ObservableObject {
    
    @Published var Images: [[Photo]] = []
    @Published var noresults = false
    
    init() {
        updateData()
    }
    
    func updateData() {
        
        self.noresults = false
        
        let key = "3IbNNI7SkpcCtIYdkLtPIZkfqxTkwsmiJU4p-tVnlsY"
        let url = "https://api.unsplash.com/photos/random/?count=30&client_id=\(key)"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            do {
            let json = try JSONDecoder().decode([Photo].self, from: data!)
                
                for i in stride(from: 0, to: json.count, by: 2){
                    
                    var ArrayData: [Photo] = []
                    
                    for j in i..<i+2 {
                        
                        if j < json.count {
                            
                            ArrayData.append(json[j])
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.Images.append(ArrayData)
                    }
                    
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
        
    }
    
    func SearchData(url: String) {
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            do {
            let json = try JSONDecoder().decode(SearchPhoto.self, from: data!)
                
                if json.results.isEmpty {
                    DispatchQueue.main.async {
                        self.noresults = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.noresults = false
                    }
                }
                
                for i in stride(from: 0, to: json.results.count, by: 2){
                    
                    var ArrayData: [Photo] = []
                    
                    for j in i..<i+2 {
                        
                        if j < json.results.count {
                            
                            ArrayData.append(json.results[j])
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.Images.append(ArrayData)
                    }
                    
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
        
    }
    
    
    func SearchQuery(quer: String, page: Int){
        
        let key = "3IbNNI7SkpcCtIYdkLtPIZkfqxTkwsmiJU4p-tVnlsY"
        let query = quer.replacingOccurrences(of: " ", with: "%20")
        let url = "https://api.unsplash.com/search/photos/?page=\(page)&query=\(query)&client_id=\(key)"
        
        self.SearchData(url: url)
    }
    
}
