//
//  VideoURLData.swift
//  MiniRumbl
//
//  Created by Anshu Vij on 15/05/21.
//

import Foundation

protocol VideoURLDataDelegate {
    func getData(_ VideoURLData : VideoURLData, modelData : [ModelData])
    func didFailWithError(error : Error)
}


struct VideoURLData {
    
    var delegate : VideoURLDataDelegate?
    func readLocalFile() {
        do {
            if let bundlePath = Bundle.main.path(forResource: "data",
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                
                self.delegate?.getData(self, modelData: parse(jsonData: jsonData))
                
            }
        } catch {
            print(error)
        }
        
    }
    
    fileprivate func parse(jsonData: Data) -> [ModelData] {
        
        var data : [ModelData]?
        do {
            let decodedData = try JSONDecoder().decode([ModelData].self,
                                                       from: jsonData)
            data = decodedData
             //print("Data: ", decodedData.first?.title)
        }
        
        catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        }
        catch {
            print("decode error")
            self.delegate?.didFailWithError(error: error)
        }
        
        return data ?? []
    }
    
    
}
