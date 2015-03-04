public	function teinteClip(mc:DisplayObject, val:Number){
	var colorTransform:ColorTransform = new ColorTransform();
	colorTransform.color = val;
	mc.transform.colorTransform = colorTransform;
	}

public	function fondu(sens:String,clip:String,action:Object=null):void{
	var transparence:uint;
	switch (sens){
		case "in"	: transparence = 1; break;
		case "out"	: transparence = 0; break;
		}
	Tweener.addTween(this[clip],{alpha:transparence,transition:"easeInQuart",time:.5,onComplete:action});
	}

public	function blurClips(inclus:Array,blur:Boolean,makedisplaylist:Boolean = false){
	var effet =	new BlurFilter(10, 10, 1);
	if (blur) {
		if (makedisplaylist) makeDisplayList();
		for (var i in inclus) {
			if (makedisplaylist) listeClipsAffiches[inclus[i]].filters = [effet];
			else this[inclus[i]].filters = [effet];
			}
		}
	else {
		for ( i in inclus) {
			if (makedisplaylist) listeClipsAffiches[inclus[i]].filters = [];
			else this[inclus[i]].filters = [];
			}
		}
	}