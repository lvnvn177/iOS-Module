//
//  File.swift
//  
//
//  Created by 이영호 on 10/22/24.
//

import GoogleMobileAds
import UIKit

public class ADManager: NSObject, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    private var adUnitID: String
    
    public init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
    }
    
    public func loadAd() {
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: adUnitID,
            request: request
        ) { [weak self]ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
            print("Interstitial ad loaded.")
        }
    }
    
    public func showAd(from viewController: UIViewController) {
        if let ad = interstitial {
            ad.present(fromRootViewController: viewController)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    public func adDidDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        print("Ad was dismissed")
        loadAd()
    }
}
