package com.balt.events {
<<<<<<< .mine
	import flash.events.Event;
	
	import com.balt.events.IDataEvent;		
=======
	import flash.events.Event;		
>>>>>>> .r234

	public class BridgeEvent extends Event implements IDataEvent 
	{

		private var _data:*;
		public static var MODULE_CALL:			String = "moduleCall";
		public static var READY:				String = "ready";
		
		public function BridgeEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type,bubbles,cancelable);
			_data = data;
		}		
		public function get data():*{
			return _data;
		};
		public function set data(value:*):void{
			_data = value;
		};		
	}
}