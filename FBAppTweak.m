#import <UIKit/UIKit.h>
#import <notify.h>
#import "FBBackController.h"
#import "FBBottomXBridge.h"

static int FBNotificationToken = 0;

__attribute__((constructor)) static void FBInitializeAppTweak(void) {
    NSString *bundleIdentifier = NSBundle.mainBundle.bundleIdentifier;
    if ([bundleIdentifier isEqualToString:@"com.apple.springboard"] ||
        !NSClassFromString(@"UIApplication")) {
        return;
    }

    notify_register_dispatch(FBBackNotification.UTF8String,
                             &FBNotificationToken,
                             dispatch_get_main_queue(),
                             ^(int token) {
        (void)token;
        BOOL sentToBottomX = [[FBBottomXBridge sharedBridge]
            requestBackWithCompletion:^(BOOL handled) {
            if (!handled) {
                [[FBBackController sharedController] performBack];
            }
        }];
        if (!sentToBottomX) {
            [[FBBackController sharedController] performBack];
        }
    });
}
