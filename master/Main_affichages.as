private	function defOrientation(e=0):void{
	affichage.hauteur = stage.fullScreenHeight;
	affichage.largeur = stage.fullScreenWidth;
	if (affichage.hauteur > affichage.largeur) affichage.orientation = "portrait"
	else affichage.orientation = "landscape";

	CONFIG::AUTOORIENTATION{
		if (e != 0 ) ajusteAffichage();
		}
	}

CONFIG::AUTOORIENTATION{
	private function ajusteAffichage():void{
		var liste = listePages();
		for each(var i in liste) {
			this[i].place();
			}
		}
	}

private	function retourneDiagonalePouces(resolution:Array,dpi:uint):Number{
	return (Math.sqrt(Math.pow(resolution[0],2)+Math.pow(resolution[1],2)))/dpi;
	}

public	function initAffichage():void{
	//préambule mise en page
	stage.scaleMode = StageScaleMode.NO_SCALE; 
	stage.align = StageAlign.TOP_LEFT;
	defOrientation();
	}

public	function defAffichage(specs:Object):void{
	/* specs : diagonaleDevice ou dpiDevice*/ 

	//trace("defAffichage(specs)");
	//traceObject(specs);

	var diagonaleDevicePouces;
	//trace("specs.diagonaleDevice",specs.hasOwnProperty("diagonaleDevice"));

	if (specs.hasOwnProperty("diagonaleDevice")) diagonaleDevicePouces = specs.diagonaleDevice;
	else diagonaleDevicePouces = retourneDiagonalePouces(
									[ affichage.largeur , affichage.hauteur ],
									specs.dpiDevice
									); 

	//trace("diagonaleDevicePouces",diagonaleDevicePouces);

	if (diagonaleDevicePouces <=2)								affichage.typeDevice = "smartwatch";
	if (diagonaleDevicePouces >2 && diagonaleDevicePouces <5)	affichage.typeDevice = "smartphone";
	if (diagonaleDevicePouces >= 5 && diagonaleDevicePouces <7) affichage.typeDevice = "phablet";
	if (diagonaleDevicePouces >=7 && diagonaleDevicePouces <12) affichage.typeDevice = "tablet";
	if (diagonaleDevicePouces >=12)								affichage.typeDevice = "desktop";
	
	//trace("affichage.typeDevice",affichage.typeDevice);
	
	affichage.echelles = {};
	if ( environnementDev.hasOwnProperty("echelle") ) affichage.echelles.defaut = environnementDev.echelle;
	else affichage.echelles.defaut = "px";
	//trace("affichage.echelles.defaut",affichage.echelles.defaut);
	var diagonaleEnvDevPouces = retourneDiagonalePouces(environnementDev.resolutionPx,environnementDev.dpi);
	//trace("diagonaleEnvDevPouces",diagonaleEnvDevPouces);
	affichage.echelles.cm = diagonaleDevicePouces / diagonaleEnvDevPouces;
	affichage.echelles.px = ((affichage.largeur / environnementDev.resolutionPx[0])+(affichage.hauteur / environnementDev.resolutionPx[1])) /2;
	affichage.echelles.mix = (affichage.echelles.cm+affichage.echelles.px) / 2;
//	traceObject(affichage.echelles)
	}

public	function enlevePage(nom:String):void{
	trace("enlevePage(",nom,")");

	makeDisplayList();

	if ( !listeClipsAffiches[nom] ) return;

	trace("on l'enleve")
	var listeClips:Array = [];
	var enfant;

	//trace("numChildren",listeClipsAffiches[nom].numChildren)

	for (var i = 0; i < listeClipsAffiches[nom].numChildren; i++){
		if(listeClipsAffiches[nom].getChildAt(i) is MovieClip) listeClips.push(listeClipsAffiches[nom].getChildAt(i) );
		}

	for ( i in listeClips ){
		if (listeClips[i].hasOwnProperty("enleveEcouteur")) listeClips[i].enleveEcouteur();
		if (listeClips[i].hasOwnProperty("enleveEcouteurs")) listeClips[i].enleveEcouteurs();

		//on cherche si il y a des écouteurs sur les enfants de la page
		while (listeClips[i].numChildren) {
			enfant = listeClips[i].getChildAt(0);
			CONFIG::DEBUG{//debuggage
				//trace("il faut enlever l'enfant",enfant.name,typeof(enfant));
				if (enfant.hasEventListener(MouseEvent.CLICK)) infos.nouvelleInfo(nom+"["+enfant.name+"] a un écouteur MouseEvent.CLICK");
				if (enfant.hasEventListener(Event.ENTER_FRAME)) infos.nouvelleInfo(nom+"["+enfant.name+"] a un écouteur Event.ENTER_FRAME");
				}
			listeClips[i].removeChild(enfant);
			}

		CONFIG::DEBUG{//debuggage
			if (enfant.hasEventListener(MouseEvent.CLICK)) infos.nouvelleInfo(nom+" a un écouteur MouseEvent.CLICK");
			if (enfant.hasEventListener(Event.ENTER_FRAME)) infos.nouvelleInfo(nom+" a un écouteur Event.ENTER_FRAME");
			}

		//trace(listeClips[i].name,"est à enlever aussi sur",listeClipsAffiches[nom].name,listeClipsAffiches[nom])
		listeClipsAffiches[nom].removeChild(listeClips[i]);
		listeClipsAffiches[nom][listeClips[i].name] = null;
		}

	var tableauChemin = nom.split(".");
	var poped = tableauChemin.pop();
	nom = tableauChemin.join(".");
	var cible:MovieClip;
	if (nom == "racine") cible = this;
	else cible = listeClipsAffiches[nom];
	//trace("on enleve de",cible,nom+"."+poped,cible[poped])

	cible.removeChild(cible[poped]);
	cible[poped] = null;
	listeClipsAffiches[nom] = null;
	System.gc();
	}

