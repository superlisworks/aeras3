package {
	import flash.display.MovieClip;

	public class Page extends MovieClip {
		private	var racine:MovieClip;
		private	var baseX:uint;
		private	var baseY:uint;
		public	var clip:MovieClip;
		private	var echelleDevice:Number;

		public	function Page(referent:MovieClip,elements:Object,specs:Object=null) {
			if (specs) {
				if (specs.hasOwnProperty("racine") ) {
					racine = specs.racine;
					}
				}
			else racine = referent;
			var specsPage = new Object;
			if (specs != null)  specsPage = specs;
			if (specsPage.racine == undefined) specsPage.racine = referent;

			clip = new elements(specsPage);
			var nomTmp = clip.name;
			clip.name += "MC";
			addChild(clip);
			this.name = nomTmp;
			referent.addChild(this);
			if (clip.hasOwnProperty("echelle")) echelleDevice = Main.affichage["echelles"+clip.echelles];
			else echelleDevice = Main.affichage.echelles[Main.affichage.echelles.defaut];
			var fonctionPlace = place();
			if (clip.hasOwnProperty("traduction")) {
				for (var i in clip.traduction) {
					var longeur:Array = i.split(".");
					switch (longeur.length){
						case 1 : clip[longeur[0]].text = racine.langue.traduit(clip.traduction[i]); break;
						case 2 : clip[longeur[0]][longeur[1]].text = racine.langue.traduit(clip.traduction[i]); break;
						case 3 : clip[longeur[0]][longeur[1]][longeur[2]].text = racine.langue.traduit(clip.traduction[i]); break;
						}
					}
				}
			if (clip.hasOwnProperty("enlevePage")) {
				//trace("on leve la page",clip.enlevePage)
				//racine.afficheListeClips(racine,MovieClip);
				if (typeof clip.enlevePage == "string") racine.enlevePage(clip.enlevePage);
				if (typeof clip.enlevePage == "array") {
					for each (var cible in clip.enlevePage){
						racine.enlevePage(cible);
						}
					}
				}
			}

		private	function determinePositionExtremite(cible:String, coordonnee:*):Number{
			var retour:Number;
			var correctif:Number = 0;
			var alignement:String;
			var determine:Array = coordonnee.split(" + ");
			if (determine.length > 1) {
				alignement = determine[0];
				correctif = Number(determine[1]) * echelleDevice;
				}
			else {
				determine = coordonnee.split(" - ");
				if (determine.length > 1)  {
					alignement = determine[0];
					correctif = -Number(determine[1]) * echelleDevice;
					}
				}
			if (correctif == 0) alignement = coordonnee;
			switch (alignement) {
				case "right_page" : 
					retour = Main.affichage.largeur-clip[cible].width + correctif;
					break;
				case "left_page" : 
					retour = 0 + correctif;
					break;
				case "bottom_page" : 
					retour = Main.affichage.hauteur-clip[cible].height + correctif;
					break;
				case "top_page" : 
					retour = 0 + correctif;
					break;
				default : 
					retour = Number(alignement);
					break;
				}
			return retour;
			}

		private	function deplace(cible:String,axe:String,coordonnee:*):void{
			//coordonnee peut être une chaine ou un nombre 
			if (typeof(coordonnee) == "string") {
				switch (coordonnee) {
					case "center": 
						if (axe == "x") clip[cible].x=(Main.affichage.largeur-clip[cible].width)/2;
						if (axe == "y") clip[cible].y=(Main.affichage.hauteur-clip[cible].height)/2;
						break;
					case "justify" : 
						if (axe == "x") {
							clip[cible].width=Main.affichage.largeur;
							clip[cible].x=0;
							}
						if (axe == "y") {
							clip[cible].height=Main.affichage.hauteur;
							clip[cible].y=0;
							}
						break;
					case "right_page" : 
						clip[cible].x = Main.affichage.largeur-clip[cible].width;
						break;
					case "left_page" : 
						clip[cible].x = 0;
						break;
					case "bottom_page" : 
						clip[cible].y = Main.affichage.hauteur-clip[cible].height;
						break;
					case "top_page" : 
						clip[cible].y = 0;
						break;
					default : 
						if (axe == "x") clip[cible].x= determinePositionExtremite(cible,coordonnee); 
						if (axe == "y") clip[cible].y= determinePositionExtremite(cible,coordonnee); 
						break;
					}
				}
			else {
				//trace("deplace",cible,axe,Number(coordonnee))
				if (axe == "x") clip[cible].x= coordonnee*echelleDevice; 
				if (axe == "y") clip[cible].y= coordonnee*echelleDevice;
				}
			}

		private	function echelle(cible:String,axe:String,coef:*):void{
			//trace("echelle",cible,axe,coef, typeof (coef));
			if (typeof coef == "string"){
				//trace("taille:",coef)
				coef = coef.split("px");
				if (coef[0] == "justify") {
					switch (axe){
						case "X" : coef = Main.affichage.largeur; break;
						case "Y" : coef = Main.affichage.hauteur; break;
						}
					}
				else coef = Number(coef[0]);
				//trace("taille:",coef)
				if (axe == "X") coef = coef / clip[cible].width;
				if (axe == "Y") coef = coef / clip[cible].height;
				//trace("coef:",coef)
				}
			switch (axe){
				case "X" : clip[cible].scaleX = coef*echelleDevice; break;
				case "Y" : clip[cible].scaleY = coef*echelleDevice; break;
				}
			//trace("->",clip[cible].width,clip[cible].height)
			}

		private	function dimension(cible:String,axe:Array,taille:*):void{
			//taille peut être une chaine ou un nombre 
			switch (axe){
				case "X" : 
					if (typeof taille == "String") clip[cible].scaleX = clip[cible].scaleY*echelleDevice;
					else clip[cible].width = taille*echelleDevice;
					break;
				case "Y" : 
					if (typeof taille == "String") clip[cible].scaleY = clip[cible].scaleX*echelleDevice;
					else clip[cible].height = taille*echelleDevice;
					break;
				}
			}

		public	function place(){
			if (typeof Main.affichage.orientation == "undefined") {
				//trace("orientation non définie");
				return;
				}

			for each(var obj in clip.miseEnPage[Main.affichage.orientation]){


				//on met à l'échelle
				//trace(obj.name,"echelleDevice",echelleDevice);
				obj.largeurOrig = clip[obj.name].width;
				obj.hauteurOrig = clip[obj.name].height;
				//trace(obj.name,clip[obj.name].scaleX,clip[obj.name].scaleY )

				clip[obj.name].scaleX = clip[obj.name].scaleX * echelleDevice;
				clip[obj.name].scaleY = clip[obj.name].scaleY * echelleDevice;

				//trace(obj.name,clip[obj.name].scaleX,clip[obj.name].scaleY )

				
				if (obj.hasOwnProperty("Xscale"))				echelle(obj.name,"X",obj.Xscale);
				if (obj.hasOwnProperty("Yscale"))				echelle(obj.name,"Y",obj.Yscale);
				if (obj.hasOwnProperty("scale"))				{echelle(obj.name,"X",obj.scale);echelle(obj.name,"Y",obj.scale);}
				if (obj.hasOwnProperty("x"))					deplace(obj.name,"x",obj.x);
				if (obj.hasOwnProperty("y"))					deplace(obj.name,"y",obj.y);

				if (obj.hasOwnProperty("below"))				clip[obj.name].y = determinePositionRelative("below",obj.below,obj.name);
				if (obj.hasOwnProperty("above"))				clip[obj.name].y = determinePositionRelative("above",obj.above,obj.name);
				if (obj.hasOwnProperty("toTheRightOf"))			clip[obj.name].x = determinePositionRelative("toTheRightOf",obj.toTheRightOf,obj.name);
				if (obj.hasOwnProperty("toTheLeftOf"))			clip[obj.name].x = determinePositionRelative("toTheLeftOf",obj.toTheLeftOf,obj.name);
				if (obj.hasOwnProperty("betweenVerticaly"))		clip[obj.name].y = centreEntreObjet(obj.betweenVerticaly[0],obj.betweenVerticaly[1],clip[obj.name].height,"y");
				if (obj.hasOwnProperty("betweenHorizontaly"))	clip[obj.name].x = centreEntreObjet(obj.betweenHorizontaly[0],obj.betweenHorizontaly[1],clip[obj.name].width,"x");

				if (obj.hasOwnProperty("borderLeft"))			clip[obj.name].x = clip[obj.name].x - ( obj.borderLeft *echelleDevice );
				if (obj.hasOwnProperty("borderRight"))			clip[obj.name].x = clip[obj.name].x + ( obj.borderRight *echelleDevice );
				if (obj.hasOwnProperty("borderTop"))			clip[obj.name].y = clip[obj.name].y + ( obj.borderTop *echelleDevice );
				if (obj.hasOwnProperty("borderBottom"))			clip[obj.name].y = clip[obj.name].y - ( obj.borderBottom *echelleDevice );

				//if (obj.hasOwnProperty("AlignedOnTheTopOf")) clip[obj.name].y= clip[obj.AlignedOnTheTopOf].y;
				//if (obj.hasOwnProperty("AlignedOnTheLeftOf")) clip[obj.name].x= clip[obj.AlignedOnTheLeftOf].x;

				trace(obj.name,clip[obj.name].x,clip[obj.name].y,clip[obj.name].width,clip[obj.name].height)
				}
			}

		private	function determinePositionRelative(sens:String,objetRef:String,nom:String):Number{

			//trace("determinePositionRelative",sens,objetRef,nom);

			var correctif:Number = 0;
			var cible:String = objetRef;
			var retour:Number;
			var determine:Array = objetRef.split(" + ");
			if (determine.length > 1) {
				cible = determine[0];
				correctif = Number(determine[1]) * echelleDevice;
				}
			else {
				determine = objetRef.split(" - ");
				if (determine.length > 1)  {
					cible = determine[0];
					correctif = -Number(determine[1]) * echelleDevice;
					}
				}
			switch (sens){
				case "above" :
					retour = clip[cible].y-clip[nom].height+correctif;
					break;

				case "below" :
					retour = clip[cible].y+clip[cible].height+correctif;
					break;

				case "toTheRightOf" :
					retour = clip[cible].x+clip[cible].width+correctif;;
					break;

				case "toTheLeftOf" :
					retour = clip[cible].x-clip[nom].width+correctif;;
					break;
				}
			return retour;
			}

		private	function centreEntreObjet(a:*,b:*,taille:Number,axe:String):Number{
			if (typeof a == "string") a = stringConvertion(a,axe);
			if (typeof b == "string") b = stringConvertion(b,axe);
			if (b > a) {
				var aTmp = a;
				a= b;
				b= aTmp;
				}
			return ((a-b-taille)/2)+b;
			}

		private function stringConvertion(chaine:String,axe:String): Number{
			switch (chaine){
				case "bottom_page" : return Main.affichage.hauteur; break;
				case "top_page" : return 0; break;
				case "right_page" : return Main.affichage.largeur; break;
				case "left_page" : return 0; break;
				default : return Number(clip[chaine][axe]); break;
				}
			}
		}
	}