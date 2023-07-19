//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Olya on 05.06.2023.
//
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    var logOut: String?
    
    private let logoImageView = UIImageView()

    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        showViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = OAuth2TokenStorage.shared.token {
            fetchProfile(with: token)
            switchToTabBarController()
        } else {
            UIBlockingProgressHUD.dismiss()
            guard let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
                assertionFailure("Failed to show Authentication Screen")
                return
            }

            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else {
            fatalError("Invalid Configuration")
        }

        let tabBarViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarViewController
    }

    private func fetchProfile(with token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            switch result {
            case .success(let profile):
                UIBlockingProgressHUD.dismiss()
                self?.switchToTabBarController()

                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { [weak self] result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(_):
                        self?.showAlert(title: "Что-то пошло не так.", message: "Не удалось загрузить фото профиля")
                    }
                }
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                self?.showAlert(title: "Что-то пошло не так.", message: "Не удалось войти в систему")
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    private func showViewController() {
        view.backgroundColor = UIColor(named: "YP Black")
        
        if logOut != nil {
            UIBlockingProgressHUD.show()
        } else {
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            logoImageView.image = UIImage(named: "Vector")
            view.addSubview(logoImageView)
            
            NSLayoutConstraint.activate([
                logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            self?.dismiss(animated: true) { [weak self] in
                switch result {
                case .success(let token):
                    self?.fetchProfile(with: token)
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self?.showAlert(title: "Что-то пошло не так.", message: "Не удалось получить токен авторизации")
                    break
                }
            }
        }
    }
}
