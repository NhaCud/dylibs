TARGET = iphone:clang:latest:14.0
ARCHS = arm64

INSTALL_TARGET_PROCESSES = Facebook

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FakeCamera

FakeCamera_FILES = Tweak.xm
FakeCamera_FRAMEWORKS = AVFoundation UIKit CoreMedia CoreVideo
FakeCamera_PLIST = FakeCamera.plist

include $(THEOS_MAKE_PATH)/tweak.mk