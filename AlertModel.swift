//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Olya on 30.06.2023.
//

import Foundation

struct AlertModel{
    var title:String
    var message: String
    var buttonText: String
    var completion: (()->())
    
}
