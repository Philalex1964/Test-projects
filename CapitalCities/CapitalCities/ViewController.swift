//
//  ViewController.swift
//  CapitalCities
//
//  Created by Alexander Filippov on 13.3.22..
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(chooseMapType))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.", url: URL(fileURLWithPath: "https://en.wikipedia.org/wiki/London"))
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.", url: URL(fileURLWithPath: "https://en.wikipedia.org/wiki/Oslo"))
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.", url: URL(fileURLWithPath: "https://en.wikipedia.org/wiki/Paris"))
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", url: URL(fileURLWithPath: "https://en.wikipedia.org/wiki/Rome"))
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", url: URL(fileURLWithPath: "https://en.wikipedia.org/wiki/Washington"))
        let petrovaradin = Capital(title: "Petrovaradin", coordinate: CLLocationCoordinate2D(latitude: 45.2436563, longitude: 19.8837914), info: "I just like it.", url: URL(fileURLWithPath: "https://en.wikipedia.org/wiki/Petrovaradin"))
        
        mapView.addAnnotations([london, oslo, paris, rome, washington, petrovaradin])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }

        let identifier = "Capital"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.pinTintColor = .purple
        
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Open Wikipedia?", style: .default) { [weak self] _ in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Wiki")
            
            
        })
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc func chooseMapType() {
        let ac = UIAlertController(title: "Choose map type", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Usual Map", style: .default) { [weak self] _ in
            self?.mapView.mapType = .standard
        })
        ac.addAction(UIAlertAction(title: "Satellite Map", style: .default) { [weak self] _ in
            self?.mapView.mapType = .satellite
        })
        ac.addAction(UIAlertAction(title: "Hybrid Map", style: .default) { [weak self] _ in
            self?.mapView.mapType = .hybrid
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

