//
//  NewViewController.swift
//  ZaHunter
//
//  Created by Emmett Hasley on 4/4/19.
//  Copyright © 2019 John Heresy High School. All rights reserved.
//

import UIKit
import MapKit

class NewViewController: UIViewController {
	@IBOutlet weak var distLabel: UILabel!
	@IBOutlet weak var addLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var phonLabel: UILabel!
	var item = MKMapItem()
	var passedLocation : CLLocation!
	let distanceFormatter = MKDistanceFormatter()
	

    override func viewDidLoad() {
        super.viewDidLoad()
		titleLabel.text = item.name
		distanceFormatter.unitStyle = .full
		let dis = item.placemark.location?.distance(from: passedLocation)
		addLabel.text = item.placemark.subThoroughfare! + " " + item.placemark.thoroughfare!
		phonLabel.text = item.phoneNumber
		distLabel.text = distanceFormatter.string(fromDistance: dis!)
		
		
		
		
		

        // Do any additional setup after loading the view.
    }
	@IBAction func whenDismissed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	
}
