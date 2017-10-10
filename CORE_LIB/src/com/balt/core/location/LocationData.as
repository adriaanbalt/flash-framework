package com.balt.core.location
{
	/**
	 * Data type for information about a location.
	 * 
	 * port as2 class from nseries.com 
	 * 
	 * @author adriaan scholvinck
	 * @version 2008-10-17
	 */
	public class LocationData
	{
		private var _locationArray		: Array;
		private var _location			: ILocation;
		private var _url				: String;
		
		private var _stack				: Boolean;
		private var _track				: Object;
		private var _param				: Object;
		
		public static var STACK_ENABLED	: Boolean = true;
		public static var STACK_DISABLE	: Boolean = false;
		public static var TRACK_ENABLED	: Boolean = true;
		public static var TRACK_DISABLE	: Boolean = false;
		
		// Forces the location change even if you should not change locations,
		// for example, if you are on the same location.
		private var _forceChange			: Boolean;
		
		/**
		 * 
		 * @param p_locationArray
		 * @param p_stack
		 * @param p_track	if the parameter is false, the location will not be tracked, If the parameter
		 * 					is true or String then the location will be tracked. If the parameter is
		 * 					a String, this location will be used for metrics purposes.
		 * @param p_param
		 * 
		 */
		public function LocationData( p_locationArray:Array, 
									  p_stack:Boolean = false, 
									  p_track:Object = null, 
									  p_param:Object = null )
		{
			_locationArray = p_locationArray;
			_stack = p_stack;
			_track = ( p_track == null ) ? LocationData.TRACK_ENABLED : p_track;
			_param = p_param;
		}
		
		public function get locationArray ():Array {
			return _locationArray;
		}
		
		public function set locationArray ( a:Array ): void {
			_locationArray = a;
		}
		
		public function get location ():ILocation {
			return _location;
		}
		
		public function set location (loc:ILocation):void {
			this._location = loc;
		}
		
		public function get stack ():Boolean {
			return _stack;
		}
		
		public function get track ():Object {
			return _track;
		}
		
		public function set track ( o:Object ):void {
			_track = o; 
		}
		
		public function get forceChange ():Boolean {
			return _forceChange;
		}
		
		public function get param () : Object {
			return _param;
		}
		
		public function set param ( o:Object ):void {
			_param = o;
		}
	}
}