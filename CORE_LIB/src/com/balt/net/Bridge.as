<<<<<<< .mine
﻿package com.balt.net {
=======
﻿package com.balt.net {
	import com.balt.events.IDataEvent;
	
>>>>>>> .r234
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;	

	public class Bridge extends EventDispatcher {
		
		private static const INTERNAL_CHANNEL:String = "internal";
		private static const EXTERNAL_CHANNEL:String = "external";
		
		private var _channel:String;
		private static var _instance:Bridge;
		
		public function Bridge(se : SingletonEnforcer) {
			try{
				_channel = ExternalInterface.call("EventBridge.getChannel");
			}catch (e:Error)
			{
				_channel = INTERNAL_CHANNEL;
			}
			
		}

		public static function getInstance():Bridge{
			if(_instance == null){
				_instance = new Bridge(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public function isReady():Boolean {
			var ready:Boolean = false;
			if (ExternalInterface.available) {
				ready = ExternalInterface.call("EventBridge.isReady");
			}
			return ready;
		}
		
		public function addBridgeListener(type:String,listener:Function,id:String):void{
			if(channel == INTERNAL_CHANNEL){
				//flash
				addEventListener(type, listener);
			}else if(channel == EXTERNAL_CHANNEL){
				//javascript
				ExternalInterface.call("EventBridge.addListener",type,ExternalInterface.objectID,(id+"receiveEvent"));
				ExternalInterface.addCallback(id+"receiveEvent",listener);
			}else{
				//error
			}
		}
		
		public function removeBridgeListener(type:String, listener:Function,id:String):void{
			if(channel == INTERNAL_CHANNEL){
				//flash
				removeEventListener(type, listener);
			}else if(channel == EXTERNAL_CHANNEL){
				//javascript
				ExternalInterface.call("EventBridge.removeListener",type,ExternalInterface.objectID, (id+"receiveEvent"));
			}
		}
		override public function dispatchEvent(event : Event) : Boolean{
			var success:Boolean;
			if(channel == INTERNAL_CHANNEL){
				//flash
				success = super.dispatchEvent(event);
			}else if(channel == EXTERNAL_CHANNEL){
				//javascript
				var data:Object;
				try
				{
					data = (event as IDataEvent).data;
				}
				catch(e:Error)
				{
					data = null;
				}
				ExternalInterface.call("EventBridge.dispatchEvent", {type:event.type, data:data});
				success =  true;
			}else{
				//error
			}
			return success;
		}
		
		public function sendExternal(event:Event):Boolean{
			var bridge_event : IDataEvent = event as IDataEvent;
			var success:Boolean = false;
			success = ExternalInterface.call("EventBridge.dispatchEvent", {type:event.type, data:bridge_event.data});
			return success;
		}
		
		public function get channel():String{
			return _channel;
		}
		public function set channel(value:String):void {
			_channel = value;
			ExternalInterface.call("EventBridge.setChannel",value);
		}
	}
}
internal class SingletonEnforcer{}