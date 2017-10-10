package com.balt.ui
{	
	import com.balt.ui.events.UIEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * simple button enabling flame animation.
	 * @author adriaan scholvinck
	 * 
	 */
	public class UIButton extends UIElement
	{	
		protected var _use_hand_cursor:	Boolean;
		
		protected var _was_down:			Boolean;
		
		protected var _selected:			Boolean;
		
		protected var _listener_hash:		Object;
		
		public function UIButton( p_useHand:Boolean = true )
		{
			super( );
			_use_hand_cursor = p_useHand	
		}
		
		public override function init(p_clip:MovieClip=null, 
									  p_addChild:Boolean=true ):void {
			
			super.init( p_clip, p_addChild );
			_was_down = false;
			_selected = false;
			_listener_hash = new Object();
			
			if( _ui_clip != null )
			{
				_ui_clip.buttonMode = true;
				_ui_clip.useHandCursor = _use_hand_cursor;
				
				_ui_clip.mouseChildren = false
				
				_ui_clip.addEventListener( MouseEvent.MOUSE_DOWN, down );
				
				if( _ui_clip.stage != null )
				{
					_ui_clip.stage.addEventListener( MouseEvent.MOUSE_UP, up );
				}
				else
				{
					_ui_clip.addEventListener( MouseEvent.MOUSE_UP, up );
				}
				
				_ui_clip.addEventListener( MouseEvent.MOUSE_OUT, out );
				_ui_clip.addEventListener( MouseEvent.MOUSE_OVER, over );
			}					  	
	 	}
		
		protected function down( p_event: MouseEvent ): void
		{
			if( ! _disabled )
			{
				_was_down = true;
				gotoLabel( DOWN );
				this.dispatchEvent( new Event ( UIEvent.EVENT_DOWN ) );
			}
			
			
		}
		
		
		protected function up( p_event: MouseEvent ): void
		{
			if( ! _disabled && _was_down )
			{
				_was_down = false;
				gotoLabel( OVER );
				this.dispatchEvent( new Event ( UIEvent.EVENT_UP ) ); 	
			}
		}
		
		
		protected function out( p_event: MouseEvent ): void
		{
			if( ! _disabled )
			{
				gotoLabel( OUT );
			}
			this.dispatchEvent( new Event ( UIEvent.EVENT_OUT ));
		}
		
		
		protected function over( p_event: MouseEvent ): void
		{
			if( ! _disabled)
			{
				gotoLabel( OVER );
			}
			this.dispatchEvent( new Event ( UIEvent.EVENT_OVER ) );
		}
		
		public override function set disabled ( p_value: Boolean ): void
		{
			var changed: Boolean = ( _disabled != p_value );
			_disabled = p_value;
			
			if( _disabled && changed )
			{
				gotoLabel( DISABLED );
			}
			else if( !_disabled && changed )
			{
				this.useDefaultLabel();
			}
			
			if( _use_hand_cursor );
			{
				_ui_clip.buttonMode = !_disabled;
			}
		}
		
		public function hint(): void
		{
			if( disabled == false && _selected == false && _labels_array.indexOf( HINT ) > -1 )
			{
				gotoLabel( HINT );
			}
			
		}
		
		
		public function set selected( p_value: Boolean ): void
		{
			_selected = p_value;
			if ( _selected ) {
				gotoLabel( SELECTED );
			} else {
				useDefaultLabel();
			}
		}
		
		
		public function get selected(): Boolean
		{
			return _selected;
		}
	}
}