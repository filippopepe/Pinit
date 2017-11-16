import UIKit
import CoreData
import MapKit

class LocationTableViewController: UITableViewController,NSFetchedResultsControllerDelegate,UISearchResultsUpdating{
var locations: [LocationMO] = []
var fetchResultController: NSFetchedResultsController<LocationMO>!
 var location:LocationMO!
    var myIndexPath: IndexPath = IndexPath()
var searchController: UISearchController!
var searchResults: [LocationMO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named:"Sfondo"))
        
        /* Recupero Dati da Database */
        let fetchRequest: NSFetchRequest<LocationMO> = LocationMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context1 = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context1, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    locations = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        // add a searchBar
        searchController = UISearchController(searchResultsController : nil)
        searchController.searchResultsUpdater=self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Location..."
        tableView.tableHeaderView=searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /* Recupero Dati da Database */
        let fetchRequest: NSFetchRequest<LocationMO> = LocationMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context1 = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context1, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    locations = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /* Recupero Dati da Database */
        let fetchRequest: NSFetchRequest<LocationMO> = LocationMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context1 = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context1, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    locations = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
     override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return searchResults.count
        } else {
            return locations.count
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellidentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifier, for: indexPath) as! LocationTableViewCell
        let location = (searchController.isActive && searchController.searchBar.text != "") ? searchResults[indexPath.row] : locations [indexPath.row]
       cell.nameLocation.text = location.name
        if let locationImage = location.image {
            cell.imageLocation.layer.cornerRadius = 40
            cell.imageLocation.clipsToBounds = true
            cell.imageLocation.image = UIImage(data:locationImage as Data)
        }
        cell.typeLocation.text = (location.type?.contains("🀺🀲🀳"))! ? "" : location.type
        cell.tintColor = UIColor.red
        cell.accessoryType = location.isVisited ? .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive{
            return false
        } else {
            return true
        }
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            locations.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler: {(action,indexPath)-> Void in
            let coordinate = CLLocationCoordinate2D(latitude: self.locations[indexPath.row].lat, longitude: self.locations[indexPath.row].long)
            let vCardURL = (LocationVCard()).vCardURL(from: coordinate, with: "Berlin")
            let activityViewController = UIActivityViewController(activityItems: [vCardURL], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        })
    //Delete Item
    let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default,title: "Delete", handler:{ (action,indexPath)-> Void in
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            let locationtodelete = self.fetchResultController.object(at: indexPath)
            context.delete(locationtodelete)
            appDelegate.saveContext()
        }
    })
    shareAction.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 150.0/255.0, alpha:1.0)
    deleteAction.backgroundColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha:1.0)
        return [deleteAction,shareAction]
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetailView" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as! DetailViewController
                if searchController.isActive {
                    if searchResults.count == 0 {
                        destinationController.location = locations[indexPath.row]
                        self.location = locations[indexPath.row]
                    } else {
                        destinationController.location = searchResults[indexPath.row]
                        self.location = searchResults[indexPath.row]
                    }
                } else {
                    destinationController.location = locations[indexPath.row]
                    self.location = locations[indexPath.row]
                }
                self.myIndexPath = indexPath
            }
        }
    }
    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject:Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                }
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            case .update:
                if let indexPath = indexPath {
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }
            default:
                tableView.reloadData()
        }
        if let fetchedObjects = controller.fetchedObjects {
            locations = fetchedObjects as! [LocationMO]
        }
        tableView.reloadData()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // filter content
    func filterContent(for searcText: String) {
        searchResults=locations.filter({(location) -> Bool in
            if let name = location.name,let type = location.type{
                let isMatch = name.localizedCaseInsensitiveContains(searcText) || type.localizedCaseInsensitiveContains(searcText)
                return isMatch
            }
            return false
        })
        print(searchResults)
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    @IBAction func visited(segue:UIStoryboardSegue){
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        
        if let value = segue.identifier{
            if value == "isVisited"{
                self.location.isVisited = true
            } else if value == "isDeleted" {
                let index = locations.index(of: location)!
                locations.remove(at: index)
                let context = appDelegate?.persistentContainer.viewContext
                let locationtodelete = self.fetchResultController.object(at: myIndexPath)
                context?.delete(locationtodelete)
            }
            appDelegate?.saveContext()
            tableView.reloadData()
        }
    }
    
    @IBAction func back(segue: UIStoryboardSegue) {}
    
    @IBAction func allDeleted(segue: UIStoryboardSegue) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LocationMO> = LocationMO.fetchRequest()
        if let _ = try? context.fetch(fetchRequest) {
            for i in 0..<locations.count {
                context.delete(locations[i])
            }
        }
        do {
            try context.save()
        } catch {
            print ("There was an error")
        }
        tableView.reloadData()
    }
}
