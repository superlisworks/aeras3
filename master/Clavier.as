package {
	//import flash.display.Sprite;
	import flash.display.MovieClip;
	//import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.desktop.NativeApplication;
	//tempos
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public	class Clavier extends Object {
		private	var racine;
		private	var quitteSurRetourSuivant:Boolean = false;
		//private var timerBtRetour:Timer = new Timer(1000);

		public	function Clavier(specs:Object):void {
			racine = specs.racine;
			//timerBtRetour.addEventListener("timer", finQuitteActif);
			specs.referent.done++;
			}

		public	function ON():void{
			trace("[--Clavier ON--]");
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown, false, 0, true);
			}

		public	function OFF():void{
			trace("[--Clavier OFF--]");
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);
			}

		private	function keyPressedDown(event:KeyboardEvent):void{
			trace("clavier:"+event.keyCode)
			event.preventDefault();
			event.stopImmediatePropagation();
			var key:uint = event.keyCode;
			switch (key) {
				//case Keyboard.LEFT	: gauche();	break;
				//case Keyboard.RIGHT	: droite();	break;
				//case Keyboard.UP	: haut();	break;
				//case Keyboard.DOWN	: bas();	break;
				//case Keyboard.SPACE	: espace();	break;//32
				//case 13: //touche retour; break;
				//case + //107
				//case - //109
				//case Keyboard.BACK	: retour(); break; //android uniquement
				//case Keyboard.MENU	: retour(); break; //android uniquement
				case 80 : racine.afficheElementsRoot();break;
				}
			}



		/*public	function retour():void{
			var pointeur:uint = 0;
			switch (quitteSurRetourSuivant) {
				case true : 
					racine.quitter();
					break;
				case false :
					if (racine.menuGauche.visible) pointeur++;
					if (racine.panneauAjusteZoom != null) pointeur += 2; 
					//racine.infos.newMessage("retour "+pointeur,true);
					trace("pointeur ",pointeur);
					if (pointeur == 0){
						//pas de menu gauche ni de menu zoom
						racine.infos.newMessage("appuez une autre fois pour quitter",false);
						timerBtRetour.start();
						quitteSurRetourSuivant = true;
						}
					if (pointeur == 1){
						//menu gauche
						racine.menuGauche.masque();
						}
					if (pointeur >= 2){
						//menu gauche + de menu zoom
						racine.panneauAjusteZoom.valideZoom();
						}
					break;
				}
			}


		private	function haut():void{
			if (racine.panneauAjusteZoom != null) racine.panneauAjusteZoom.clavier("haut");
			}
		private	function bas():void{
			if (racine.panneauAjusteZoom != null) racine.panneauAjusteZoom.clavier("bas");
			}
		private	function gauche():void{
			if (racine.panneauAjusteZoom != null) racine.panneauAjusteZoom.clavier("gauche");
			else racine.ecrans.clavier("gauche");
			}
		private	function droite():void{
			if (racine.panneauAjusteZoom != null) racine.panneauAjusteZoom.clavier("droite");
			else racine.ecrans.clavier("droite");
			}
		private	function espace():void{
			trace("espace")
			}

		private function finQuitteActif(e=0):void{
			timerBtRetour.stop();
			quitteSurRetourSuivant = false;
			racine.infos.newMessage("fin tempo",false);
			}*/
		}
	}