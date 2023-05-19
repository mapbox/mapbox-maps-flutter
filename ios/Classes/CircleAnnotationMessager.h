// Autogenerated from Pigeon (v3.2.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import <Foundation/Foundation.h>
@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FLTCirclePitchAlignment) {
  FLTCirclePitchAlignmentMAP = 0,
  FLTCirclePitchAlignmentVIEWPORT = 1,
};

typedef NS_ENUM(NSUInteger, FLTCirclePitchScale) {
  FLTCirclePitchScaleMAP = 0,
  FLTCirclePitchScaleVIEWPORT = 1,
};

typedef NS_ENUM(NSUInteger, FLTCircleTranslateAnchor) {
  FLTCircleTranslateAnchorMAP = 0,
  FLTCircleTranslateAnchorVIEWPORT = 1,
};

@class FLTCircleAnnotation;
@class FLTCircleAnnotationOptions;

@interface FLTCircleAnnotation : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithId:(NSString *)id
    geometry:(nullable NSDictionary<NSString *, id> *)geometry
    circleSortKey:(nullable NSNumber *)circleSortKey
    circleBlur:(nullable NSNumber *)circleBlur
    circleColor:(nullable NSNumber *)circleColor
    circleOpacity:(nullable NSNumber *)circleOpacity
    circleRadius:(nullable NSNumber *)circleRadius
    circleStrokeColor:(nullable NSNumber *)circleStrokeColor
    circleStrokeOpacity:(nullable NSNumber *)circleStrokeOpacity
    circleStrokeWidth:(nullable NSNumber *)circleStrokeWidth;
@property(nonatomic, copy) NSString * id;
@property(nonatomic, strong, nullable) NSDictionary<NSString *, id> * geometry;
@property(nonatomic, strong, nullable) NSNumber * circleSortKey;
@property(nonatomic, strong, nullable) NSNumber * circleBlur;
@property(nonatomic, strong, nullable) NSNumber * circleColor;
@property(nonatomic, strong, nullable) NSNumber * circleOpacity;
@property(nonatomic, strong, nullable) NSNumber * circleRadius;
@property(nonatomic, strong, nullable) NSNumber * circleStrokeColor;
@property(nonatomic, strong, nullable) NSNumber * circleStrokeOpacity;
@property(nonatomic, strong, nullable) NSNumber * circleStrokeWidth;
@end

@interface FLTCircleAnnotationOptions : NSObject
+ (instancetype)makeWithGeometry:(nullable NSDictionary<NSString *, id> *)geometry
    circleSortKey:(nullable NSNumber *)circleSortKey
    circleBlur:(nullable NSNumber *)circleBlur
    circleColor:(nullable NSNumber *)circleColor
    circleOpacity:(nullable NSNumber *)circleOpacity
    circleRadius:(nullable NSNumber *)circleRadius
    circleStrokeColor:(nullable NSNumber *)circleStrokeColor
    circleStrokeOpacity:(nullable NSNumber *)circleStrokeOpacity
    circleStrokeWidth:(nullable NSNumber *)circleStrokeWidth;
@property(nonatomic, strong, nullable) NSDictionary<NSString *, id> * geometry;
@property(nonatomic, strong, nullable) NSNumber * circleSortKey;
@property(nonatomic, strong, nullable) NSNumber * circleBlur;
@property(nonatomic, strong, nullable) NSNumber * circleColor;
@property(nonatomic, strong, nullable) NSNumber * circleOpacity;
@property(nonatomic, strong, nullable) NSNumber * circleRadius;
@property(nonatomic, strong, nullable) NSNumber * circleStrokeColor;
@property(nonatomic, strong, nullable) NSNumber * circleStrokeOpacity;
@property(nonatomic, strong, nullable) NSNumber * circleStrokeWidth;
@end

/// The codec used by FLTOnCircleAnnotationClickListener.
NSObject<FlutterMessageCodec> *FLTOnCircleAnnotationClickListenerGetCodec(void);

@interface FLTOnCircleAnnotationClickListener : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)onCircleAnnotationClickAnnotation:(FLTCircleAnnotation *)annotation completion:(void(^)(NSError *_Nullable))completion;
@end
/// The codec used by FLT_CircleAnnotationMessager.
NSObject<FlutterMessageCodec> *FLT_CircleAnnotationMessagerGetCodec(void);

@protocol FLT_CircleAnnotationMessager
- (void)createManagerId:(NSString *)managerId annotationOption:(FLTCircleAnnotationOptions *)annotationOption completion:(void(^)(FLTCircleAnnotation *_Nullable, FlutterError *_Nullable))completion;
- (void)createMultiManagerId:(NSString *)managerId annotationOptions:(NSArray<FLTCircleAnnotationOptions *> *)annotationOptions completion:(void(^)(NSArray<FLTCircleAnnotation *> *_Nullable, FlutterError *_Nullable))completion;
- (void)updateManagerId:(NSString *)managerId annotation:(FLTCircleAnnotation *)annotation completion:(void(^)(FlutterError *_Nullable))completion;
- (void)deleteManagerId:(NSString *)managerId annotation:(FLTCircleAnnotation *)annotation completion:(void(^)(FlutterError *_Nullable))completion;
- (void)deleteAllManagerId:(NSString *)managerId completion:(void(^)(FlutterError *_Nullable))completion;
- (void)getAnnotationsManagerId:(NSString *)managerId completion:(void(^)(NSArray<FLTCircleAnnotation *> *_Nullable, FlutterError *_Nullable))completion;
- (void)setCirclePitchAlignmentManagerId:(NSString *)managerId circlePitchAlignment:(FLTCirclePitchAlignment)circlePitchAlignment completion:(void(^)(FlutterError *_Nullable))completion;
- (void)getCirclePitchAlignmentManagerId:(NSString *)managerId completion:(void(^)(NSNumber *_Nullable, FlutterError *_Nullable))completion;
- (void)setCirclePitchScaleManagerId:(NSString *)managerId circlePitchScale:(FLTCirclePitchScale)circlePitchScale completion:(void(^)(FlutterError *_Nullable))completion;
- (void)getCirclePitchScaleManagerId:(NSString *)managerId completion:(void(^)(NSNumber *_Nullable, FlutterError *_Nullable))completion;
- (void)setCircleTranslateManagerId:(NSString *)managerId circleTranslate:(NSArray<NSNumber *> *)circleTranslate completion:(void(^)(FlutterError *_Nullable))completion;
- (void)getCircleTranslateManagerId:(NSString *)managerId completion:(void(^)(NSArray<NSNumber *> *_Nullable, FlutterError *_Nullable))completion;
- (void)setCircleTranslateAnchorManagerId:(NSString *)managerId circleTranslateAnchor:(FLTCircleTranslateAnchor)circleTranslateAnchor completion:(void(^)(FlutterError *_Nullable))completion;
- (void)getCircleTranslateAnchorManagerId:(NSString *)managerId completion:(void(^)(NSNumber *_Nullable, FlutterError *_Nullable))completion;
@end

extern void FLT_CircleAnnotationMessagerSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FLT_CircleAnnotationMessager> *_Nullable api);

NS_ASSUME_NONNULL_END
