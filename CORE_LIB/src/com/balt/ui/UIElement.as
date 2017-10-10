package com.balt.ui
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	

	/**
	 * @author adriaan scholvinck
	 * 
	 */
	public class UIElement extends MovieClip
	{
		// static labels
		public static var ON:			String = "on";
		public static var OFF:			String = "off";
		public static var OUT:			String = "out";
		public static var OVER:			String = "over";
		public static var DOWN:			String = "down";
		public static var DISABLED:		String = "disabled";
		public static var SETUP:		String = "setup";
		public static var SELECTED:		String = "selected";
		public static var HINT:			String = "hint";
		
		public static var ANSWERED:		String = "answered";
		public static var UNANSWERED:	String = "unanswered";
		
		// event type
		public static var EVENT_CHANGED:String = "ui_changed";
		
		protected var _ui_clip:			MovieClip;
		protected var _labels_array:		Array;
		protected var _data:				Object;
		protected var _disabled:			Boolean;

		public function UIElement(  ): void
		{
			_data = new Object();
		}
		
		public function init ( p_clip: MovieClip = null, 
							   p_addChild: Boolean = true ):void {
			if( p_clip == null )
			{
				_ui_clip = this;
			}
			else
			{
				_ui_clip = p_clip;
				if( p_addChild )
				{
					super.addChild( p_clip );
				}
			}
			
			_labels_array = getLabels();
			_disabled = false;
			gotoLabel( OFF );
		}
		
		public function gotoLabel( p_label: String ): void
		{
			if( _labels_array.indexOf( p_label ) > -1 )
			{
				_ui_clip.gotoAndStop( p_label );
			}
			else
			{
				useDefaultLabel();
			}
		}
		
		public function useDefaultLabel(): void
		{
			_ui_clip.gotoAndStop( 1 );
		}
		
		public function get clip(): MovieClip
		{
			return _ui_clip;
		}
		
		private function getLabels(): Array
		{
			var results: Array = new Array();
			var currentLabels: Array = _ui_clip.currentLabels;
			var len: int = currentLabels.length;
			for( var i: int = 0; i < len; i++ )
			{
				results.push( currentLabels[ i ].name );
			}
			return results;
		}
		
		public function set disabled( p_value: Boolean ): void
		{
			_disabled = p_value;
		}
		
		public function get disabled(): Boolean
		{
			return _disabled;
		}
		
		override public function set enabled( p_value: Boolean ): void
		{
			disabled = !p_value;
		}
				
		override public function get enabled(): Boolean
		{
			return !_disabled;
		}
		
		public function setData( p_data: Object = null ): void
		{
			if( p_data == null ) p_data = new Object();
			_data = p_data;
		}
		
		public function getData(): Object
		{
			return _data;
		}
		
		override public function addChild( p_child: DisplayObject ): DisplayObject
		{
			if ( _ui_clip is UIElement ) {
				return super.addChild( p_child );
			}
			return _ui_clip.addChild( p_child );
		}
		
		override public function get width():Number {
			if ( _ui_clip == null || _ui_clip is UIElement) {
				return super.width;
			}
			return _ui_clip.width;
		}
		
		override public function get height():Number {
			if ( _ui_clip == null || _ui_clip is UIElement) {
				return super.width;
			}
			return _ui_clip.height;
			
		}
	}
}