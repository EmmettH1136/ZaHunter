//
//  ViewController.swift
//  ZaHunter
//
//  Created by Emmett Hasley on 4/3/19.
//  Copyright © 2019 John Heresy High School. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
	@IBOutlet weak var mapView: MKMapView!
	let locationManager = CLLocationManager()
	var location : CLLocation!
	var za : [MKMapItem] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		locationManager.requestWhenInUseAuthorization()
		mapView.showsUserLocation = true
		locationManager.delegate = self
		mapView.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startUpdatingLocation()
		// Do any additional setup after loading the view, typically from a nib.
	}
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		location = locations[0]
	}
	@IBAction func whenZoom(_ sender: Any) {
		let center = location.coordinate
		let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
		let region = MKCoordinateRegion(center: center, span: span)
		mapView.setRegion(region, animated: true)
	}
	

}

