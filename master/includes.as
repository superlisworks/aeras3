//objets statiques
public	static var infos:Infos;
public	static var affichage:Object = new Object();

//autres objets
public	var demarrage:Demarrage;
public	var langue:Langue;
public	var	clavier:Clavier;
public	var loading;
public	var environnementDev;

//makeDisplayList
public	var listeClipsAffiches:*; //object ou array
private	var listeClipsAffichesTmp:Array = [];

include "Main_affichages.as"
include "Main_swipe.as"
include "Main_effets.as"
CONFIG::DEBUG{//debuggage
	include "Main_outilsDebug.as"
	}