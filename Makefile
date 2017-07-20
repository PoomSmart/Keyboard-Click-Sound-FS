PACKAGE_VERSION = 0.0.4
TARGET = iphone:clang:latest:5.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = KeyboardClicks
KeyboardClicks_FILES = Switch.xm
KeyboardClicks_LIBRARIES = flipswitch
KeyboardClicks_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk
