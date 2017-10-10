package com.balt.events
{
	import flash.events.Event;
	
	public class GenericDataEvent extends Event
	{
		private var _data:*;
		
		public function GenericDataEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, payload:* = null )
		{	
			super( type, bubbles, cancelable );
			if (payload) {
				data = payload;
			}
		}
		
		public function get data():* {
			return _data;
		}
		
		public function set data( p_data:* ) :void {
			_data = p_data;
		}
	}
}