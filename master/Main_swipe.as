Main.affichage.niveauxSwipe = [];
Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT; 
private var multitouchInfos:Object = {
	"seuilPixel" : 20, //en dessous de 20 pixels on ne prends pas en compte le mouvement
	"sens":"",
	"calques":[],
	"departX":0,
	"departY":0,
	"ecartX":0,
	"ecartY":0/*,
	"cible"*/
	};



private	function ajouteRegleSwipe( clipRegle:MovieClip ):void{
	//trace("ajouteRegleSwipe",clipRegle);
	Main.affichage.niveauxSwipe.push(clipRegle);
	//swipeStart(); !!! coupé le temps de la démo
	}

private	function swipeStart():void{
	if ( !this.hasEventListener ( TouchEvent.TOUCH_BEGIN ) ) {
		trace("swipeStart()")
		addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
		addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		}
	}

private	function swipeStop():void{
	trace("swipeStop()")
	removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
	removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
	removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
	}

private function onTouchBegin(e:TouchEvent):void{
	trace("onTouchBegin")
	multitouchInfos.departX = e.stageX;
	multitouchInfos.departY = e.stageY;
	multitouchInfos.sens = "";
	multitouchInfos.calques = [];

	var cible = multitouchInfos.cible = Main.affichage.niveauxSwipe[length-1];

	var comparatif = 0;
	if ( cible.swipe.hasOwnProperty("horizontal") ) {
		comparatif += 1;
		ajouteCalquesAdeplacer(cible.swipe.horizontal,cible);
		}
	if ( cible.swipe.hasOwnProperty("vertical") ) {
		comparatif += 2;
		ajouteCalquesAdeplacer(cible.swipe.vertical,cible);
		}
	switch (comparatif){
		case 1 : multitouchInfos.sens = "X"; break; //seulement X
		case 2 : multitouchInfos.sens = "Y"; break; //seulement Y
		}
	}

private	function ajouteCalquesAdeplacer(calques:Array,clipRef:MovieClip):void{
	for (var i in calques){
		multitouchInfos.calques.push({
			"nom":calques[i],
			"X":multitouchInfos.cible[calques[i]].x,
			"Y":multitouchInfos.cible[calques[i]].y
			})
		}
	}

private function onTouchMove(e:TouchEvent):void{
	//trace("onTouchMove",e.stageX,e.stageY,multitouchInfos.sens);
	multitouchInfos.ecartX = e.stageX-multitouchInfos.departX;
	multitouchInfos.ecartY = e.stageY-multitouchInfos.departY;
	if (multitouchInfos.sens == "") {
		var comparatif = 0;
		if (Math.abs(multitouchInfos.ecartX) >= multitouchInfos.seuilPixel) comparatif += 1;
		if (Math.abs(multitouchInfos.ecartY) >= multitouchInfos.seuilPixel) comparatif += 2;
		switch (comparatif){
			case 0 : break; //pas assez de pixels
			case 1 : multitouchInfos.sens = "X"; break; //seulement X >= seuil de pixel
			case 2 : multitouchInfos.sens = "Y"; break; //seulement Y >= seuil de pixel
			case 3 : //X et Y >= seuil de pixel donc on compare
				if ( multitouchInfos.ecartX > multitouchInfos.ecartY ) multitouchInfos.sens = "X";
				if ( multitouchInfos.ecartX < multitouchInfos.ecartY ) multitouchInfos.sens = "Y";
				break;
			}
		}
 	if (multitouchInfos.sens != "") {
 		for (var i in multitouchInfos.calques) {
			multitouchInfos.cible[ multitouchInfos.calques[i].nom ][ multitouchInfos.sens.toLowerCase() ] = multitouchInfos.calques[i][ multitouchInfos.sens ] + multitouchInfos["ecart"+multitouchInfos.sens];
 			}
 		}
	}
	
private function onTouchEnd(e:TouchEvent):void{
	trace("onTouchEnd");
	var visibles:Array = [];
	var clipCible = multitouchInfos.cible;
	visibles[0] = clipCible.swipe.pageActuelle;

	//on refait un tableau avec les clips
	var liste:Array = new Array();
	for (var i in multitouchInfos.calques){
		liste.push(multitouchInfos.calques[i].nom);
		}

	//on détermine la position dans le tableau du clip qu'on déplace
	var pointeurListe = liste.indexOf(visibles[0]);
	if (multitouchInfos["ecart"+multitouchInfos.sens] > 0) pointeurListe--; //on déplace vers la droite
	else pointeurListe++; //on déplace vers la gauche
	if (pointeurListe <= liste.length-1 && pointeurListe >= 0 &&  pointeurListe !=  liste.indexOf(visibles[0]) ) visibles[1] = liste[pointeurListe];

	trace("visibles[1]",visibles[1]);

	if ( Math.abs(multitouchInfos["ecart"+multitouchInfos.sens]) >= 500 && visibles[1]) {// on anime vers la page suivante
		//on calcul la nouvelle position
		trace('on va vers une autre page')
		}
	else {//on retourne à l'origine
		var position:Number;
		for ( i in liste) {
			trace("--------------------------------------------")
			trace(liste[i]);
			//trace(multitouchInfos.sens);
			//trace(multitouchInfos.calques[i].nom);
			position = multitouchInfos.calques[i][multitouchInfos.sens];
			//trace(i,"position",position);
			if ( visibles.indexOf(liste[i]) >-1) {
				trace("anime",liste[i],position)
				swipeStop();
				switch (multitouchInfos.sens){
					case "X" : Tweener.addTween(clipCible[liste[i]], {x:position, time:0.5, onComplete:swipeStart()}); break;
					case "Y" : Tweener.addTween(clipCible[liste[i]], {y:position, time:0.5, onComplete:swipeStart()}); break;
					}
				}
			else {
				trace(liste[i],position);
				clipCible[liste[i]][multitouchInfos.sens.toLowerCase()] = position;
				}
			}
		}


	// on déplace les éléments
 	
 	//on arrete le swipe
 	
 	for (i in multitouchInfos.calques) {
 		//on anime les visibles

 		//on déplace les non visibles
		multitouchInfos.cible[ multitouchInfos.calques[i].nom ][ multitouchInfos.sens.toLowerCase() ] = multitouchInfos.calques[i][ multitouchInfos.sens ] + multitouchInfos["ecart"+multitouchInfos.sens];
 		}
 	//on relance le swipe
	}
/*
public	function clavier(sens:String):void{
	switch (sens){
		case "gauche" : 
			if (sequence == 0) racine.menuGauche.appelBouton();
			else jump(sequence-1);
			break;
		case "droite" :
			if (sequence < nEcrans-1) jump(sequence+1);
			break;
		}
	}*/