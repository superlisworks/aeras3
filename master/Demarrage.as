package {
	import flash.display.MovieClip;
	import flash.system.Capabilities;

	//tempos
	/*import flash.utils.Timer;
	import flash.events.TimerEvent;*/
	import flash.events.Event;

	public class Demarrage extends MovieClip { //moviecip sinon pas de enterframe
		private	var racine:MovieClip;
		//private var timerSplashScreen:Timer = new Timer(3000);
		private	var liste:Array = new Array();
		private	var premiereSequence:Array;
		private	var todo:uint = 0;
		public	var done:uint = 0;
		private	var RC:int= -1;
		private	var runControl = [ [
			{"objet":"langue", "typeObjet":Langue},
			{"objet":"clavier", "typeObjet":Clavier}
			] ];

		public	function Demarrage(objet:Object,structure:Array):void {

			//trace("[--Demarrage--]");
			premiereSequence = structure;
			this.name = "demarrage";
			racine = objet.ref;

			if(!racine.environnementDev) {
				var chaine = 'il faut déclarer l\'élément suivant:\n\t\t\tenvironnementDev = {';
				chaine += '\n\t\t\t\t"resolutionPx":['+racine.stage.stageWidth+','+racine.stage.stageHeight+'],';
				chaine += '\n\t\t\t\t"dpi":'+Capabilities.screenDPI;
				chaine += '\n\t\t\t\t}';
				trace(chaine);
				return;
				}


			racine.initAffichage();
			Main.infos = new Infos();
			Main.affichage.langues = Capabilities.languages;

			//racine.defAffichage({"dpiDevice" : 96});
			racine.defAffichage({"dpiDevice" : Capabilities.screenDPI});

			if (objet.hasOwnProperty("affichageChargement")) {
				racine.loading = new objet.affichageChargement(racine);
				racine.addChild(racine.loading);
				}
			else racine.loading = 0;

			for (var i=1; i< 10; i++) {
				if (objet.hasOwnProperty("RC"+i)) runControl[i] = objet["RC"+i];
				}
			this.addEventListener(Event.ENTER_FRAME, enterFrame );

			}

		private function enterFrame(e=0):void{
			if (done != todo) return;

			//on passe au niveau supérieur si il y en a un
			if (RC < runControl.length-1) {
				RC++;
				//trace("RC",RC,"/",runControl.length-1);
				done = 0;
				todo = runControl[RC].length;
				for (var i=0; i< runControl[RC].length; i++){
					//trace(racine[runControl[RC][i].objet], typeof(racine[runControl[RC][i].objet]))
					if (runControl[RC][i].typeObjet == Page) racine[runControl[RC][i].objet] = new Page(
						racine,runControl[RC][i].typePage,{
							"refParent":this,
							"racine":racine
							});
					else racine[runControl[RC][i].objet] = new runControl[RC][i].typeObjet({
						"racine"	: racine,
						"referent"	: this
						});
					}
				return;				
				}
			this.removeEventListener(Event.ENTER_FRAME, enterFrame );
			//racine.clavier.ON();
			racine.affichePages(premiereSequence,racine);
			}
		}
	}