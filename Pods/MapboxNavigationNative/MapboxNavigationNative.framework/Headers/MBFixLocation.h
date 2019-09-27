#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MBFixLocation : NSObject

- (nonnull instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                                      time:(nonnull NSDate *)time
                                     speed:(nullable NSNumber *)speed
                                   bearing:(nullable NSNumber *)bearing
                                  altitude:(nullable NSNumber *)altitude
                        accuracyHorizontal:(nullable NSNumber *)accuracyHorizontal
                                  provider:(nullable NSString *)provider;

/** A coordinate value as defined by mapbox-bindgen (lon, lat) */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/** A timestamp value as defined by mapbox-bindgen */
@property (nonatomic, readonly, nonnull) NSDate *time;

/** The speed at which the device is moving in meters/second */
@property (nonatomic, readonly, nullable) NSNumber *speed;

/** The direction in which the device is traveling in degrees relative to due north */
@property (nonatomic, readonly, nullable) NSNumber *bearing;

/** The altitude of the device in meters above the WGS84 ellipsoid */
@property (nonatomic, readonly, nullable) NSNumber *altitude;

/** The estimated horizontal accuracy of the location, radial, in meters */
@property (nonatomic, readonly, nullable) NSNumber *accuracyHorizontal;

/** The provider of this location */
@property (nonatomic, readonly, nullable, copy) NSString *provider;


@end
