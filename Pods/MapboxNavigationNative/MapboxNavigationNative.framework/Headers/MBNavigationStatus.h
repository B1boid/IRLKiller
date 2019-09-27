#import <Foundation/Foundation.h>
#import "MBRouteState.h"

@class MBBannerInstruction;
@class MBFixLocation;
@class MBVoiceInstruction;

@interface MBNavigationStatus : NSObject

- (nonnull instancetype)initWithRouteState:(MBRouteState)routeState
                                  location:(nonnull MBFixLocation *)location
                                routeIndex:(uint32_t)routeIndex
                                  legIndex:(uint32_t)legIndex
                      remainingLegDistance:(float)remainingLegDistance
                      remainingLegDuration:(NSTimeInterval)remainingLegDuration
                                 stepIndex:(uint32_t)stepIndex
                     remainingStepDistance:(float)remainingStepDistance
                     remainingStepDuration:(NSTimeInterval)remainingStepDuration
                          voiceInstruction:(nullable MBVoiceInstruction *)voiceInstruction
                         bannerInstruction:(nullable MBBannerInstruction *)bannerInstruction
                              stateMessage:(nonnull NSString *)stateMessage
                                  inTunnel:(BOOL)inTunnel
                                 predicted:(NSTimeInterval)predicted
                                shapeIndex:(uint32_t)shapeIndex
                         intersectionIndex:(uint32_t)intersectionIndex;

@property (nonatomic, readonly) MBRouteState routeState;
@property (nonatomic, readonly, nonnull) MBFixLocation *location;
@property (nonatomic, readonly) uint32_t routeIndex;
@property (nonatomic, readonly) uint32_t legIndex;
@property (nonatomic, readonly) float remainingLegDistance;
@property (nonatomic, readonly) NSTimeInterval remainingLegDuration;
@property (nonatomic, readonly) uint32_t stepIndex;
@property (nonatomic, readonly) float remainingStepDistance;
@property (nonatomic, readonly) NSTimeInterval remainingStepDuration;
@property (nonatomic, readonly, nullable) MBVoiceInstruction *voiceInstruction;
@property (nonatomic, readonly, nullable) MBBannerInstruction *bannerInstruction;
@property (nonatomic, readonly, nonnull, copy) NSString *stateMessage;
@property (nonatomic, readonly, getter=isInTunnel) BOOL inTunnel;
@property (nonatomic, readonly) NSTimeInterval predicted;
@property (nonatomic, readonly) uint32_t shapeIndex;
@property (nonatomic, readonly) uint32_t intersectionIndex;

@end
