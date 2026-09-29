ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FloatBackSpringBoard FloatBackApps

FloatBackSpringBoard_FILES = Tweak.xm
FloatBackSpringBoard_CFLAGS = -fobjc-arc
FloatBackSpringBoard_FRAMEWORKS = UIKit
FloatBackSpringBoard_PRIVATE_FRAMEWORKS = SpringBoardServices

FloatBackApps_FILES = FBAppTweak.m FBBackController.m FBBottomXBridge.m
FloatBackApps_CFLAGS = -fobjc-arc
FloatBackApps_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"
