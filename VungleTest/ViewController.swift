//
//  ViewController.swift
//  VungleTest
//
//  Created by Arthur Gaspard on 03/09/2022.
//

import UIKit
import VungleSDK

class ViewController: UIViewController {
    
    var sdk:VungleSDK?
    let appID = "6313490920ba47805d49d4a3"
    let placementID01 = "DEFAULT-0659243"
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        view.addSubview(imageView)
        imageView.frame = CGRect(
            x: 0,
            y: 0,
            width: 300,
            height: 300
        )
        imageView.center = view.center
        
        view.addSubview(button)
        
        getRandomPhoto()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        startVungle()
        onCheckCurrentStatus()
        loadAdForPlacement01()
        playAd()
    }

    
    
    // initialize Vungle SDK
    private func startVungle () {
        
        sdk = VungleSDK.shared()
        
        sdk?.setLoggingEnabled(true)
        do {
            try sdk?.start(withAppId: appID);
        } catch let error as NSError {
            print("Error while starting VungleSDK : \(error.domain)")
            return;
        }
    }
    
    // check initialization status
    func onCheckCurrentStatus() {
            print("Current Status ------------>> ");
            guard let sdk = sdk else {
                print("SDK is not yet initialized\n-->>------------------")
                return
            }
        print("-->> SDK Initialized: \(sdk.isInitialized)")
        print("-->> Placement 01 - an ad Loaded:: \(sdk.isAdCached(forPlacementID: placementID01))")
    }
    // SDK hasn't initialized, I need to wait for `vungleSDKDidInitialize` callback, but I can't find how
    
    
   // trying to load an Ad...
    func loadAdForPlacement01() {
        
        do {
            try sdk?.loadPlacement(withID: placementID01, adMarkup: "banner"); //... but can't find how to bring the enum VungleAdSizeBanner to with: parameter
        } catch let error as NSError {
            print("Error occurred when loading placement : \(error.domain)")
            return;
        }
    }
        
    // in case the ad actually loads, I would then try to display it
    func playAd() {
        do {
            try sdk?.playAd(self, options: nil, placementID: placementID01)
            }
            catch let error as NSError {
                 print("Error encountered playing ad: + \(error)");
            }
        }
    
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let button: UIButton = {
       let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Random Photo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    let colors: [UIColor] = [
        .systemRed,
        .systemCyan,
        .systemMint,
        .systemPink,
        .systemGreen,
        .systemYellow,
        .systemOrange
    ]
    
 
    @objc func didTapButton() {
        getRandomPhoto()
        
        view.backgroundColor = colors.randomElement()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect(
            x: 30,
            y: view.frame.size.height-150-view.safeAreaInsets.bottom,
            width: view.frame.size.width-60,
            height: 55
        )
    }
    
    func getRandomPhoto() {
        let urlString = "https://source.unsplash.com/random/600x600"
        let url = URL(string: urlString)!
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        imageView.image = UIImage(data: data)
    }
}
