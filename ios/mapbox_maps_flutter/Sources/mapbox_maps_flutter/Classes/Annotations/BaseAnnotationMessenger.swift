import MapboxMaps
import Flutter

protocol AnnotationControllable: AnnotationManager {
    associatedtype Child: Annotation
    var annotations: [Child] { get set }
}

extension PointAnnotationManager: AnnotationControllable {}
extension CircleAnnotationManager: AnnotationControllable {}
extension PolylineAnnotationManager: AnnotationControllable {}
extension PolygonAnnotationManager: AnnotationControllable {}

class BaseAnnotationMessenger<C: AnnotationControllable> {
    private struct Storage {
        let controller: C
        let onTap: (AnnotationInteractionContext) -> Bool
        let onDrag: (AnnotationInteractionContext) -> Bool
        let onLongPress: (AnnotationInteractionContext) -> Bool
    }
    private var storage: [String: Storage] = [:]

    func tap(_ context: AnnotationInteractionContext, managerId: String) -> Bool {
        storage[managerId]?.onTap(context) ?? false
    }

    @discardableResult
    func drag(_ context: AnnotationInteractionContext, managerId: String) -> Bool {
        storage[managerId]?.onDrag(context) ?? false
    }

    func longPress(_ context: AnnotationInteractionContext, managerId: String) -> Bool {
        storage[managerId]?.onLongPress(context) ?? false
    }

    func allAnnotations(_ managerId: String) -> [C.Child] {
        storage[managerId]?.controller.annotations ?? []
    }

    private subscript(id: String) -> C? {
        return storage[id]?.controller
    }

    func add(
        controller: C,
        onTap: @escaping (AnnotationInteractionContext) -> Bool,
        onDrag: @escaping (AnnotationInteractionContext) -> Bool,
        onLongPress: @escaping (AnnotationInteractionContext) -> Bool
    ) {
        storage[controller.id] = Storage(controller: controller, onTap: onTap, onDrag: onDrag, onLongPress: onLongPress)
    }

    func removeController(id: String) {
        storage[id] = nil
    }

    func append(_ annotation: C.Child, managerId: String) throws {
        try append([annotation], managerId: managerId)
    }

    func append(_ annotations: [C.Child], managerId: String) throws {
        guard let annotationManager = self[managerId] else {
            throw AnnotationControllerError.noManagerFound
        }
        annotationManager.annotations.append(contentsOf: annotations)
    }

    func delete(annotation id: String, managerId: String) {
        self[managerId]?.annotations.removeAll(where: { $0.id == id })
    }

    func deleteAllAnnotations(from managerId: String) {
        self[managerId]?.annotations = []
    }

    func update(annotation: C.Child, managerId: String) throws {
        guard let annotationManager = self[managerId] else {
            throw AnnotationControllerError.noManagerFound
        }
        guard let indexToReplace = annotationManager.annotations.firstIndex(where: { $0.id == annotation.id }) else {
            throw AnnotationControllerError.noAnnotationFound
        }
        annotationManager.annotations[indexToReplace] = annotation
    }

    func get<T>(_ keyPath: KeyPath<C, T>, managerId: String) throws -> T {
        guard let annotationManager = self[managerId] else {
            throw AnnotationControllerError.noManagerFound
        }
        return annotationManager[keyPath: keyPath]
    }

    func set<T>(_ keyPath: ReferenceWritableKeyPath<C, T>, newValue: T, managerId: String) throws {
        guard let annotationManager = self[managerId] else {
            throw AnnotationControllerError.noManagerFound
        }
        annotationManager[keyPath: keyPath] = newValue
    }
}
