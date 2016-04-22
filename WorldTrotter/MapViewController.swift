import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
  var mapView: MKMapView!
  private let locationManager = CLLocationManager()
  private let geocoder = CLGeocoder()
  private let locations = ["Virginia Beach, VA", "Nashville, TN", "New Orleans, LA"]
  private var locationIndex: Int!
  
  private lazy var segmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
    segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), forControlEvents: .ValueChanged)
    return segmentedControl
  }()
  
  private lazy var locationButton: UIButton = {
    let locationButton = UIButton()
    locationButton.setTitle("Current Location", forState: .Normal)
    locationButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    locationButton.backgroundColor = UIColor.blueColor()
    locationButton.addTarget(self, action: #selector(MapViewController.findLocation), forControlEvents: .TouchUpInside)
    return locationButton
  }()
  
  private lazy var cycleButton: UIButton = {
    let cycleButton = UIButton()
    cycleButton.setTitle("Cycle Locations", forState: .Normal)
    cycleButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    cycleButton.backgroundColor = UIColor.blueColor()
    cycleButton.addTarget(self, action: #selector(MapViewController.cycleLocations), forControlEvents: .TouchUpInside)
    return cycleButton
  }()
  
  override func loadView() {
    mapView = MKMapView()
    createViewHierarchy()
    addConstraints()
  }
  
  private func createViewHierarchy() {
    view = mapView
    view.addSubview(segmentedControl)
    view.addSubview(locationButton)
    view.addSubview(cycleButton)
  }
  
  private func addConstraints() {
    constrainSegmentedControl()
    constrainLocationButton()
    constrainCycleButton()
  }
  
  private func constrainSegmentedControl() {
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    
    let constant = view.layoutMargins.top
    segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: constant).active = true
    segmentedControl.leadingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.leadingAnchor).active = true
    segmentedControl.trailingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.trailingAnchor).active = true
  }
  
  private func constrainLocationButton() {
    locationButton.translatesAutoresizingMaskIntoConstraints = false
    
    let constant = -locationButton.layoutMargins.bottom
    locationButton.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor, constant: constant).active = true
    locationButton.trailingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.trailingAnchor).active = true
  }
  
  private func constrainCycleButton() {
    cycleButton.translatesAutoresizingMaskIntoConstraints = false
    
    let constant = -cycleButton.layoutMargins.left
    cycleButton.trailingAnchor.constraintEqualToAnchor(locationButton.leadingAnchor, constant: constant).active = true
    cycleButton.bottomAnchor.constraintEqualToAnchor(locationButton.bottomAnchor).active = true
  }
  
  override func viewDidLoad() {
    mapView.delegate = self
    mapView.setUserTrackingMode(.None, animated: false)
    locationIndex = 0
  }
  
  func mapTypeChanged(segControl: UISegmentedControl) {
    switch segControl.selectedSegmentIndex {
    case 0:
      mapView.mapType = .Standard
    case 1:
      mapView.mapType = .Hybrid
    case 2:
      mapView.mapType = .Satellite
    default:
      break
    }
  }
  
  func findLocation() {
    locationManager.requestWhenInUseAuthorization()
    mapView.showsUserLocation = true
  }
  
  func cycleLocations() {
    if locationIndex == locations.count {
      locationIndex = 0
    }

    geocoder.geocodeAddressString(locations[locationIndex]) { [mapView] (placemarks, error) in
      guard let placemarks = placemarks where placemarks.count > 0 else {
        return
      }
      
      let placemark = MKPlacemark(placemark: placemarks.first!)
      let region = MKCoordinateRegionMake(placemark.coordinate, MKCoordinateSpanMake(1, 1))
      
      mapView.setRegion(region, animated: true)
      mapView.addAnnotation(placemark)
    }
    
    locationIndex = locationIndex + 1
  }
}

//MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    let region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(1, 1))
    mapView.setRegion(region, animated: true)
  }
}
