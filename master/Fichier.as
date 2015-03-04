package {
	import flash.display.MovieClip;

	//fichiers
	import	flash.filesystem.File;
	import	flash.filesystem.FileStream;
	import	flash.filesystem.FileMode;

	import	flash.net.URLRequest;
	import	flash.net.URLLoader;
	import	flash.net.URLVariables;

	import	flash.events.Event;
	import	flash.events.IOErrorEvent;
	import	flash.events.SecurityErrorEvent;
	import	flash.events.HTTPStatusEvent;
	import	flash.events.ProgressEvent;

	public class Fichier extends Object {

		private	var action:String;
		private	var file:Object;
			/*
			file.nom
			file.urlDistante
			file.ref 			//clip où doit s'exécuter l'action
			file.action 
			file.racine 		//clip root
			file.source			//fichier à charger une fois le tri en local et distant
			file.localisation	//resultat recherche File.applicationStorageDirectory.resolvePath();
			file.forceDistant
			file.contenu
			file.erreur
			file.provenance
			*/
		private	var urlLoader:URLLoader;
		private	var fileStream:FileStream;

		public	function Fichier(specs:Object=null):void {
			file = specs;
			file.localisation = File.applicationStorageDirectory.resolvePath(file.nom);
			if (file.forceDistant) file.provenance = "distante";
			else {
				if (file.urlDistante){ //on vérifie 
					if(file.localisation.exists) file.provenance = "locale";
					else file.provenance = "distante";
					}
				else {
					if(file.localisation.exists) file.provenance = "locale";
					}
				}
			switch (file.provenance) {
				case "distante": file.source = file.urlDistante; break;
				case "locale": file.source = file.localisation; break;
				}
			trace("fichier",file.localisation,file.urlDistante,file.nom)
			}

		public	function init():void{
			trace("fichier init()",file.nom,file.source,file.provenance);
			if (!file.source) {
				trace("pas de fichier.init() "+file.nom+" absent en local et sans adresse distante");
				file.ref[file.action]({ "erreur":"fihcier local et distant absents" });
				return;
				}
			switch (file.provenance) {
				case "distante":
					afficheChargement(true);
					var urlRequest:URLRequest  = new URLRequest(file.source);
					urlLoader = new URLLoader();
					urlLoader.addEventListener(Event.COMPLETE, chargementFini);
					urlLoader.addEventListener(IOErrorEvent.IO_ERROR, chargementErreur);
					urlLoader.load(urlRequest);
					break;
				case "locale":
					fileStream = new FileStream();
					try { fileStream.open(file.source, FileMode.READ); }
					catch(e) { 
						fileStream.close();
						trace("fileStream error---------",e)
						afficheChargement(true);
						file.ref[file.action]({ "erreur":e.toString() });
						return
						}
					var str:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
					fileStream.close();
					file.contenu = JSON.parse(str);
					file.ref[file.action]({
						"contenu":file.contenu,
						"provenance":file.provenance
						});
					break;
				}
			}

		//public	function ecritFichier(chaine:String,overwrite:Boolean=false):void{
		public	function ecritFichier(chaine:String):void{
			//trace("ecritFichier",file.nom,chaine);
			//trace("\nFONCTION Fichier.as/ecritFichier() A REPRENDRE !!!!\n");
			//var fichierAecrire:File = File.applicationStorageDirectory.resolvePath(file.nom);
			fileStream = new FileStream();
			afficheChargement(true);
			fileStream.open(file.localisation, FileMode.WRITE);
			fileStream.writeUTFBytes(chaine);
			fileStream.close();
			afficheChargement(false);
			}

		private	function chargementErreur(evenement:Event):void {
			trace(file.nom,"---CHARGEMENT ERREUR---",evenement);
			file.racine.loading.erreurChargement(file.provenance);
			enleveEcouteurs();
			file.ref[file.action]({ "erreur":evenement });
			}

		private	function chargementFini(event:Event):void {
			//trace("chargementFini" ,file.nom, file.ref, typeof(file.ref) ,file.action);
			afficheChargement(false);
			enleveEcouteurs();
			var loader:URLLoader = URLLoader(event.target);
			file.contenu = JSON.parse(URLLoader(event.target).data);
			if (file.hasOwnProperty("enregistreDistant")) ecritFichier(JSON.stringify(file.contenu));//enregistrement en local
			file.ref[file.action]({
				"contenu":file.contenu,
				"provenance":file.provenance
				});
			}

		private	function enleveEcouteurs():void{
			urlLoader.removeEventListener(Event.COMPLETE, chargementFini);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, chargementErreur);
			}

		private	function afficheChargement(etat:Boolean):void{
			if (file.hasOwnProperty("racine")){
				if (typeof(file.racine.loading) != "Number") {
					if (etat) file.racine.loading.ajouteChargement(file.nom);
					else file.racine.loading.retireChargement();
					}
				}
			}
		}
	}