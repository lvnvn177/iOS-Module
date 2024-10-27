//
//  File.swift
//  
//
//  Created by 이영호 on 10/27/24.
//

import UIKit
import MapKit

public class MapManager: UIView {
    private let mapManager = MKMapView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupMapView() {
        addSubview(mapManager)
        mapManager.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapManager.topAnchor.constraint(equalTo: topAnchor),
            mapManager.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapManager.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapManager.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        mapManager.showsUserLocation = true
        mapManager.isZoomEnabled = true
        mapManager.isScrollEnabled = true
    }
    
    public func setCenterCoordinate(_ coordinate: CLLocationCoordinate2D, radius: CLLocationDistance = 1000) {
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: radius,
            longitudinalMeters: radius
        )
        mapManager.setRegion(region, animated: true)
    }
    
    public func getMapView() -> MKMapView {
        return mapManager
    }
}
