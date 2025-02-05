//
//  SignInViewModel.swift
//  oauthsample
//
//  Created by Sachin Gupta on 4/16/21.
//

import Foundation
import AuthenticationServices
import Combine
class SignInViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    
    var subscriptions = Set<AnyCancellable>()
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor{
        return ASPresentationAnchor()
    }
    
    func processResponseURL(url: URL) {
        print(url)
    }
    
    func signIn() {
            let signInPromise = Future<URL, Error> { completion in
                let apiData = GithubAPIConfigurations.load()
                let authUrl = GithubAuthenticationURLBuilder(clientID:apiData.id, secret:apiData.secret)()
                
                let authSession = ASWebAuthenticationSession(
                    url: authUrl, callbackURLScheme:
                        apiData.redirectURL.absoluteString) { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
                
                authSession.presentationContextProvider = self
                authSession.prefersEphemeralWebBrowserSession = true
                authSession.start()
            }
            
            signInPromise.sink { (completion) in
                switch completion {
                case .failure(let error): break // Handle the error here. An error can even be when the user cancels authentication.
                default: break
                }
            } receiveValue: { (url) in
                self.processResponseURL(url: url)
            }
            .store(in: &subscriptions)
        }
}
public class GithubAPIConfigurations: Codable {
    public let id: String
    public let secret: String
    public let name: String
    public let redirectURL: URL
    
    static func load() -> GithubAPIConfigurations {
        let filePath = Bundle.main.url(forResource: "config_api", withExtension: "json")!
        let data = try! Data(contentsOf: filePath)
        let object = try! JSONDecoder().decode(GithubAPIConfigurations.self, from: data)
        return object
    }
}

public class GithubAuthenticationURLBuilder {
    
    /// The domain URL
    let domain: String
    
    /// Client ID
    let clientID: String
    let secret:String
    
    init(
        domain: String = "github.com",
        clientID: String, secret:String) {
        self.domain = domain
        self.clientID = clientID
        self.secret = secret
    }
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = domain
        components.path = "/login/oauth/authorize"
        components.queryItems =
            [
                "client_id": String(clientID),
                "secret": secret,
                "response_type": "token"
            ].map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    func callAsFunction() -> URL {
        url
    }
}
