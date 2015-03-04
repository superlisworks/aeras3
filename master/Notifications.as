package {
	//import flash.display.MovieClip;

	//import	flash.filesystem.File;
	//import	flash.filesystem.FileStream;
	//import	flash.filesystem.FileMode;

	//import	flash.net.URLRequest;
	//import	flash.net.URLLoader;
	//import	flash.net.URLVariables;

	//import	flash.events.Event;
	//import	flash.events.IOErrorEvent;
	//import	flash.events.SecurityErrorEvent;
	//import	flash.events.HTTPStatusEvent;
	//import	flash.events.ProgressEvent;


	import com.afterisk.shared.ane.lib.GCMEvent;
	import com.afterisk.shared.ane.lib.GCMPushInterface;

	public class Notifications extends Sprite {
		private	var racine:MovieClip;
		public static const GCM_SENDER_ID:String = "AIzaSyBDETxNg3de-D7NCA5Q0IqF0Ef_XGJA--c";// "yourGCMSenderID";

		private var _gcmi:GCMPushInterface;
		private var _gcmDeviceID:String;
		private var _payload:String;

		public	function Notifications(referent:MovieClip,elements:Object,specs:Object=null) {
			/*if (specs) {
				if (specs.hasOwnProperty("racine") ) {
					racine = specs.racine;
					}
				}
			else racine = referent;*/
			this.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true);
			}

		public	function nouvelleNotif():void{
			/*var url:String = "https://android.googleapis.com/gcm/send";

			var request:URLRequest = new URLRequest(url);

			var rhArray:Array = new Array(new URLRequestHeader("Content-Type", "application/json"),new URLRequestHeader("Authorization", "key=MYAPIKEY"));
			request.requestHeaders = rhArray;

			var msgData:String = JSON.stringify({"message":"holy crap message worked","title":"the message title here"});
			var postData:String = JSON.stringify({"registration_ids":["THELONGREGISTRATIONIDOFTHEDEVICEIWANTTOMESSAGE"],"data":msgData});

			request.data = postData;
			request.method = URLRequestMethod.POST;

			var urlLoader:URLLoader = new URLLoader();
			urlLoader = new URLLoader();

			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);

			urlLoader.load(request);*/
			}

		public function handleAddedToStage(e:Event):void {
			_messageField.appendText("\n\nInitializing GCMPushInterface...");
			//create instance of extension interface and add appropriate listeners to it
			_gcmi = new GCMPushInterface();
			_gcmi.addEventListener(GCMEvent.REGISTERED, handleRegistered, false, 0, true);
			_gcmi.addEventListener(GCMEvent.UNREGISTERED, handleUnregistered, false, 0, true);
			_gcmi.addEventListener(GCMEvent.MESSAGE, handleMessage, false, 0, true);
			_gcmi.addEventListener(GCMEvent.ERROR, handleError, false, 0, true);
			_gcmi.addEventListener(GCMEvent.RECOVERABLE_ERROR, handleError, false, 0, true);

			register();
			}

		private function register(e:MouseEvent = null):void{
			_messageField.appendText("\n\nRegistering device with GCM...");
			//check if device is already registered otherwise start registration process and wait for REGISTERED event
			var response:String = _gcmi.register(GCM_SENDER_ID);
			trace(response);

			if(response.indexOf("registrationID:") != -1) {
				_messageField.appendText("\n\nDevice was already registered.\n" + response);
				//extract GCM registration id for your device from response, you will need that to send messages to the device
				//create your own backend service or use public services
				_gcmDeviceID = response.substr(response.indexOf(":") + 1);
				handleRegistrationIDReceived();
				//if device was already registered check if there is any pending payload from GCM
				//this can be true when android shut down your app and its restarted instead of being resumed
				checkPendingFromLaunchPayload();
				}
			}

		public function unregister(e:MouseEvent = null):void{
			_messageField.appendText("\n\nUnegistering device with GCM...");
			_gcmi.unregister();
			}

		//on successful registration get GCM registration id for your device
		private function handleRegistered(e:GCMEvent):void{
			_messageField.appendText("\n\nreceived device registrationID: " + e.deviceRegistrationID);
			_gcmDeviceID = e.deviceRegistrationID;
			handleRegistrationIDReceived();
			}

		private function handleRegistrationIDReceived():void{
			//send device id to backend service that will broadcast messages
			}

		public function checkPendingFromLaunchPayload():void{
			_payload = _gcmi.checkPendingPayload();
			if(_payload != GCMPushInterface.NO_MESSAGE) {
				_messageField.appendText("\n\npending payload:" + _payload);
				handlePayload();
				}
			}

		//messages are received when app is in background therefore add event for when app is resumed from notification
		private function handleMessage(e:GCMEvent):void{
			//get payload
			_payload = e.message;
			_messageField.appendText("\n\nGCM payload received:" + _payload);
			trace("app is in the background: adding GCM app invoke listener");
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke, false, 0, true);
			}

		private function onInvoke(e:InvokeEvent):void{
			trace("app was invoked by gcm notification");
			_messageField.appendText("\n\napp was invoked from GCM notification");
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
			handlePayload();
			}

		public function handlePayload():void{
			//you can parse and treat gcm payload here
			//dispatch an event or open an appropriate view
			}

		//when device is unregistered on Google side, you might want to unregister it with your backend service
		private function handleUnregistered(e:GCMEvent):void{
			_messageField.appendText("\n\ndevice was unregistered from GCM");
			//unregister with yours or public backend messaging service
			//...
			}

		//handle variety of gcm errors
		private function handleError(e:GCMEvent):void{

			}
		}
	}