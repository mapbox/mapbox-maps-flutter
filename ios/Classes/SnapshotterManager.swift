import Foundation
import MapboxMaps

class SnapshotterManager : NSObject, FLT_SnapshotterMessager {
    
    private var delegate: SnapshotControllerDelegate
    private static let errorCode = "0"
    
    init(withDelegate delegate: SnapshotControllerDelegate) {
        self.delegate = delegate
    }
    
    func cancelId(_ id: String, error flutterError: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        do {
            try delegate.getSnapshotter(id: id).cancel()
        } catch {
            flutterError.pointee = FlutterError(code: SnapshotterManager.errorCode, message: error.localizedDescription, details: nil)
        }
    }
    
    func destroyId(_ id: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        delegate.remove(id: id)
    }
    
    func setCameraId(_ id: String, cameraOptions: FLTCameraOptions, error flutterError: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        do {
            try delegate.getSnapshotter(id: id).setCamera(to: cameraOptions.toCameraOptions())
        } catch {
            flutterError.pointee = FlutterError(code: SnapshotterManager.errorCode,message: error.localizedDescription,details: nil)
        }
    }
    
    func setStyleUriId(_ id: String, styleUri: String, error flutterError: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        do {
            try delegate.getSnapshotter(id: id).styleURI = StyleURI.init(rawValue: styleUri)
        } catch {
            flutterError.pointee = FlutterError(code: SnapshotterManager.errorCode,message: error.localizedDescription,details: nil)
        }
    }
    
    func setStyleJsonId(_ id: String, styleJson: String, error flutterError: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        do {
            try delegate.getSnapshotter(id: id).styleJSON = styleJson
        } catch {
            flutterError.pointee = FlutterError(code: SnapshotterManager.errorCode,message: error.localizedDescription,details: nil)
        }
    }
    
    func setSizeId(_ id: String, size: FLTSize, error flutterError: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        do {
            try delegate.getSnapshotter(id: id).snapshotSize = CGSize(width: size.width, height: size.height)
        } catch {
            flutterError.pointee = FlutterError(code: SnapshotterManager.errorCode,message: error.localizedDescription,details: nil)
        }
    }
    
    func camera(forCoordinatesId id: String, coordinates: [[String : Any]], padding: FLTMbxEdgeInsets, bearing: NSNumber?, pitch: NSNumber?, error flutterError: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCameraOptions? {
        do {
            let cameraOptions = try delegate.getSnapshotter(id: id).camera(for: coordinates.compactMap(convertDictionaryToCLLocationCoordinate2D(dict:)), padding: padding.toUIEdgeInsets(), bearing: bearing?.doubleValue, pitch: pitch?.doubleValue)
            return cameraOptions.toFLTCameraOptions()
        } catch {
            flutterError.pointee = FlutterError(code: SnapshotterManager.errorCode,message: error.localizedDescription,details: nil)
            return nil
        }
    }
    
    func coordinateBounds(forCameraId id: String, camera: FLTCameraOptions, error flutterError: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCoordinateBounds? {
        do {
            let coordinateBounds = try delegate.getSnapshotter(id: id).coordinateBounds(for: camera.toCameraOptions())
            return coordinateBounds.toFLTCoordinateBounds()
        } catch {
            flutterError.pointee = FlutterError(code: SnapshotterManager.errorCode,message: error.localizedDescription,details: nil)
            return nil
        }
    }
    
    func getCameraStateId(_ id: String, error flutterError: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCameraState? {
        do {
            let camera = try delegate.getSnapshotter(id: id).cameraState
            return camera.toFLTCameraState()
        } catch {
            flutterError.pointee = FlutterError(code: SnapshotterManager.errorCode,message: error.localizedDescription,details: nil)
            return nil
        }
    }
    
    func getSizeId(_ id: String, error flutterError: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTSize? {
        do {
            let size = try delegate.getSnapshotter(id: id).snapshotSize
            return size.toFLTSize()
        } catch {
            flutterError.pointee = FlutterError(code: SnapshotterManager.errorCode,message: error.localizedDescription,details: nil)
            return nil
        }
    }
    
    func getStyleJsonId(_ id: String, error flutterError: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> String? {
        do {
            let json = try delegate.getSnapshotter(id: id).styleJSON
            return json
        } catch {
            flutterError.pointee = FlutterError(code: SnapshotterManager.errorCode,message: error.localizedDescription,details: nil)
            return nil
        }
    }
    
    func getStyleUriId(_ id: String, error flutterError: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> String? {
        do {
            let uri = try delegate.getSnapshotter(id: id).styleURI
            return uri?.rawValue
        } catch {
            flutterError.pointee = FlutterError(code: SnapshotterManager.errorCode,message: error.localizedDescription,details: nil)
            return nil
        }
    }
    
    func startId(_ id: String, completion: @escaping (FLTMbxImage?, FlutterError?) -> Void) {
        do {
            try delegate.getSnapshotter(id: id).start(overlayHandler: nil) { snapshotResult in
                let image = try? snapshotResult.get()
                if  image != nil {
                    completion(image!.toFLTMbxImage(),nil)
                } else {
                    completion(nil,FlutterError(code: SnapshotterManager.errorCode,message: "snapshot fail",details: nil))
                }
            }
        } catch {
            completion(nil,FlutterError(code: SnapshotterManager.errorCode,message: error.localizedDescription,details: nil))
        }
    }
    
}
