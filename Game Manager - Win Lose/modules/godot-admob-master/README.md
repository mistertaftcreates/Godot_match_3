AdMob
=====
This is the AdMob module for Godot Engine (https://github.com/okamstudio/godot)
- Android & iOS
- Banner
- Interstitial
- Rewarded Video

How to use
----------

### Android
To use this module you'll need a custom template for Android. You can build it by yourself or download a precompiled one.
Another option available for Godot 3.2+ is the [new Android plugin system](https://godotengine.org/article/godot-3-2-will-get-new-android-plugin-system), much easier to use (no recompilation needed). You can find a port of this module using this system [here](https://github.com/Shin-NiL/Godot-Android-Admob-Plugin).

#### Compiling the template (First Option)
This is harder, but you'll have more control over the building process. You can, for example, include any other module you want.
For that, do the following steps:
- Clone or download this repository.
- Clone or download the [Godot Engine repository](https://github.com/godotengine/godot/). One important note here is that this must match the same version of the Godot editor you're using to develop your game.
- Drop the "admob" directory inside the "modules" directory on the Godot source.
- Recompile the android export template following the [official instructions](http://docs.godotengine.org/en/latest/reference/compiling_for_android.html#compiling-export-templates).

#### Using precompiled templates (Second Option)
If you don't want or can't build the template by yourself, you can find a precompiled template with this module [here](https://github.com/Shin-NiL/godot-custom-mobile-template). Go to the release tab and download the zip file.

#### Export configuration
- In your project goto Export > Target > Android:
	- Options:
		- Custom Package:
			- place the template apk you had compiled (or downloaded)
		- Permissions on:
			- Access Network State
			- Internet
### iOS
- Drop the "admob" directory inside the "modules" directory on the Godot source;
- Download and extract the [Google Mobile Ads SDK](https://developers.google.com/admob/ios/download) **(<= 7.41.0)** inside the directory "admob/ios/lib";
- [Recompile the iOS export template](http://docs.godotengine.org/en/stable/development/compiling/compiling_for_ios.html).

Configuring your game
---------------------

### Android
To enable the module on Android, add the path to the module to the "modules" property on the [android] section of your  ```engine.cfg``` file (Godot 2) or ```project.godot``` (Godot 3). It should look like this:

	[android]
	modules="org/godotengine/godot/GodotAdMob"

If you have more separate by comma.

### iOS
Follow the [exporting to iOS official documentation](http://docs.godotengine.org/en/stable/learning/workflow/export/exporting_for_ios.html).

#### Godot 2
Just make sure you're using your custom template (compiled in the previous step), for that  rename it to "godot_opt.iphone" and replace the file with same name inside the Xcode project.

#### Godot 3
- Export your project from Godot, it'll create an Xcode project;
- Copy the library (.a) you have compiled following the official documentation inside the exported Xcode project. You must override the 'your_project_name.a' file with this file.
- Copy the GoogleMobileAds.framework inside the exported Xcode project folder and link it using the "Link Binary with Libraries" option;
- Add the following frameworks to the project:
	- StoreKit
	- GameKit
	- CoreVideo
	- AdSupport
	- MessageUI
	- CoreTelephony
	- CFNetwork
	- MobileCoreServices
	- SQLite

API Reference (Android & iOS)
-------------

The following methods are available:
```python

# Init AdMob
# @param bool isReal Show real ad or test ad
# @param int instance_id The instance id from Godot (get_instance_ID())
init(isReal, instance_id)

# Init AdMob with additional Content Rating parameters (Android Only)
# @param bool isReal Show real ad or test ad
# @param int instance_id The instance id from Godot (get_instance_ID())
# @param boolean isForChildDirectedTreatment If isForChildDirectedTreatment is true, maxAdContetRating will be ignored (your maxAdContentRating would can not be other than "G")
# @param String maxAdContentRating It's value must be "G", "PG", "T" or "MA". If the rating of your app in Play Console and your config of maxAdContentRating in AdMob are not matched, your app can be banned by Google.
initWithContentRating(isReal, instance_id, isForChildDirectedTreatment, maxAdContentRating)


# Banner Methods
# --------------

# Load Banner Ads (and show inmediatly)
# @param String id The banner unit id
# @param boolean isTop Show the banner on top or bottom
loadBanner(id, isTop)

# Show the banner
showBanner()

# Hide the banner
hideBanner()

# Resize the banner (when orientation change for example)
resize()

# Get the Banner width
# @return int Banner width
getBannerWidth()

# Get the Banner height
# @return int Banner height
getBannerHeight()

# Callback on ad loaded (Banner)
_on_admob_ad_loaded()

# Callback on ad network error (Banner)
_on_admob_network_error()

# Callback for banner on ad failed to load (other than network error)
_on_admob_banner_failed_to_load()

# Interstitial Methods
# --------------------

# Load Interstitial Ads
# @param String id The interstitial unit id
loadInterstitial(id)

# Show the interstitial ad
showInterstitial()

# Callback for interstitial ad fail on load
_on_interstitial_not_loaded()

# Callback for interstitial loaded
_on_interstitial_loaded

# Callback for insterstitial ad close action
_on_interstitial_close()

# Rewarded Videos Methods
# -----------------------

# Load rewarded videos ads
# @param String id The rewarded video unit id
loadRewardedVideo(id)

# Show the rewarded video ad
showRewardedVideo()

# Callback for rewarded video ad left application
_on_rewarded_video_ad_left_application()

# Callback for rewarded video ad closed 
_on_rewarded_video_ad_closed()

# Callback for rewarded video ad failed to load
# @param int errorCode the code of error
_on_rewarded_video_ad_failed_to_load(errorCode)

# Callback for rewarded video ad loaded
_on_rewarded_video_ad_loaded()

# Callback for rewarded video ad opened
_on_rewarded_video_ad_opened()

# Callback for rewarded video ad reward user
# @param String currency The reward item description, ex: coin
# @param int amount The reward item amount
_on_rewarded(currency, amount)

# Callback for rewarded video ad started do play
_on_rewarded_video_started()
```

Known Issues
--------------
* You can't use Rewarded Video and any other ad type (Banner and/or Interstitial) at same time on iOS or your app will crash with the error ```Multiple locks on web thread not allowed``` when the Reward is closed. To fix this, we need help from an iOS developer as I don't have any Apple hardware to do it by myself. You can see more details about this issue [here](https://github.com/kloder-games/godot-admob/issues/53). You can find a workaround for this issue [here](https://github.com/kloder-games/godot-admob/issues/53#issuecomment-501540139).


Troubleshooting
--------------

* First of all, please make sure you're able to compile the custom template without the Admob module, this way we can isolate the cause of the issue.

* Using the Xcode debug console for iOS and logcat for Android is the best way to troubleshoot most issues. You can filter Godot only messages with logcat using the command: ```adb logcat -s godot```

* _ERROR_CODE_NO_FILL_ is a common issue with Admob, but out of the scope to this module. Here's the description on the API page: [ERROR_CODE_NO_FILL: The ad request was successful, but no ad was returned due to lack of ad inventory.](https://developers.google.com/android/reference/com/google/android/gms/ads/AdRequest.html#ERROR_CODE_NO_FILL)

* If you're getting the error ```Undefined symbols for architecture armv7``` compiling for iOS, you should try open up the project in xcode, go to "General" tab, remove "GoogleMobileAds.framework" from frameworks, then re-add it. Should build then. Also, make sure you have directory godot/modules/admob/ios/lib added to framework search path (“Build Settings”). More info [here](https://github.com/kloder-games/godot-admob/issues/90#issuecomment-501608259).

References
-------------
Based on the work of:
* https://github.com/Mavhod/GodotAdmob

License
-------------
MIT license
