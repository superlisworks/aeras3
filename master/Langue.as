package {
	import flash.display.MovieClip;

	public class Langue extends Object {
		private	var racine:MovieClip;
		private	var dictionnaire:Object = new Object();
		private	var listeLangues:Array;
		private	var fichier:Fichier;
		public	var aJour:Boolean = false;
		private	var demarrage:MovieClip;

		public	function Langue(specs:Object):void {
			//trace("[--Langue--]");
			demarrage = specs.referent;
			racine = specs.racine;

			/*listeLangues = racine.affichage.langues;
			racine.affichage.langues = null;*/

			listeLangues = Main.affichage.langues;
			Main.affichage.langues = null;

			nouvelleLangue(listeLangues.shift());
			}

		public	function traduit(chaine:String):String{
			var retour = dictionnaire[chaine];
			if (retour == null) retour = chaine;
			return retour;
			}

		private	function nouvelleLangue(langue:String):void{
			fichier = new Fichier({
				"racine":racine,
				"urlDistante":racine.URL_SERVEUR+"langues/"+langue,
				"ref":this,
				"nom":"lang.inc",
				"action":"chargeFichierLangue",
				"enregistreDistant":true
				});
			fichier.init();
			}

		public function chargeFichierLangue(retour:Object):void{
			if (retour.erreur != null) {//il y a une erreur, on recharge
				trace("[--Langue--] ERREUR !");
				Main.infos.nouvelleInfo(retour.erreur);
				if ( listeLangues.length > 0 ) nouvelleLangue(listeLangues.shift());
				}
			else {
				trace("[--Langue--] OK");
				dictionnaire = retour.contenu;
				demarrage.done++;
				}
			}

	/*		private	function verifDispoLangues(liste:Object):void{
			var ref = listeLangues.shift();
			if (typeof liste[ref] == "undefined"){
				
				}
			else fichier = new Fichier({
				"racine":racine,
				"urlDistante":racine.URL_SERVEUR+"langues/"+ref[0],
				"ref":this,
				"nom":ref[0],
				"action":"ajouteDictionnaire"
				});
			}

		private	function verifUpdate():void{
			var languesDispo:Object = new Object();
			var tmp:Array = contenu.split("\n");
			for (var i = 0; i<tmp.length; i++){
				tmp[i] = tmp[i].split("_");
				languesDispo[tmp[i][0]] = tmp[i][1];
				}
			verifDispoLangues(languesDispo);
			}*/
		}

	}