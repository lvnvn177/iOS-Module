//
//  File.swift
//  
//
//  Created by 이영호 on 10/22/24.
//

import GoogleMobileAds
import UIKit
import Combine

public class ADManager: NSObject, ObservableObject, GADFullScreenContentDelegate {
    @Published var isAdLoaded: Bool = false  // 광고 로드 상태를 추적할 수 있는 속성
    private var interstitial: GADInterstitialAd?
    private var adUnitID: String

    public init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
        loadAd()  // 초기화 시 광고 로드
    }

    // 광고 로드 함수
    public func loadAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                self?.isAdLoaded = false
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
            self?.isAdLoaded = true
            print("Interstitial ad loaded.")
        }
    }

    // 광고 표시 함수
    public func showAd(from viewController: UIViewController) {
        if let ad = interstitial {
            ad.present(fromRootViewController: viewController)
        } else {
            print("Ad wasn't ready")
        }
    }

    // 광고가 닫힐 때 처리
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad was dismissed")
        loadAd()  // 광고가 닫힌 후 새 광고 로드
    }
}
