//
//  TranslationViewModel.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 12/03/21.
//

import Foundation

class TranslationViewModel{
    
    func getTranslation(text:String, sourceLanguageCode:String, destinationLanguageCode:String,handler:@escaping (String,NetworkError?)->Void){
        ServerManager.shared.request(router: ServerRequestRouter.getTranslation(text, sourceLanguageCode, destinationLanguageCode)) { (result:Result<TranslatedResponse,NetworkError>) in
            
            switch result{
            case .success(let response):
                handler(response.data?.translations?.first?.translatedText ?? "Something went wrong",nil)
                break
                
            case .failure(let error):
                handler("Unable to translate ! Try again",error)
                break
            }
        }
    }
    
    func getLanguages()->[[String:Any]]?{
        if let path = Bundle.main.path(forResource: "Language", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [[String:AnyObject]] {
                    return jsonResult
                }
            } catch {
                print("Invalid JSON")
                // handle error
            }
        }
        return nil
    }
}
