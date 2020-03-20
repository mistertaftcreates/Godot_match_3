extends Node

var admob
var real_ads = false
var banner_on_top = false
var banner_ad_id = ""
var interstitial_ad_id = ""
var ads_enabled = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.has_singleton("admob"):
		print("okay")
		admob = Engine.get_singleton("admob")
		admob.init(real_ads, get_instance_id())
		admob.loadBanner(banner_ad_id, banner_on_top)
		admob.loadInterstitial(interstitial_ad_id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
