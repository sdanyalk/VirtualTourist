//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by SDK on 5/12/19.
//  Copyright © 2019 SDK. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var albumCollection: UICollectionView!
    @IBOutlet weak var getNewCollectionButton: UIButton!
    
    private let itemsPerRow: CGFloat = 3
    private let insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var pin: Pin!
    
    // MARK : - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumCollection.dataSource = self
        albumCollection.delegate = self
        
        setupFetchedResultsController()
        
        if (fetchedResultsController.sections?[0].numberOfObjects ?? 0 == 0) {
            getPhotos()
        }
        
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin], animated: true)
        mapView.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        fetchedResultsController = nil
    }
}

// MARK : - Private Methods

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            albumCollection.insertItems(at: [newIndexPath!])
            break
        case .delete:
            albumCollection.deleteItems(at: [indexPath!])
            break
        default: ()
        }
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        let predicate = NSPredicate(format: "pin == %@", pin)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    private func getPhotos() {
        FlickrClient.getPhotos(lat: pin.latitude, long: pin.longitude) { photoURLlist, error in
            if let error = error {
                self.showError(withMessage: error.localizedDescription)
                
                return
            }
            
            if let photoURLlist = photoURLlist {
                for url in photoURLlist {
                    self.addPhoto(url: url)
                }
            }
            
            DispatchQueue.main.async {
                self.albumCollection.reloadData()
            }
        }
    }
    
    private func addPhoto(url: String) {
        let photo = Photo(context: dataController.viewContext)
        
        photo.creationDate = Date()
        photo.url = url
        photo.pin = pin
        
        try? dataController.viewContext.save()
    }
    
    private func deletePhoto(_ photo: Photo) {
        dataController.viewContext.delete(photo)
        
        do {
            try dataController.viewContext.save()
        } catch {
            print("Error saving")
        }
    }
}

// MARK : - CollectionView Datasource

extension PhotoAlbumViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoData = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        
        if let photoData = photoData.data {
            cell.imageView.image = UIImage(data: photoData)
            
        } else if let photoUrl = photoData.url {
            guard let url = URL(string: photoUrl) else {
                fatalError("Not valid URL for photo.")
            }
            
            FlickrClient.getPhotoImage(url: url) { data, error in
                if let error = error {
                    self.showError(withMessage: error.localizedDescription)
                    
                    return
                }
                
                if let data = data {
                    cell.imageView.image = UIImage(data: data)
                } else {
                    self.showError(withMessage: "No image found.")
                }
                photoData.data = data
                try? self.dataController.viewContext.save()
            }
        }
        
        return cell
    }
}

// MARK : - CollectionView FlowLayout

extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)
        -> CGSize {
        let padding = insets.right * (itemsPerRow + 1)
        let availableWidth = view.frame.width - padding
        let widthOfItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthOfItem, height: widthOfItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int)
        -> UIEdgeInsets {
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insets.right
    }
}
