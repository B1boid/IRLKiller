#import <Foundation/Foundation.h>

@interface MBRouterResult : NSObject

- (nonnull instancetype)initWithJson:(nonnull NSString *)json
                             success:(BOOL)success;

@property (nonatomic, readonly, nonnull, copy) NSString *json;
@property (nonatomic, readonly, getter=isSuccess) BOOL success;

@end
