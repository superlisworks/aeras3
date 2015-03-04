package {
	//import flash.display.MovieClip;

	//tempos
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.desktop.NativeApplication;

	public class Infos extends Object {
		//private	var racine:MovieClip;
		private var timerMAJ:Timer = new Timer(2000);
		public	var logs:Array = new Array();
		public	var derniereInfo:String;

		public	function Infos():void {
			//racine = referent;
			var appXml:XML = new XML(NativeApplication.nativeApplication.applicationDescriptor);
			var liste:XMLList = appXml.elements();
			var chaine = "version : "+liste[1];
			if (liste[2]) chaine += liste[2];
			nouvelleInfo(chaine);
			}

		public	function nouvelleInfo(msg:String):void{
			trace("nouvelleInfo : ",msg);

			//on arrete l'écouteur
			timerMAJ.stop();
			timerMAJ.removeEventListener("timer", maj);

			//on ajoute au log l'info
			logs.push(msg);
			derniereInfo = msg;

			//on relance la temp
			timerMAJ.addEventListener("timer", maj);
			timerMAJ.start();
			}

		private	function maj(e):void{
			timerMAJ.stop();
			timerMAJ.removeEventListener("timer", maj);
			derniereInfo = "";
			}
		}
	}