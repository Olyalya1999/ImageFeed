//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Olya on 29.05.2023.
//

import WebKit
import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    private var estimatedProgressObservation: NSKeyValueObservation?
    weak var delegate: WebViewViewControllerDelegate?
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self

        estimatedProgressObservation = webView.observe(\.estimatedProgress) { [weak self] _, _ in
            self?.updateProgress()
        }
        
        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]

        guard let url = urlComponents.url else {
            return
        }
        let request = URLRequest(url: url)

        webView.load(request)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
