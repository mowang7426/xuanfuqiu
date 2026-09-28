#import "FBBackController.h"

NSString * const FBBackNotification = @"com.example.floatback.perform-back";

static UIViewController *FBTopViewController(UIViewController *controller) {
    UIViewController *presented = controller.presentedViewController;
    if (presented) {
        return FBTopViewController(presented);
    }

    if ([controller isKindOfClass:[UINavigationController class]]) {
        UIViewController *visible = [(UINavigationController *)controller visibleViewController];
        return visible ? FBTopViewController(visible) : controller;
    }

    if ([controller isKindOfClass:[UITabBarController class]]) {
        UIViewController *selected = [(UITabBarController *)controller selectedViewController];
        return selected ? FBTopViewController(selected) : controller;
    }

    return controller;
}

static UIWindow *FBKeyWindow(void) {
    UIApplication *application = UIApplication.sharedApplication;
    if (application.applicationState != UIApplicationStateActive) {
        return nil;
    }

    for (UIScene *scene in application.connectedScenes) {
        if (scene.activationState != UISceneActivationStateForegroundActive ||
            ![scene isKindOfClass:[UIWindowScene class]]) {
            continue;
        }

        for (UIWindow *window in ((UIWindowScene *)scene).windows) {
            if (window.isKeyWindow && !window.hidden) {
                return window;
            }
        }
    }

    return nil;
}

@implementation FBBackController

+ (instancetype)sharedController {
    static FBBackController *controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [FBBackController new];
    });
    return controller;
}

- (void)performBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = FBKeyWindow();
        UIViewController *root = window.rootViewController;
        UIViewController *top = root ? FBTopViewController(root) : nil;

        if (top.presentingViewController) {
            [top dismissViewControllerAnimated:YES completion:nil];
            return;
        }

        UINavigationController *navigationController = top.navigationController;
        if (navigationController.viewControllers.count > 1) {
            [navigationController popViewControllerAnimated:YES];
            return;
        }
    });
}

@end
