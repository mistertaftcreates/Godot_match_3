#ifndef GODOT_ADMOB_H
#define GODOT_ADMOB_H

#include <version_generated.gen.h>

#include "reference.h"


#ifdef __OBJC__
@class AdmobBanner;
typedef AdmobBanner *bannerPtr;
@class AdmobInterstitial;
typedef AdmobInterstitial *interstitialPtr;
@class AdmobRewarded;
typedef AdmobRewarded *rewardedPtr;
#else
typedef void *bannerPtr;
typedef void *interstitialPtr;
typedef void *rewardedPtr;
#endif



class GodotAdmob : public Reference {
    
#if VERSION_MAJOR == 3
    GDCLASS(GodotAdmob, Reference);
#else
    OBJ_TYPE(GodotAdmob, Reference);
#endif

    bannerPtr banner;
    interstitialPtr interstitial;
    rewardedPtr rewarded;
    

protected:
    static void _bind_methods();

public:

    void init(bool isReal, int instanceId);
    void loadBanner(const String &bannerId, bool isOnTop);
    void showBanner();
    void hideBanner();
    void resize();
    int getBannerWidth();
    int getBannerHeight();
    void loadInterstitial(const String &interstitialId);
    void showInterstitial();
    void loadRewardedVideo(const String &rewardedId);
    void showRewardedVideo();

    GodotAdmob();
    ~GodotAdmob();
};

#endif
