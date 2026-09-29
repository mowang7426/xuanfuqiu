#import "FBBottomXBridge.h"
#import <notify.h>

static NSString * const FBBottomXRequestNotification = @"com.hometapback.hometap";
static NSString * const FBBottomXResultNotification = @"com.colorblack.bottomx.hometap.result";
static NSTimeInterval const FBBottomXResponseTimeout = 0.35;

@interface FBBottomXBridge ()
@property (nonatomic, assign) int resultToken;
@property (nonatomic, assign) BOOL waitingForResult;
@property (nonatomic, copy, nullable) void (^completion)(BOOL handled);
@end

@implementation FBBottomXBridge

+ (instancetype)sharedBridge {
    static FBBottomXBridge *bridge;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bridge = [FBBottomXBridge new];
    });
    return bridge;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    __weak typeof(self) weakSelf = self;
    notify_register_dispatch(FBBottomXResultNotification.UTF8String,
                             &_resultToken,
                             dispatch_get_main_queue(),
                             ^(int token) {
        (void)token;
        __strong typeof(weakSelf) self = weakSelf;
        if (self.waitingForResult) {
            [self finishWithHandled:YES];
        }
    });
    return self;
}

- (BOOL)isBottomXAvailable {
    return NSClassFromString(@"BXTapController") != nil ||
           NSClassFromString(@"BXTapTransactionCoordinator") != nil;
}

- (BOOL)requestBackWithCompletion:(void (^)(BOOL))completion {
    if (![self isBottomXAvailable] || self.waitingForResult) {
        return NO;
    }

    self.waitingForResult = YES;
    self.completion = completion;
    notify_post(FBBottomXRequestNotification.UTF8String);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                  (int64_t)(FBBottomXResponseTimeout * NSEC_PER_SEC)),
                    dispatch_get_main_queue(), ^{
        if (self.waitingForResult) {
            [self finishWithHandled:NO];
        }
    });
    return YES;
}

- (void)finishWithHandled:(BOOL)handled {
    if (!self.waitingForResult) {
        return;
    }

    self.waitingForResult = NO;
    void (^completion)(BOOL) = self.completion;
    self.completion = nil;
    if (completion) {
        completion(handled);
    }
}

@end
