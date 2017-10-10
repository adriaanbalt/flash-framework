/**
 * - modified on Dec 16, 2008 by Tomas Vorobjov
 * 		added _mask.x into onComplete to calculate whether or not the right arrow
 * 		should be enabled/disabled 
 */
package com.balt.ui {
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.gs.TweenLite;
	import com.gs.easing.Sine;
	import com.balt.ui.events.UIEvent;	

	public class UIHorzScroll extends Sprite
	{
		
		private var _items: 	Array;
		private var _contents:	Sprite;
		private var _mask:		Sprite;
		private var _speed: 	Number;
		private var _step: 		Number;
		private var _left: 		UIButton;
		private var _right:		UIButton;
		private var _home:		int;
		private var _itemGap:	Number;
		
		public function UIHorzScroll( items:Array, maxWidth:Number, p_left: UIButton, p_right: UIButton, p_itemGap:Number = 7, p_speed: Number = .5, p_step: Number = 0 ): void 
		{
			UILayoutUtil.clearClip( this );
			
			_items = items;
			_speed = p_speed;
			
			_left = p_left;
			_right = p_right;
			_itemGap = p_itemGap;
			
			setup ( maxWidth );
			if ( p_step == 0 ) {
				_step = _items[0].width + _itemGap;
			}
			_right.addEventListener( UIEvent.EVENT_DOWN, snapLeft );
			_left.addEventListener( UIEvent.EVENT_DOWN, snapRight );
			_home = _contents.x;
			_left.enabled = false;
		}
		
		private function setup( width:Number ): void
		{
			var _swatch_hash:Object;
			_swatch_hash = new Object();
			
			/*
				+-- this ------------------------------------------------------------+
				|          +- _mask --------------------------------------+          |
				|    <     |  mask                                        |    >     |
				|(optional)|  _contents                                   |(optional)|
				|          +----------------------------------------------+          |
				+-- scrollContainer -------------------------------------------------+
			 */
			 
			_mask = new Sprite();
			this.addChild( _mask );
			
			_contents = new Sprite();
			this.addChild( _contents );
			
			var len: int = _items.length;
			
			var maxWidth: Number = width - _right.width;
			
			var viewId: int;
			
			if ( len > 0 ) {
				
				var xpos:int = 0;
				
				for( var i: int = 0; i < len; i++ )
				{
					_contents.addChild( _items[i] );
					_items[i].x = xpos;
					xpos += Math.round( _items[i].width ) + this._itemGap;
					
				}
				
				var maxNumberBeforeScroll: Number = Math.floor( maxWidth / _items[0].width ); 
				var needsScroll: Boolean = maxNumberBeforeScroll < len;
				
				if( needsScroll )
				{
					this.addChild( _left );
					this.addChild( _right );
					
					var mask: Sprite = new Sprite();
					mask.graphics.beginFill( 0x00000 );
					mask.graphics.drawRect( 0, 0,  (maxNumberBeforeScroll * (_items[0].width + _itemGap)) - _itemGap, _contents.height );
					mask.graphics.endFill();
					_mask.addChild( mask );
					_contents.mask = mask;
					_mask.x = _left.width ;
					this._contents.x = _mask.x; 
					_right.x = _mask.x + _mask.width;
					
					_left.y = _right.y = Math.floor( ( _contents.height - _left.height ) / 2 )
					
				} else {
					_left.enabled = false;
					_right.enabled = false;
				}
			}
		}
		

		public function snapLeft( p_event: Event ): void
		{
			setupTween( 1 );
		}

		public function snapRight( p_event: Event ): void
		{
			setupTween( -1 );
		}

		private function setupTween( p_direction: int ): void
		{
			clearTween();
			_right.enabled = false;
			_left.enabled = false;
			
			var start: Number = _contents.x;
			var goal: Number;
			
			if ( p_direction == 1 )
			{
				goal = start - _step;
			}
			else
			{
				goal = start + _step;
			}
			var delta: Number = goal - start;
			
			TweenLite.to( _contents, _speed, { x: goal, onComplete: onComplete, ease: Sine.easeOut } );
			
		}
		
		private function onComplete( ... args ): void
		{
			//_right.enabled = ( _contents.x > ( _mask.width - _contents.width ) );
			_right.enabled = ( _contents.x > ( _mask.x + _mask.width - _contents.width ) );
			_left.enabled = _contents.x < _home;
		}
		
		
		private function clearTween(): void
		{
			TweenLite.killTweensOf( _contents, false );
		}
		
		
	}
}