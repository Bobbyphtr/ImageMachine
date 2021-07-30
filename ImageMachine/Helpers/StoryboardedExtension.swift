//
//  StoryboardedExtension.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 30/07/21.
//

import UIKit

/// Protokol ini wajib diimplementasikan untuk setiap UIViewController yang terdaftar dalam Storyboard tertentu.
/// WARNING:  Storyboard ID harus berupa nama class dari UIViewController itu sendiri.
protocol Storyboarded {
    static func instantiate(from storyboard : UIStoryboard) -> Self
}

extension Storyboarded where Self: UIViewController {
    /// Untuk Instantiate UIViewController dengan langsung menggunakan nama file untuk identitifernya.
    static func instantiate(from storyboard : UIStoryboard) -> Self {
        /// Mengambil nama penuh : "App.MyViewController"
        let fullName = NSStringFromClass(self)
        /// Memisahkan nama class dengan nama app nya "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]
        /// Instantiate UIViewController sesuai dengan nama file nya.
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
        
    }
}

extension UIStoryboard {
    
    /// Untuk melakukan inisialisasi storyboard menggunakana enum `Storyboard`. Supaya tidak hardcode untuk nama dari storyboardnya
    /// - Parameter name: Storyboard name
    /// - Returns: `UIStoryboard` instance
    static func instantiate(named name : String)->UIStoryboard {
        return self.init(name: name, bundle: .main)
    }
}
