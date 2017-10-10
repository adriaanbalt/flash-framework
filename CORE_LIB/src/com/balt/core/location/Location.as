package com.balt.core.location {
	import com.balt.core.log.Log;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	
	public class Location extends Sprite implements ILocation
	{
		protected var childLocation:ILocation;
		// Move to custom KeyboardEvent class
		protected static const KEY_RIGHT_ARROW:String = "key_right_arrow";
		protected static const KEY_LEFT_ARROW:String  = "key_left_arrow";
	
		public function Location()
		{
		}
		
		/*
		 * PUBLIC METHOD
		 */
		
		public function init ( data: * = null ):void {
			this.dispatchEvent( new Event ( LocationConstants.EVENT_ON_INIT ) );
		}
		
		/**
		 * Implements the minimal begavior necessary to operate as a location - that is, it
		 * dispatches an ON_HIDE_FINISHED_EVENT. Subclasses should implement hiding themselves
		 * and dispath this event after that is completed 
		 */
		public function hide ( ):void {
			this.dispatchEvent( new Event ( LocationConstants.EVENT_ON_HIDE_FINISHED ) );
		}
		
		/**
		 * Implements the minimal begavior necessary to operate as a location - that is, it
		 * dispatches an ON_SHOW_FINISHED_EVENT. Subclasses should implement showing themselves
		 * and dispacth this event after that is completed.
		 *  
		 * @param p_locationStringArray Array
		 * @param p_depth int
		 * @param param Object
		 * @return 
		 * 
		 */
		public function show ( p_locationStringArray:Array, p_depth:int, param:* = null ):Boolean {
			this.dispatchEvent( new Event ( LocationConstants.EVENT_ON_SHOW_FINISHED ) );
			
			return true;
		}
		
		
		public function enable ( param: Object ) :void {
			// Empty.
		}
		
		public function disable ( ) : void {
			// Empty.
		}
		
		public function getChild ( ):ILocation {
			return childLocation;
		}
		
		public function log ( txt:String ):void {
			Log.info( "[" + flash.utils.getQualifiedClassName(this) + "]" + " : " + arguments.callee + txt );
		}
		
// protected
		
		protected function shown ():void{
			// override
		}
		
		protected function showComplete() : void {
			shown();
			this.dispatchEvent(new Event(LocationConstants.EVENT_ON_SHOW_FINISHED ) );
		}
		
		protected function hideComplete() : void {
			destroy();
			this.dispatchEvent(new Event(LocationConstants.EVENT_ON_HIDE_FINISHED ) );
		}
		
		protected function destroy() : void {
			// Empty.
		}
		
		
		protected function superAddKeyboardControl() : void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
		}
		
		
		protected function superRemoveKeyboardControl() : void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
		}
		
		
		private function reportKeyDown( evt:KeyboardEvent ) : void {
		    if (evt.keyCode == Keyboard.LEFT) {
				dispatchEvent (new Event(KEY_RIGHT_ARROW));
			} else if (evt.keyCode == Keyboard.RIGHT) {
				dispatchEvent (new Event(KEY_LEFT_ARROW));
			}
		}

	}
}