public	function donneProfondeur(clip:MovieClip):Object{
	var retour:int = -1;
	for (var i = 0; i < this.numChildren; i++){
		if (this.getChildAt(i) == clip) retour = i;
		}
	//trace("donneProfondeur",retour,this.numChildren-1)
	return {"position":retour,"elements":this.numChildren-1};
	}

public	function transition(depart:String,arrive:String,clipCible:MovieClip):void{
	trace("transition(",depart,arrive,clipCible,")")
	var articulation:Array = [];

	for (var i = 0; i < clipCible.numChildren; i++){
		if (clipCible.getChildAt(i) is Page) articulation.push(clipCible.getChildAt(i).name);
		trace(i,clipCible.getChildAt(i).name,clipCible.getChildAt(i).x)
		}
	var positionX = clipCible[articulation[0]].x;
	var xDepart:int;
	var xArrivee:int;
	for (i = 0; i< articulation.length; i++){
		if (articulation[i] == depart) xDepart = positionX;
		if (articulation[i] == arrive) xArrivee = positionX;
		if (clipCible[articulation[i]].hasOwnProperty("largeur")) positionX += clipCible[articulation[i]].largeur;
		else positionX += affichage.largeur;
		}
	var ecart = xArrivee - xDepart ;
	for (i=0; i< articulation.length; i++){
		Tweener.addTween(clipCible[articulation[i]], {x:clipCible[articulation[i]].x-ecart, time:0.5});
		}
	if ( clipCible.hasOwnProperty("swipe") ) clipCible.swipe.pageActuelle = arrive;
	}

public	function enleveClips(referent:* , typeElm:* ):void{
	var toRemove = [];
	for (var i = 0; i < referent.numChildren; i++){
		if(referent.getChildAt(i) is typeElm) toRemove.push(referent.getChildAt(i));
		}
	for (var ii in toRemove) {
		enleveClip(referent, toRemove[ii], false );
		}
	System.gc();
	}

public	function enleveClip(referent:* , cible:* , forceGC:Boolean = false ):void{
	trace( "enleveClip", referent.name, cible.name);
	var nom = cible.name;
	if ( cible.hasOwnProperty("enleveEcouteurs") ) cible.enleveEcouteurs();
	//referent[nom] = null;
	referent.removeChild(cible);
	if ( forceGC ) System.gc();
	}

public	function affichePages(pages:Array,niveau:MovieClip){

	var positionX:uint = 0;
	var placeDebut:String = "";
	var swipable:Boolean;
	var nom:String;
	var specs:Object = {
		"racine":this
		};

	for (var i=0; i<pages.length; i++){
		nom = pages[i].nom;
		for (var ii in pages[i]) { if (ii != "nom" && ii != "typePage") specs[ii] = pages[i][ii]; }
		niveau[nom] = new Page(niveau, pages[i].typePage, specs);
		niveau[nom].x = positionX;
		if (pages[i].hasOwnProperty("focus")) placeDebut = nom;
		if (pages[i].hasOwnProperty("swipable")) swipable = pages[i].swipable;
		else swipable = false;
		if (swipable) ajouteRegleSwipe(niveau[nom].getChildAt(0));
		if (niveau[nom].hasOwnProperty("largeur")) positionX += niveau[nom].largeur; //utile pour demi page
		else positionX += Main.affichage.largeur;
		}

	if (placeDebut != "") transition( pages[0].nom, placeDebut, niveau );
	else {
		if ( niveau.hasOwnProperty("swipe") ) niveau.swipe.pageActuelle = pages[0].nom;
		}
	}

public	function scaleChiffre(chiffre):Number{
	return chiffre * affichage.echelles[ affichage.echelles.defaut ];
	}

public	function makeDisplayList():void{
	listeClipsAffiches = [];
	checkEnfants(this,"racine");
	while (listeClipsAffichesTmp.length > 0) {
		//trace("while",listeClipsAffichesTmp.length)
		var firstEts:Object = listeClipsAffichesTmp.shift();
		listeClipsAffiches.push(firstEts);
		checkEnfants(firstEts.clip,firstEts.nom);
		}
	listeClipsAffiches.sortOn("nom", Array.CASEINSENSITIVE);
	listeClipsAffichesTmp = listeClipsAffiches;
	listeClipsAffiches = {};
	var splitNom:Array;
	var nouveauNom:String;
	for (var i in listeClipsAffichesTmp) {
		splitNom = listeClipsAffichesTmp[i].nom.split(".");
		nouveauNom = "";
		for (var p in splitNom) {
			if (splitNom[p].lastIndexOf("MC") < splitNom[p].length -2) {
				if (p > 0) nouveauNom += ".";
				nouveauNom += splitNom[p];
				}
			}
		/*if (nouveauNom.lastIndexOf("MC") == nouveauNom.length -2) {
			splitNom = nouveauNom.split(".");
			splitNom.pop();
			nouveauNom = splitNom.join(".");
			}*/
		listeClipsAffiches[nouveauNom] = listeClipsAffichesTmp[i].clip;
		}
	listeClipsAffiches["racine"] = null;
	//traceObject(listeClipsAffiches);
	listeClipsAffichesTmp = [];
	}

private	function checkEnfants(niveau:MovieClip,nom:String):void{
	for (var i = 0; i < niveau.numChildren; i++){
		if(niveau.getChildAt(i) is MovieClip) {
			listeClipsAffichesTmp.push({
				"nom":nom+"."+niveau.getChildAt(i).name,
				"clip" : niveau.getChildAt(i)
				});
			}
		}
	}