//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Olya on 05.06.2023.
//

import Foundation

fileprivate let UnsplashTokenURL = "https://unsplash.com/oauth/token"

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchOAuthToken(
            _ code: String,
            completion: @escaping (Result<String, Error>) -> Void
        ) {
            assert(Thread.isMainThread)
            if lastCode == code {return}
            task?.cancel()
            lastCode = code
            let request = authTokenRequest(code: code)
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let body):
                        let authToken = body.accessToken
                        self.authToken = authToken
                        completion(.success(authToken))
                        self.task = nil
                    case .failure(let error):
                        completion(.failure(error))
                        self.lastCode = nil
                    }
                }
            }
            self.task = task
            task.resume()
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value:  AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        return request
    }

