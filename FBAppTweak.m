#import <UIKit/UIKit.h>
#import <notify.h>
#import "FBBackController.h"

static int FBNotificationToken = 0;

%ctor {
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
        [[FBBackController sharedController] performBack];
    });
}
