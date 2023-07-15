//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Olya on 11.05.2023.
//

import UIKit
import Kingfisher


final class ProfileViewController:UIViewController {
    private var userInformation: UILabel!
    private var userNickname: UILabel!
    private var userName: UILabel!
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private func informationScreen(view:UIView){
        let profileImage = UIImage(named: "Photo")
        let imageView = UIImageView(image:profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.tag = 1
        view.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:40).isActive = true
        imageView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor,constant:16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func LogOutButton(view:UIView){
        let logOutButton = UIButton.systemButton(
            with: UIImage(named: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapLogOutButton)
        )
        
        logOutButton.tintColor = UIColor(named:"YP Red")
        view.addSubview(logOutButton)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: view.viewWithTag(1)!.centerYAnchor).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    private func UserInformation(view:UIView){
        userName = UILabel()
        userName.text = "Екатерина Новикова"
        userName.textColor = UIColor(named: "YP White")
        let fontSize:CGFloat = 23
        let boldFontSize = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        userName.font = boldFontSize
        view.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.topAnchor.constraint(equalTo: view.viewWithTag(1)!.bottomAnchor,constant:8).isActive = true
        userName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant:16).isActive = true
        
        userNickname = UILabel()
        userNickname.text = "@ekaterina_nov"
        userNickname.textColor = UIColor(named: "YP Gray")
        let nickFontSize: CGFloat = 13
        let nickFont = UIFont.systemFont(ofSize: nickFontSize, weight: .regular)
        userNickname.font = nickFont
        view.addSubview(userNickname)
        userNickname.translatesAutoresizingMaskIntoConstraints = false
        userNickname.topAnchor.constraint(equalTo: userName.bottomAnchor,constant:8).isActive = true
        userNickname.leadingAnchor.constraint(equalTo:userName.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        userInformation = UILabel()
        userInformation.text = "Hello, world!"
        userInformation.textColor = UIColor(named: "YP White")
        userInformation.font = nickFont
        view.addSubview(userInformation)
        userInformation.translatesAutoresizingMaskIntoConstraints = false
        userInformation.topAnchor.constraint(equalTo: userNickname.bottomAnchor,constant:8).isActive = true
        userInformation.leadingAnchor.constraint(
            equalTo: userName.safeAreaLayoutGuide.leadingAnchor).isActive = true
    }
    
    private func updateProfileDetails (profile: Profile) {
        userInformation.text = profile.bio 
        userNickname.text = profile.loginName
        userName.text = profile.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        informationScreen(view: view)
        LogOutButton(view: view)
        UserInformation(view: view)
        
        updateProfileDetails(profile: profileService.profile!)
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
        
    }
    
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL),
            let imageView = view.viewWithTag(1) as? UIImageView
        else { return }
        _ = RoundCornerImageProcessor(cornerRadius: imageView.frame.width / 2)
        let placeholderImage = UIImage(named: " placeholder")
        imageView.kf.setImage(with: url,
                              placeholder: placeholderImage,
                              options: nil,
                              completionHandler: { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success(let value):
                print("Фото загружено: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Фото не загружено: \(error)")
            }
        })
        
    }
    
    
    @objc
    private func didTapLogOutButton(){
        let tokenStorage = OAuth2TokenStorage.shared
        tokenStorage.removeToken()
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            } else {
                if let imageView = view as? UIImageView {
                    imageView.image = UIImage(named: "ProfilePhotoPlaceholder")
                    imageView.tintColor = UIColor(named: "YP Gray")
                }
            }
        }
        present(SplashViewController(), animated: true, completion: nil)
        
    }
}
