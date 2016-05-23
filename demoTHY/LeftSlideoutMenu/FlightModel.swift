//
//  FlightModel.swift
//  demoTHY
//
//  Created by timur on 06/04/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreLocation

/**
 Representation of a single flight including the MapKit data
*/
class FlightModel: MKPointAnnotation {
    
    var popupDictionary : [String : AnyObject]?
    
    weak var delegate : FirstViewController?
    
    var isPathVisible = false
    
    var transform : CGAffineTransform?
    
    // MARK: Flight Path Properties
    var flightpathPolyline: MKGeodesicPolyline!
    var planeAnnotationPosition = 0
    var groundSpeed = Double(0) //plane relative speed regarding earth
    
    var flightPath: MKPolyline! // timur 2
    
//    var fetchedCoordinates = [CLLocation]() // flight path
    var currentCoordinate : CLLocation? // current plane location
    
    var planeDirection : CLLocationDirection?
    var previousMapPoint : MKMapPoint?
    weak var planeAnnotationView : MKAnnotationView? {
        didSet {
            self.planeAnnotationView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "togglePlanePath"))
        }
    }
    
    
    func togglePlanePath() {
        self.delegate?.togglePlanePath(self)
    }
    
    
    func setup(title: String, groundSpeed: Double, fetchedCoordinates : [CLLocation], currentCoordinate : CLLocation) {
        
        // We'll only change the title here, right? act)ually it would be better if we can do the same as ar on here too.within popup only for planes id like KLM785
        // let me find a code snippet. ok for popup snippet i can guide you
        self.title = title
        let minSpeed = 15.0
        self.groundSpeed = (groundSpeed > minSpeed) ? groundSpeed : minSpeed
        
        // fetchedCoordinates contains waypoints
        self.createNewPolylineWithCoorinates(fetchedCoordinates, currentPlaneCoordinate: currentCoordinate)
        
        
    }
    
    
    func createNewPolylineWithCoorinates(coordinates : [CLLocation], currentPlaneCoordinate : CLLocation) {
        
        var coords = [CLLocationCoordinate2D]()
        for location in coordinates {
            coords.append(location.coordinate)
        }
        let geodesicPolyline = MKGeodesicPolyline(coordinates: &coords, count: coordinates.count) // BURDAKİ 2 NE İŞE YARIYOR?
        
        
        //print(geodesicPolyline.pointCount)
        
        self.flightpathPolyline = geodesicPolyline
        
        let closestPolylinePointIndex = self.getIndexOfMKMapPointInPolyline(self.flightpathPolyline, forCoordinate: currentPlaneCoordinate)
        self.planeAnnotationPosition = closestPolylinePointIndex
        let points = self.flightpathPolyline.points()
        let previousPolylineIndex = closestPolylinePointIndex > 0 ? closestPolylinePointIndex - 1 : 0
        self.previousMapPoint =  points[previousPolylineIndex]
        
        self.updatePlanePosition()
    }
    
    
    
    func knotsToMPS(knots : Double) -> Double {
        return knots * 0.514
    }
    
    func getIndexOfMKMapPointInPolyline(polyline : MKGeodesicPolyline, forCoordinate coordinate : CLLocation) -> Int {
        let points = polyline.points()
        
        
        var closestDistance = Double(999999999)
        var closestWaypointNumber = 0
        var i = 0
        for j in 0...polyline.pointCount {
            let point = points[j]
            let coor = MKCoordinateForMapPoint(point)
            let location = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
            
            let distance = coordinate.distanceFromLocation(location)
            if distance < closestDistance {
                // Closest Waypoint
                closestDistance = distance
                closestWaypointNumber = i
            }
            i += 1
        }
        
        
        return closestWaypointNumber
    }
    
    
    // I wn
    func updatePlanePosition() {
        let step = 1 // esasında burası 5 idi!!! BURASI UÇAĞIN İLERLEME HIZINI BELİRLİYOR!!
        guard planeAnnotationPosition + step < flightpathPolyline.pointCount
            else { return }
        
        let points = flightpathPolyline.points()
        self.planeAnnotationPosition += step
        let nextMapPoint = points[self.planeAnnotationPosition]
        
        if let previousPoint = self.previousMapPoint {
            self.planeDirection = directionBetweenPoints(previousPoint, nextMapPoint)
        } else {
            self.previousMapPoint = nextMapPoint;
        }
        self.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        
        if let annotationView = self.planeAnnotationView {
            if let planeDir = self.planeDirection {
                if let transform = self.transform {
                    annotationView.transform = CGAffineTransformRotate(transform,
                    CGFloat(degreesToRadians(planeDir)))
                }
            }
        }
        
        let previousCoordinate = MKCoordinateForMapPoint(self.previousMapPoint!)
        let previousLocation = CLLocation(latitude: previousCoordinate.latitude, longitude: previousCoordinate.longitude)
        let nextCoordinate = MKCoordinateForMapPoint(nextMapPoint)
        let nextLocation = CLLocation(latitude: nextCoordinate.latitude, longitude: nextCoordinate.longitude)
        
        let distanceBetweenTwoPoints = previousLocation.distanceFromLocation(nextLocation)
        let timeBetweenTwoPoints = distanceBetweenTwoPoints / self.knotsToMPS(self.groundSpeed)
        
        // Repeat method
        self.performSelector("updatePlanePosition", withObject: nil, afterDelay: timeBetweenTwoPoints) // buradaki 0.03 ikonun güncellenme hızı, ikonun ilerleme hızı değil!!
        
        self.previousMapPoint = nextMapPoint
    }
    
    private func directionBetweenPoints(sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> CLLocationDirection {
        let x = destinationPoint.x - sourcePoint.x
        let y = destinationPoint.y - sourcePoint.y
        
        return radiansToDegrees(atan2(y, x)) % 360 + 90
    }
    
    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / M_PI
    }
    
    private func degreesToRadians(degrees: Double) -> Double {
        return degrees * M_PI / 180
    }
    

}
