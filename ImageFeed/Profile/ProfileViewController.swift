//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Olya on 11.05.2023.
//

import UIKit

final class ProfileViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileImage = UIImage(named: "Photo")
        let imageView = UIImageView(image:profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:40).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant:16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        
        let logOutButton = UIButton.systemButton(
            with: UIImage(named: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapLogOutButton)
        )
        logOutButton.tintColor = UIColor(named:"YP Red")
        view.addSubview(logOutButton)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        let userName = UILabel()
        userName.text = "Екатерина Новикова"
        userName.textColor = UIColor(named: "YP White")
        let fontSize:CGFloat = 23
        let boldFontSize = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        userName.font = boldFontSize
        view.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant:8).isActive = true
        userName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant:16).isActive = true
        
        
        let userNickname = UILabel()
        userNickname.text = "@ekaterina_nov"
        userNickname.textColor = UIColor(named: "YP Gray")
        let nickFontSize: CGFloat = 13
        let nickFont = UIFont.systemFont(ofSize: nickFontSize, weight: .regular)
        userNickname.font = nickFont
        view.addSubview(userNickname)
        userNickname.translatesAutoresizingMaskIntoConstraints = false
        userNickname.topAnchor.constraint(equalTo: userName.bottomAnchor,constant:8).isActive = true
        userNickname.leadingAnchor.constraint(equalTo: userName.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        let userInformation = UILabel()
        userInformation.text = "Hello, world!"
        userInformation.textColor = UIColor(named: "YP White")
        userInformation.font = nickFont
        view.addSubview(userInformation)
        userInformation.translatesAutoresizingMaskIntoConstraints = false
        userInformation.topAnchor.constraint(equalTo: userNickname.bottomAnchor,constant:8).isActive = true
        userInformation.leadingAnchor.constraint(
            equalTo: userName.safeAreaLayoutGuide.leadingAnchor).isActive = true
        }
        
        @objc
        private func didTapLogOutButton(){}
    }

    
