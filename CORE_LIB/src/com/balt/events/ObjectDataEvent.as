package com.balt.events
{
	import flash.events.Event;
	
	public class ObjectDataEvent extends Event implements IDataEvent
	{
		public static const MOUSE_DOWN:				String = "data_mouseDown";
		public static const MOUSE_UP:				String = "data_mouseUp";
		public static const MOUSE_OVER:				String = "data_mouseOver";
		public static const MOUSE_OUT:				String = "data_mouseOut";
		public static const MOUSE_DOWN_SELECTED:	String = "data_mouseDownSelected";
		public static const MOUSE_OVER_SELECTED:	String = "data_mouseOverSelected";
		public static const MOUSE_OVER_DISABLED:	String = "data_mouseOverDisabled";
		public static const STATE_CHANGED:			String = "data_changed";
		
		private var _data: *;
		
		public function ObjectDataEvent( $type : String, $bubbles : Boolean = false, $cancelable : Boolean = false, $data : Object = null )
		{
			super( $type, $bubbles, $cancelable );
			data = $data;
		}
		
		public function get data() : * 
		{
			return _data;
		}
		
		public function set data( p_value: * ) : void 
		{
			_data = p_value;
		}
	}
}