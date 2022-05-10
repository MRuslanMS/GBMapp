//
//  ViewController.swift
//  GBMapTest
//
//  Created by Veaceslav Chirita on 04.03.2022.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {

    
    let coordinate = CLLocationCoordinate2D(latitude: 37.34033264974476, longitude: -122.06892632102273)
    var marker: GMSMarker?
    var manualMarker: GMSMarker?
    var geoCoder: CLGeocoder?
    //var route: GMSPolyline?
    var locationManager: CLLocationManager?
    var routePath: GMSMutablePath?
    var bounds = GMSCoordinateBounds()
    var distantion = 0.0
    
    @IBOutlet weak var distantionLabek: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBAction func didTabMeButton(_ sender: Any){
        addMarker()
        mapView.animate(toLocation: coordinate)
    }
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        configureLocationManager()
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = true
    }
    
    private func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        mapView.delegate = self
        
        
    }
     */
    @IBAction func didTapLocationButton(_ sender: UIButton) {
        locationManager?.requestLocation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        
        configureMap()
        configureLacationManager()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.settings.zoomGestures = true
//        myAdd(newPoint: coordinate)
        addMarker()
    }
    
    func configureLacationManager(){
        locationManager = CLLocationManager()
        
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func addMarker() {
        marker = GMSMarker(position: coordinate)
        
        marker?.icon = UIImage.init(systemName: "car.fill")
//        marker?.icon = GMSMarker.markerImage(with: .red)
        marker?.map = mapView

    }
    
    func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    
    func configureMap() {
        let camera = GMSCameraPosition(target: coordinate, zoom: 15)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        mapView.delegate = self
    }
    
    func myAdd(newCoordinate: CLLocationCoordinate2D) {
        let path = GMSMutablePath()
        path.add(coordinate)
        path.add(newCoordinate)
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .red
        polyline.strokeWidth = 3.0
        polyline.geodesic = true
        polyline.map = mapView
        
        bounds = bounds.includingCoordinate(path.coordinate(at: 1))
        let pathLen = GMSGeometryLength(path)
        distantion = distantion + round(pathLen)
        
        distantionLabek.text = "Растояние: \(distantion) м"
//        self.mapView.moveCamera(GMSCameraUpdate.fit(bounds))
        print("distantion = \(distantion)км")
        
        coordinate = newCoordinate
    }
    
    
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("coordinate=",coordinate)
        if let manualMarker = manualMarker {
            manualMarker.position = coordinate
        } else {
            let manualMarker  = GMSMarker(position: coordinate)
            manualMarker.map = mapView
        }
        myAdd(newCoordinate: coordinate)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        guard let location = locations.last else { return }
       
        if geoCoder == nil {
            geoCoder = CLGeocoder()
        }
        geoCoder?.reverseGeocodeLocation(location) { (places, error) in
            print(places?.first)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
/*
    private func addMarker() {
        marker = GMSMarker(position: coordinate)
        
//        let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
//        let viewMarker = UIView(frame: rect)
//        viewMarker.backgroundColor = .blue
        
//        marker?.icon = GMSMarker.markerImage(with: .cyan)
//        marker?.icon = UIImage(systemName: "pencil")
        
//        marker?.iconView = viewMarker
        
        marker?.title = "Маркер"
        marker?.snippet = "Мой новый маркер"
        
        marker?.map = mapView
    }
    
    private func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    
    @IBAction func didTapUpdateLocation(_ sender: UIButton) {
        locationManager?.requestLocation()
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        
        locationManager?.startUpdatingLocation()
    }
    
    @IBAction func addMarkerDidTap(_ sender: UIButton) {
        if marker == nil {
            mapView.animate(toLocation: coordinate)
            addMarker()
        } else {
            removeMarker()
        }
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
        let manulMarker = GMSMarker(position: coordinate)
        manulMarker.map = mapView
        
        if geoCoder == nil {
            geoCoder = CLGeocoder()
        }
        
        geoCoder?.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: { places, error in
            print(places?.last)
        })
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        routePath?.add(location.coordinate)
        route?.path = routePath
        
        let position = GMSCameraPosition.camera(withTarget: location.coordinate , zoom: 15)
        mapView.animate(to: position)
        
        print(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
*/


