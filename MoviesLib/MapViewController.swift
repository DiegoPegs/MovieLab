//
//  MapViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 27/02/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        requestAuthorization()
        
    }
    
    func requestAuthorization(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func loadPOIs(text: String){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error == nil {
                guard let response = response else{return}
                self.mapView.removeAnnotations(self.mapView.annotations)
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.url?.absoluteString
                    self.mapView.addAnnotation(annotation)
                }
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            }
        }
    }

}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        loadPOIs(text: searchBar.text!)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        renderer.lineWidth = 8.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {return}
        let coordinate = annotation.coordinate
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if error == nil {
                guard let response = response, let route = response.routes.first else {return}
                self.mapView.removeOverlays(mapView.overlays)
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
            }
        }
    }
}
