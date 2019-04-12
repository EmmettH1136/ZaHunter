//
//  ViewController.swift
//  ZaHunter
//
//  Created by Emmett Hasley on 4/3/19.
//  Copyright © 2019 John Heresy High School. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
	@IBOutlet weak var mapView: MKMapView!
	let locationManager = CLLocationManager()
	var location : CLLocation!
	var za : [MKMapItem] = []
	var passedItem = MKMapItem()
	var overlay = MKPolyline()
	
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
	@IBAction func whenPizz(_ sender: Any) {
		let request = MKLocalSearch.Request()
		request.naturalLanguageQuery = "Pizza"
		let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
		request.region = MKCoordinateRegion(center: location.coordinate, span: span)
		let search = MKLocalSearch(request: request)
		search.start { (response, error) in
			guard let response = response else {
				return
			}
			for mapItem in response.mapItems {
				self.za.append(mapItem)
				let annotation = MKPointAnnotation()
				annotation.coordinate = mapItem.placemark.coordinate
				annotation.title = mapItem.name
				self.mapView.addAnnotation(annotation)
				
			}
		}
		
	}
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation.isEqual(mapView.userLocation) {
			return nil
		}
		let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
		pin.image = UIImage(named: "PizzaAnno")
		pin.canShowCallout = true
		let button = UIButton(type: .detailDisclosure)
		button.setImage(UIImage(named: "myPizzaIcon"), for: .normal)
		button.tag = 1
		pin.rightCalloutAccessoryView = button
		let dirButton = UIButton(type: .detailDisclosure)
		dirButton.setImage(UIImage(named: "MyPizzaPathIcon"), for: .normal)
		pin.leftCalloutAccessoryView = dirButton
		dirButton.tag = 2
		return pin
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		let buttonPressed = control as! UIButton
		var currentMapItem = MKMapItem()
		if let title = 	view.annotation?.title, let 		zaname = title {
			for mapItem in za {
				if mapItem.name == zaname {
					currentMapItem = mapItem
				}
			}
		}
		if buttonPressed.tag == 1 {
			passedItem = currentMapItem
			performSegue(withIdentifier: "Bungus", sender: self)
		} else {
			mapView.removeOverlay(overlay)
			let request = MKDirections.Request()
			let userLocation = MKMapItem.forCurrentLocation()
			request.source = userLocation
			request.destination = currentMapItem
			request.transportType = .automobile
			let directions = MKDirections(request: request)
			directions.calculate { (response, error) in
				guard let response = response else { return }
				for route in response.routes {
					self.overlay = route.polyline
					self.mapView.addOverlay(self.overlay)
				}
			}
			
		}
	}
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let render = MKPolylineRenderer(overlay: overlay)
		render.strokeColor = .blue
		return render
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let nvc = segue.destination as? NewViewController
		nvc?.item = passedItem
		nvc?.passedLocation = location
		
	}

}

