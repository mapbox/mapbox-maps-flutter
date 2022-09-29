import UIKit
import MapboxMaps

struct YourData {
    var coordinate: CLLocationCoordinate2D
    var identifier: String
}

final class PhotosMapViewController: UIViewController {

    private let photoSearch: PhotoSearch
    private var pointAnnotationManager: PointAnnotationManager!
    @IBOutlet var queryTextField: UITextField!
    @IBOutlet var mapView: MapView!

    required init?(coder: NSCoder, photoSearch: PhotoSearch) {
        self.photoSearch = photoSearch
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryTextField.text = photoSearch.query
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: PhotoSearch.resultsDidChange,
            object: photoSearch)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(syncQueryToTextField),
            name: PhotoSearch.queryDidChange,
            object: photoSearch)

        mapView.ornaments.options.scaleBar.visibility = .hidden
        mapView.ornaments.options.compass.visibility = .hidden

        // Create a point annotation manager and store it.
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()

        // Here's some sample data:

        let center = CLLocationCoordinate2D(latitude: 40, longitude: -75)
        let someData = "abcdefghijklmnopqrstuvwxyz".map {
            YourData(
                coordinate: CLLocationCoordinate2D(
                    latitude: center.latitude + .random(in: -0.005...0.005),
                    longitude: center.longitude + .random(in: -0.005...0.005)),
                identifier: String($0))
        }

        // Here's how you can show annotations for each data item
        pointAnnotationManager.annotations = someData.map {
            var annotation = PointAnnotation(coordinate: $0.coordinate)
            annotation.image = .init(image: UIImage(named: "red_pin")!, name: "red_pin")
            annotation.iconAnchor = .bottom
            annotation.iconOffset = [0, 5]
            return annotation
        }

        // Let's set the map's camera to frame the data
        mapView.mapboxMap.setCamera(to: mapView.mapboxMap.camera(for: someData.map(\.coordinate), padding: .zero, bearing: nil, pitch: nil))
    }

    @objc private func reload() {
        // TODO
    }

    @objc private func syncQueryToTextField() {
        queryTextField.text = photoSearch.query
    }

    @IBAction func syncQueryToPhotoSearch() {
        photoSearch.query = queryTextField.text ?? ""
    }
}
