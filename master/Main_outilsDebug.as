
private	function afficheListeClipsNow(niveau:*,filtre:*):void{
	for (var i = 0; i < niveau.numChildren; i++){
		if(niveau.getChildAt(i) is filtre) {
			trace ('\t',i,'|\t'
			+ '\t[' + niveau.getChildIndex(niveau.getChildAt(i)) + ']'
			+ '\t name:' , niveau.getChildAt(i).name
			+ '\t' + niveau.getChildAt(i)
			+ '\t' + niveau.getChildAt(i).x,"/",niveau.getChildAt(i).y,"/",niveau.getChildAt(i).width,"/",niveau.getChildAt(i).height)
			//if (niveau.getChildAt(i).name == "base") niveau.getChildAt(i).alpha=0
			}
		else trace(i,":",typeof niveau.getChildAt(i),niveau.getChildAt(i))
		}
	}

public	function afficheListeClips(niveau:*,filtre:*,tempo:Number=0){
	 afficheListeClipsNow(niveau,filtre);
	 trace("ajouter tempo !!! ")
	}

public	function traceObject(objet:Object,deep:*=null):void{
	trace(" ////////-----------\ntraceObject");
	if ( deep != null ) {
		switch (typeof(deep)){
			case "string" : deep = [deep]; break;
			case "array" : break;
			}
		}
	else deep = [];
	for (var i in objet){
		trace(i,objet[i]);
		if (deep.indexOf(i) > -1) {
			for (var ii in objet[i]){ trace( i, ii, objet[i][ii] );}
			}
		}
	trace("-----------////////");
	}

/*public	function listePages():Array{
	trace("-----------------------------------------");
	trace("------------- listePages ----------------");
	trace("-----------------------------------------");
	var retour = new Array();
	for(var i:int = 0; i < this.numChildren; i++) {
		if(this.getChildAt(i) is Page) retour.push(this.getChildAt(i).name);
		}
	return retour;
	}*/

