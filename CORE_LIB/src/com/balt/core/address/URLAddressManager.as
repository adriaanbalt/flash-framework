package com.balt.core.address

{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class URLAddressManager extends EventDispatcher implements IURLAddressManager
	{
		public static var ON_CHANGE_LOCATION:String = "on_change_location";
		
		public function URLAddressManager()
		{
			SWFAddress.addEventListener( SWFAddressEvent.CHANGE, onChange );
		}
		
		public function setCurrentLocation ( location:String ) :void {
			SWFAddress.setValue( location );
		}
		
		public function getCurrentLocation ( ) : Array {
			 var addressArray:Array = SWFAddress.getPathNames();
			 return addressArray;
		}
		
		public function setTitle( title:String ) :void {
			SWFAddress.setTitle( title );
		}
		
		public function getTitle( ) : String {
			 return SWFAddress.getTitle();
		}
		
		public function setValue( title:String ) :void {
			SWFAddress.setValue( title );
		}
		
		public function getValue( ) : String {
			 return SWFAddress.getValue();
		}
		
		private function onChange ( e:SWFAddressEvent ): void {
			this.dispatchEvent( new Event ( URLAddressManager.ON_CHANGE_LOCATION ) );
		}
	}
}