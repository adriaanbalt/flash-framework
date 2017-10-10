
package com.balt.coreimplementation.nav {
	import com.gs.TweenLite;
	import com.gs.easing.Linear;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author adriaan scholvinck
	 */
	public class NavButton extends Sprite implements INavButton {
		public static var DOWN : String = 'onDown';
		public static var ANIMATION_SPEED : Number = .2;
		
		public var dataObj : Object;
		public var id : String;
		public var link : String;
		private var useHand : Boolean;
		
		public var hit : Sprite;
		protected var front : Sprite;
		protected var back : Sprite;
		
		public function NavButton( $dataObj : Object, $useHand : Boolean = true ) {
			dataObj = $dataObj;
			useHand = $useHand;
			link = dataObj.link;
			id = link;

		}
		
		public function enable() : void{
			enableButton();
			out();
		}
		
		public function disable() : void {
			disableButton();
			over();
		}
		
		protected function down ( $e : MouseEvent = null ) : void {
			dispatchEvent( new Event( DOWN, true ));
		}
		
		protected function over ( $e : MouseEvent = null ) : void {
			if ( front != null || back != null ) {
				TweenLite.to ( front, ANIMATION_SPEED, {autoAlpha:0, ease:Linear.easeOut});
				TweenLite.to ( back, ANIMATION_SPEED, {autoAlpha:1, ease:Linear.easeOut});
			}
		}
		
		protected function out ( $e : MouseEvent = null ) : void {
			if ( front != null || back != null ) {
				TweenLite.to ( front, ANIMATION_SPEED, {autoAlpha:1, ease:Linear.easeOut});
				TweenLite.to ( back, ANIMATION_SPEED, {autoAlpha:0, ease:Linear.easeOut});
			}
		}

		private function enableButton() : void {
			hit.buttonMode = true;
			hit.useHandCursor = true;
			hit.addEventListener( MouseEvent.MOUSE_DOWN, down );
			hit.addEventListener( MouseEvent.MOUSE_OVER, over );
			hit.addEventListener( MouseEvent.MOUSE_OUT, out );
		}
		
		private function disableButton() : void {
//			hit.buttonMode = false;
			hit.useHandCursor = false;
			hit.mouseChildren = true;
			hit.removeEventListener( MouseEvent.MOUSE_DOWN, down );
			hit.removeEventListener( MouseEvent.MOUSE_OVER, over );
			hit.removeEventListener( MouseEvent.MOUSE_OUT, out );
		}
		
	}
}
