import Foundation
import MapboxMaps

public enum SnapshotControllerError: Error {
    case noSnapshotterFound
}

public protocol SnapshotControllerDelegate : AnyObject {
    func getSnapshotter(id: String) throws -> Snapshotter
    
    func remove(id: String)
}

class SnapshotController: NSObject,FLT_SnapShotManager,SnapshotControllerDelegate {
 
    private var mapView: MapView
    private var onSnapshotStyleListener: FLTOnSnapshotStyleListener?
    private var snapshotterMap: [String: Snapshotter] = [:]
    private var cancelables: [String: Set<AnyCancelable>] = [:]
    private var snapshotter: SnapshotterManager?
    
    init(mapView: MapView) {
        self.mapView = mapView
        super.init()
        snapshotter = SnapshotterManager(withDelegate: self)
    }
    
    func createOptions(_ options: FLTMapSnapshotOptions, overlayOptions: FLTSnapshotOverlayOptions, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> String? {
        let snapshotOptions = MapSnapshotOptions.init(size: CGSize(width: options.size.width, height: options.size.height), pixelRatio: options.pixelRatio,showsLogo: overlayOptions.showLogo,showsAttribution: overlayOptions.showAttributes)
        let snapshotter = Snapshotter(options: snapshotOptions)
        let id = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        snapshotterMap[id] = snapshotter
        
        cancelables[id] = Set()
        
        snapshotter.onStyleLoaded.observe { [weak self] style in
            self?.onSnapshotStyleListener?.onDidFinishLoadingStyle(completion: { flutterError in
            })
        }.store(in: &cancelables[id]!)
    
        snapshotter.onStyleDataLoaded.observe { [weak self] styleDataLoad in
            self?.onSnapshotStyleListener?.onDidFullyLoadStyle(completion: { flutterError in
                
            })
        }.store(in: &cancelables[id]!)
        
        snapshotter.onMapLoadingError.observe { [weak self] mapLoadingError in
            self?.onSnapshotStyleListener?.onDidFailLoadingStyleMessage(mapLoadingError.message, completion: { flutterError in
                
            })
        }.store(in: &cancelables[id]!)
        
        snapshotter.onStyleImageMissing.observe { [weak self] styleImageMissing in
            self?.onSnapshotStyleListener?.onStyleImageMissingImageId(styleImageMissing.imageId, completion: { flutterError in
                
            })
        }.store(in: &cancelables[id]!)
        
        return id
    }
    
    func snapshot(completion: @escaping (FLTMbxImage?, FlutterError?) -> Void) {
        let uiImage = try? mapView.snapshot()
        guard let image = uiImage else {
            completion(nil,nil)
            return
        }
        completion(image.toFLTMbxImage(), nil)
    }
    
    
    func setup(messager: FlutterBinaryMessenger) {
        SetUpFLT_SnapShotManager(messager, self)
        onSnapshotStyleListener = FLTOnSnapshotStyleListener.init(binaryMessenger: messager)
        SetUpFLT_SnapshotterMessager(messager, snapshotter)
    }
    
    func getSnapshotter(id: String) throws -> MapboxMaps.Snapshotter {
        if snapshotterMap[id] == nil {
            throw SnapshotControllerError.noSnapshotterFound
        }
        return snapshotterMap[id]!
    }
    
    func remove(id: String) {
        snapshotterMap.removeValue(forKey: id)
        cancelables[id]?.forEach({ anyCancelable in
            anyCancelable.cancel()
        })
        cancelables[id]?.removeAll()
    }
}
