import MapboxMaps

protocol InteractableAnnotation: Annotation {
    var dragBeginHandler: ((inout Self, InteractionContext) -> Bool)? { get set }
    var dragChangeHandler: ((inout Self, InteractionContext) -> Void)? { get set }
    var dragEndHandler: ((inout Self, InteractionContext) -> Void)? { get set }
}

protocol AnnotationControllable: AnnotationManager {
    associatedtype Child: Annotation
    var annotations: [Child] { get set }
}

extension PointAnnotationManager: AnnotationControllable {}
extension CircleAnnotationManager: AnnotationControllable {}
extension PolylineAnnotationManager: AnnotationControllable {}
extension PolygonAnnotationManager: AnnotationControllable {}

class BaseAnnotationMessenger<Controller: AnnotationControllable> {
    private var controllers: [String: Controller] = [:]
    let sendGestureEvent: (AnnotationInteractionContext) -> Void

    init(sendGestureEvent: @escaping (AnnotationInteractionContext) -> Void) {
        self.sendGestureEvent = sendGestureEvent
    }

    func add(controller: Controller) {
        controllers[controller.id] = controller
    }

    func removeController(id: String) {
        controllers[id] = nil
    }

    func append<T: InteractableAnnotation>(_ annotation: T, managerId: String) throws where T == Controller.Child {
        try append([annotation], managerId: managerId)
    }

    func append<T: InteractableAnnotation>(_ annotations: [T], managerId: String) throws where T == Controller.Child {
        guard let annotationManager = controllers[managerId] else {
            throw AnnotationControllerError.noManagerFound
        }
        annotationManager.annotations.append(contentsOf: annotations)
    }

    func delete(annotation id: String, managerId: String) {
        controllers[managerId]?.annotations.removeAll(where: { $0.id == id })
    }

    func deleteAllAnnotations(from managerId: String) {
        controllers[managerId]?.annotations = []
    }

    func update(annotation: Controller.Child, managerId: String) throws {
        guard let annotationManager = controllers[managerId] else {
            throw AnnotationControllerError.noManagerFound
        }
        guard let indexToReplace = annotationManager.annotations.firstIndex(where: { $0.id == annotation.id }) else {
            throw AnnotationControllerError.noAnnotationFound
        }
        annotationManager.annotations[indexToReplace] = annotation
    }

    func get<T>(_ keyPath: KeyPath<Controller, T>, managerId: String) throws -> T {
        guard let annotationManager = controllers[managerId] else {
            throw AnnotationControllerError.noManagerFound
        }
        return annotationManager[keyPath: keyPath]
    }

    func set<T>(_ keyPath: ReferenceWritableKeyPath<Controller, T>, newValue: T, managerId: String) throws {
        guard let annotationManager = controllers[managerId] else {
            throw AnnotationControllerError.noManagerFound
        }
        annotationManager[keyPath: keyPath] = newValue
    }
}
