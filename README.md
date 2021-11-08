# Shortcut-code-challenge

### Services and network portion

#### Development Branch
in this branch the services portion consist of 3 files:

##### Network
this class responsible for generating URL and connecting to the remote server and handle the success state or failed with appropriate escaping funcs.


in the following function I get two static parts of url from plist file and generate a raw url.

`{0}` will be changed with comic number or be eliminated if we try to get the current comic.

```swift
public static let shared: Network = {
        let file = Bundle.main.path(forResource: "ServerEnvironments", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: file)!
        let serviceURLString = dictionary["service_url"] as! String
        let destinationFileString = dictionary["destination_file"] as! String
        let retObj = "\(serviceURLString){0}/\(destinationFileString)"
        return Network(baseURLString: retObj)
    }()
```


the following func responsible for getting data from remote server (API) and call appropriate closure (success or failure)

* Note: If you want to get current comic you shold just send nil for fileId

```swift
func getData<T: Codable>(fileId: Int?, success _success: @escaping(T) -> Void,
                             failure _failure: @escaping(NetworkErrors) -> Void)
```

##### NetworkErrors

this class consist of network error types and it consist of two parts networkError titles and error descriptions (string)


##### ServerEnvironments

this Plist file has two string parameters that are used for creating URL

------


#### withDesignPatterns Branch

in addition of previous explanation here are two other parts 

##### Image Download Service
this group responsible to download image and send to detailVC

##### Chain network
This group responsible for throwing objec model or choose appropriate action if the server's response status code is not success






### Extensions

#### development branch

there is just one swift onject is extended in this project (Int) and I just added a varibale to make convenient checking success HTTP code.

#### withDesignPatterns branch
there is a new extension here for UIWindow that includes a func to get the root viewcontroller







### Model

model has 3 classes that one of them related to remote API (ComicModel) and two others use for CoreData.





### Viewcontroller

view controller has 3 parts that will be explained:

#### Browse controller

this part includes browse and search comics

##### BrowseVC.swift

it is the main class for browse controller 

* comics are get one by one from current to 1 and they receive every 20 `comicBunchCount:Int` and even you scroll to the bottom of table view 20 others will be loaded 

##### BrowseTVC.swift

this class uses to show comic cells

##### BrowseTVHandler.swift
 an extension of BrowseVC for handling tableView
 
 the following func uses for load bunch of comics
 
 ```swift
 func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
 ```
 
 ##### WaitingTVC.swift
 this class uses for waiting indicator cell
 
 ##### SearchSRUHandler.swift
 this extension handles search activity
 
 ##### SearchSBHandler.swift
 this is an extension of browseVC to get searchbar delegation funcs.
 
 ##### NotificationPermission.swift
 
 this extension uses to get push notification permission from user. it is called on `BrowseVC->viewDidLoad()`
 
 
 ----
 
 
 #### DetailVC
 
 this class the only class for detail view, 
 
 * comic can save to favorite after loading image. `bookMarkButtonPress(_:)`
 * comic photo be able to share after image is loaded completely. `shareButtonPress(_:)`


##### withDesignPatterns Branch
here is new file called `DetailImageDownloader` that manages observer extension of detailVC.


----


#### Favorite Controller

##### FavoriteVC.swift
this is the main class of Favorite view, this part loads only data which saved on coreData.

##### FavoriteTVHandler.swift

the is an extension of favoriteVC for handling its tableview.

* you can remove a favorite object with swap it:

```swift
 func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let itemId = data[indexPath.row].num
            let fetch = NSFetchRequest<ComicEntity>(entityName: "ComicEntity")
            fetch.predicate = NSPredicate(format:"num == \(itemId)")
            if let object = (try? managedContext.fetch(fetch))?.first {
                managedContext.delete(object)
            }
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            print(indexPath.row)
        }
    }
```






### IBDesignable

there is just a class to create a custom rounded button for using as share button `Custom Button.swift`






### Enums

#### publicNamesEnum.swift
this enum file uses for saving public keys for communicate to userDefaults to save and fetch simple objects.





### notify new comics
it is handled by `BGTaskScheduler` that is defined on appDelegate.






### More Informations about the project
- there is two options for saving favorite data on the device , first is using userDefault for saving the model and save image on project's document folder. the next one is using core data to save them. I used the second one because it seems more complex and you may judge me better.

- there is two final branches : one of them development ( or master) that developes with clean and simple code , the second is `withDesignPatterns` branch that I used chain of risponsibility pattern for network portion and observer pattern for downloading image from remote server. I wrote the first one is more clean than the second because in this project we do not need to handle API error codes and also downloading image without observer pattern is much more clear, but I used them in another branch to show my knowledge, I also know many other design patterns ( approximately more than 10) but there isn't any place that I could use them. ( so there are 3 design patterns are used in this project , singleton in network ( in all branches), chain of responsibility and observer for network and downloading image respectively ( in withDesignPatterns branch)
