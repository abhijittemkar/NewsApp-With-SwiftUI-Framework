//  Container.swift

import Foundation

class Container {
    static let jsonDecoder: JSONDecoder = JSONDecoder()
    
    static var weatherJSONDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        return jsonDecoder
    }()
    
    /// News API key url: https://newsapi.org
    ///
    /// Abhijit
   // static let newsAPIKey: String = "c5b2661cadbc428ba605ceb6eaf97aad"
    
    //Srijit
    static let newsAPIKey: String = "d31297809c5a4f0db53ce4450e80f587"
    
    // Weather API key url: https://darksky.net
  // static let weatherAPIKey: String = "pnV4u8QRAQevefrJymKuaUxI1gGFGrqk"
    
    /// Weather API key url: https://www.meteosource.com
    static let weatherAPIKey: String = "5sqwjkxer8mrm4ij9lskbf58043va8e7p9451a7p"

}
