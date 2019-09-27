#import <Foundation/Foundation.h>

@interface MBVoiceInstruction : NSObject

- (nonnull instancetype)initWithSsmlAnnouncement:(nonnull NSString *)ssmlAnnouncement
                                    announcement:(nonnull NSString *)announcement
                           remainingStepDistance:(float)remainingStepDistance
                                           index:(uint32_t)index;

@property (nonatomic, readonly, nonnull, copy) NSString *ssmlAnnouncement;
@property (nonatomic, readonly, nonnull, copy) NSString *announcement;
@property (nonatomic, readonly) float remainingStepDistance;
@property (nonatomic, readonly) uint32_t index;

@end
