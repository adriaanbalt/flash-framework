package com.balt.ui {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import com.gs.TweenLite;
	import com.gs.easing.Sine;
	import com.balt.ui.events.UIEvent;	

	/**
	 * <code>
	 * var _scroller:UIScroller;
	 * var scrollerAsset: MovieClip = MainView.getAsset().getLibraryAsset( AssetConstants.MENU_SCROLLER );
	 * _scroller = new UIScroller();
	 * _content = _scroller.initScroller( _container, 
	 *									   scrollerAsset, 
	 * 									   myWidth );
	 *	
	 *	for ( var i:uint=0; i<data.items.length; i++) {
	 *		var tf:TextField = new TextField ();
	 *		MainView.getTextFieldUtil().setupTextBlock( tf, 
	 *													data.items[i].label, 
	 *													StyleSheetConstants.SMALL_BOLD, 
	 *													null, true, true ); 
	 *		_itemLabels.push ( tf );
	 *		tf.y = yPos + 2;
	 *		_content.addChild( tf );
	 *		yPos += tf.height + 10;
	 *	}
	 * </code>
	 */
	public class UIScroller extends UIElement 
	{
		public static var VERSION:				String = "1.0";
		
		public static var SCROLLER_VISIBILITY:		String = "scrollerVisiblity";
		public static var CONTENT_HEIGHT_CHANGE:	String = "contentHeightChange";
		public static var USER_SCROLLED:			String = "userScrolled";
		
		internal static var UP:					Number = 1;
		internal static var DOWN:				Number = -1;
		
		internal static var SCROLL_SPEED:		Number = 30;
		internal static var TRANSITION_STEPS:	Number = 10;
		
		internal static var FRAME_DELAY:		Number = 30;
		internal static var SCROLL_DELAY:		Number = 60;
		internal static var PAGE_OVERLAP:		Number = 10;
		
		internal static var TEXT:				String = "text";
		internal static var CLIP:				String = "clip";
		
		// modes
		internal static var SCROLL_UP:			String = "scrollUp";
		internal static var SCROLL_DOWN:		String = "scrollDown";
		internal static var PAGE_UP:			String = "pageUp";
		internal static var PAGE_DOWN:			String = "pageUp";
		internal static var DRAG:				String = "drag";
		internal static var SNAPPING:			String = "snapping";
		
		// parts of the scroller associated with _scroller
		internal var _scroller:				MovieClip;
		internal var _scroller_width:		Number;
		internal var _top_button:			UIButton;
		internal var _bottom_button:		UIButton;
		internal var _thumb:				UIButton;
		internal var _bg:					UIButton;
		
		internal var _ui_array:				Array;
		
		internal var _mouse_hit:			Shape;
		internal var _mask:					Shape;
		internal var _visible_height:		int;
		internal var _visible_width:		int;
		internal var _content:				Sprite;
		internal var _content_field:		TextField;
		
		internal var _height_offset:		Number;
		internal var _min_thumb_height:		Number;
		
		internal var _thumb_offset:			Number;
		
		internal var _current_mode:			String;
		
		internal var _timer:				Timer;
		
		internal var _type:					String;
		internal var _offset_x:				Number;
		internal var _offset_y:				Number;
		internal var _last_content_height:	Number;
		internal var _snap_step:			Number;
		internal var _jump_direction:		Number;
		
		internal var _first_time:			Boolean;
		
		internal var _compress_content_when_visible: Boolean

		function UIScroller()
		{
			super();
			_first_time = true;
		}
		
		/**
		 * init
		 * Initializes scroller
		 * usage: <code>var <i>myScroll</i>:Navigation.ScrollerII = new Navigation.ScrollerII(<i>parentMC</i>, <i>parentMC.mask</i>, <i>parentMC.content</i>);</code>
		 * @param p_home (MovieClip) MovieClip that containes scroll content, the mask ans the attached movie clip
		 * @param p_mask (MovieClip) MovieClip that defines visible area
		 * @param p_content (MovieClip) MovieClip content
		 * @param p_offsetX (Number) Move the scroller horz by this amount
		 * @param p_offsetY (Number) Move the scroller vert by this amount
		 * @param p_heightOffset (Number) Assume this much less in content height. added to allow for spacers in the clips
		 * @param p_snap (Number) Defaults to 0. Snapping for grids 
		 * @returns void
		*/	
		public function initScroller( p_container: MovieClip,
							  		  p_scroller: MovieClip,
							  		  p_width: int, p_height: int,
							  		  p_offsetX: Number = 0,
							  		  p_offsetY: Number = 0,
							  		  p_heightOffset: Number = 0,
							  		  p_snapStep: uint = 0,
							  		  p_compress: Boolean = false ): Sprite
							  		  
		{
			_compress_content_when_visible = p_compress;
			
			commonInit( p_container, p_scroller, p_width, p_height, p_offsetX, p_offsetY, p_heightOffset );
			
			_content = new Sprite();
			p_container.addChildAt( _content, 0 );
			
			createMask();
			_content.mask = _mask;
			
			_type = CLIP;
			_snap_step = Math.max( p_snapStep, 0 );
			
			setupAssets();
			
			return _content;
		}
		
		
		/**
		 * init
		 * Initializes scroller
		 * usage: <code>var <i>myScroll</i>:Navigation.ScrollerII = new Navigation.ScrollerII(<i>parentMC</i>, <i>parentMC.mask</i>, <i>parentMC.content</i>);</code>
		 * @param p_home (MovieClip) MovieClip that containes scroll content, the mask ans the attached movie clip
		 * @param p_mask (MovieClip) MovieClip that defines visible area
		 * @param p_content (MovieClip) MovieClip content
		 * @param p_offsetX (Number) Move the scroller horz by this amount
		 * @param p_offsetY (Number) Move the scroller vert by this amount
		 * @param p_heightOffset (Number) Assume this much less in content height. added to allow for spacers in the clips
		 * @returns void
		 */	
		public function initText( p_container: MovieClip,
								  p_scroller: MovieClip,
								  p_width: int,
								  p_height: int,
								  p_offsetX: Number = 0,
								  p_offsetY: Number = 0,
								  p_heightOffset: Number = 0,
								  p_compress: Boolean = false ): TextField
		{
			_compress_content_when_visible = p_compress;
			
			commonInit( p_container, p_scroller, p_width, p_height, p_offsetX, p_offsetY, p_heightOffset );
			
			_content_field = new TextField();
			_content_field.mouseWheelEnabled = false;
			_ui_clip.addChild( _content_field );
			
			_content_field.width = _visible_width;
			_content_field.height = _visible_height;
			
			_type = TEXT;
			_snap_step = 0;
			
			setupAssets();
			
			return _content_field;
		}
		
		public function updateWidth( p_width: int ): void
		{
			_visible_width = p_width;

			if( _mask != null )
			{
				if( _scroller.visible && _compress_content_when_visible  )
				{
					_mask.width = _visible_width - _scroller_width;
				}
				else
				{
					_mask.width = _visible_width;
				}
			}
			
			_scroller.x = Math.floor( _visible_width + _offset_x );
			if( _compress_content_when_visible )
			{
				_scroller.x -= Math.floor( _scroller_width );
			}
			
			createHit();
		}
		
		
		override public function get height(): Number
		{
			if( _type == CLIP )
			{
				return Math.min( _visible_height, _content.height );
			}
			else
			{
				// text
				return _visible_height;
			}
		}
		
		public function get scrollerVisible(): Boolean
		{
			return _scroller.visible;
		}
		
		public function set scrollerVisible( p_visible: Boolean ): void
		{
			_scroller.visible = p_visible;
			if( _compress_content_when_visible && _mask != null )
			{
				if( p_visible )
				{
					_mask.width = _visible_width - _scroller_width;
				}
				else
				{
					_mask.width = _visible_width;
				}
			}
		}
		
		
		/**
		 * scrollTo
		 * Causes content to scroll to a positive pixel position and updates the thumb
		 * usage <code>var <i>myScroll.scrollTo</i>( <i>100</i> );</code>
		 * @param y (Number) Positive number of pixels you will the clip to scroll to<br>i.e. If you wish to jump to a clip that is 100 pixels down from the top, use the code example above 
		 * @param p_tween (Boolean) if true, there is a transition 
		 * @returns void
		*/
		public function scrollTo( y: int, p_tween: Boolean = false ): void
		{

			if( _type == CLIP )
			{
				var newY: Number = -y;
				
				newY = makeValidClipY( newY );
				
				if( p_tween )
				{
					setupTween( newY );
				}
				else
				{
					_content.y = newY;
				}
			}
			else
			{
				// text
				_content_field.scrollV = y;
			}
			
			updateThumbPos();
		}
		
		
		public function isVisible( p_clip: DisplayObject ): Boolean
		{
			if( _type == CLIP )
			{
				var topPoint: Point = new Point( p_clip.x, p_clip.y );
				topPoint = p_clip.parent.localToGlobal( topPoint );
				topPoint = _content.globalToLocal( topPoint );
				
				var bottomPoint: Point = new Point( p_clip.x, topPoint.y + p_clip.height );
				
				return ( topPoint.y > -_content.y && bottomPoint.y < ( -_content.y + _visible_height ) );
			}
			else
			{
				return false;
			}
			
		}
		
		/**
		 * toString
		 * For dubuging... outouts the opject type and the name of the associated clip
		 * usage <code>trace( myScroller.toString() );</code>
		 * @return String
		 */
		override public function toString(): String
		{
			return "IDBuilder.UIDefault.GenericParts.UIScroller v" + VERSION;
		}
		
		// - PRIVATE --------------------------------------------------------------------
		private function commonInit( p_container: MovieClip, p_scroller: MovieClip, p_width: int, p_height: int, p_offsetX: Number = 0, p_offsetY: Number = 0, p_heightOffset: Number = 0 ): void
		{
//			super.initSuper( p_container, null );
			super.init( null, true );
			_ui_clip = p_container; // don't want toa dd as child so not passed to initSuper
			
			_scroller = p_scroller;
			_scroller_width = Math.round( _scroller.width );
			
			scrollerVisible = false; // added for artifact when starting
			
			_ui_clip.addChild( _scroller );
			
			_visible_width = p_width;
			_visible_height = p_height;
			_offset_x = p_offsetX;
			_offset_y = p_offsetY;
			_height_offset = p_heightOffset;
			
			_scroller.x = Math.floor( _visible_width + _offset_x );
			if( _compress_content_when_visible )
			{
				_scroller.x -= Math.floor( _scroller_width );
			}
			_scroller.y = p_offsetY;
			
			createHit();
			
			_timer = new Timer( SCROLL_DELAY );
			_timer.addEventListener( TimerEvent.TIMER, updatePosition, false, 0, true );
			_ui_clip.addEventListener( Event.ENTER_FRAME, update, false, 0, true );
			
		}
		
		/**
		 * Trigger by the timer.
		 */
		private function updatePosition( p_event: Event ): void
		{
			switch ( _current_mode )
			{
				case SCROLL_UP:
					scrollBy( UP );
					break;
				case SCROLL_DOWN:
					scrollBy( DOWN );
					break;
				case PAGE_UP:
					page( UP );
					break;
				case PAGE_DOWN:
					page( DOWN );
					break;
				case DRAG:
					updateScroll();
					break;
				case SNAPPING:
					updateThumbPos();
					break;
					
			}
		}
		
		/**
		 * The scroller moves through different modes of operation.
		 * The intevals change depending on the type
		 * @param p_type ( String ) value is one of the static varriables or null
		 */
		private function setMode( p_type: String ): void
		{
//trace( "setMode " + p_type );
			clearTween();
			_current_mode = p_type;
			
			if( _current_mode != null )
			{
				if( _current_mode == DRAG )
				{
					// remember the offset for dragging.
					// set the delay to the frame rate for performance
					_thumb_offset = _thumb.clip.mouseY * _thumb.clip.scaleY;
					_timer.delay = FRAME_DELAY;
				}
				else if( p_type == SNAPPING )
				{
					// set the delay to the frame rate for performance
					_timer.delay = FRAME_DELAY;
				}
				else
				{
					// set the delay lowwer for repeat
					_timer.delay = SCROLL_DELAY;
				}
				_timer.start();
			}
			else
			{
				_timer.stop();
			}
		}
		
		
		private function createMask(): void
		{
			// draw the _mask;
			_mask = new Shape();
            _mask.graphics.beginFill( 0x00000 );
            _mask.graphics.drawRect( 0, 0, _visible_width, _visible_height );
            _mask.graphics.endFill();
            _ui_clip.addChildAt( _mask, 1 );
            _mask.scaleY = 0;
		}
		
		/**
		 * there's an invisible shape behind the entire block.
		 * It is there so that we can react to the mouse wheel
		 */
		private function createHit(): void
		{
			// draw the hit;
			if( _mouse_hit != null )
			{
				_ui_clip.removeChild( _mouse_hit );
				_mouse_hit = null;
			}
			_mouse_hit = new Shape();
			
			_mouse_hit.graphics.beginFill( 0x00000, 0 );
			_mouse_hit.graphics.lineTo( 0, 0 );
			
			if( _compress_content_when_visible )
			{
				_mouse_hit.graphics.lineTo( _visible_width + ( _offset_x - _scroller_width ), 0 );
				_mouse_hit.graphics.lineTo( _visible_width + ( _offset_x - _scroller_width ), _offset_y );
				_mouse_hit.graphics.lineTo( _visible_width + _offset_x, _offset_y );
				_mouse_hit.graphics.lineTo( _visible_width + _offset_x, _offset_y + _visible_height + _height_offset );
			}
			else
			{
				_mouse_hit.graphics.lineTo( _visible_width + _offset_x, 0 );
				_mouse_hit.graphics.lineTo( _visible_width + _offset_x, _offset_y );
				_mouse_hit.graphics.lineTo( _visible_width + _offset_x + _scroller_width, _offset_y );
				_mouse_hit.graphics.lineTo( _visible_width + _offset_x + _scroller_width, _offset_y + _visible_height + _height_offset );
			}
			
			_mouse_hit.graphics.lineTo( _visible_width + _offset_x, _offset_y + _visible_height + _height_offset );
			_mouse_hit.graphics.lineTo( _visible_width + _offset_x, _visible_height );
			_mouse_hit.graphics.lineTo( 0, _visible_height );
			_mouse_hit.graphics.lineTo( 0, 0 );
			
			_mouse_hit.graphics.endFill();
			_ui_clip.addChildAt( _mouse_hit, 0 );
			
			_ui_clip.addEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true );
		}
		
		
		private function setupAssets(): void
		{
			var currentClip: MovieClip;
			var bottomY: Number;
			
			_ui_array = new Array();
			
			currentClip = _scroller.up;
			if( currentClip != null )
			{
				_top_button = new UIButton();
				_ui_array.push( _top_button );
				_top_button.init( currentClip, true );
				
				_top_button.addEventListener( UIEvent.EVENT_DOWN, setupScrollUp );
				_top_button.addEventListener( UIEvent.EVENT_UP, setupSnap );
				_top_button.addEventListener( UIEvent.EVENT_OUT, setupSnap );
			}
			
			currentClip = _scroller.down;
			if( currentClip != null )
			{
				_bottom_button = new UIButton();
				_ui_array.push( _bottom_button );
				_bottom_button.init( currentClip, true );
				_bottom_button.addEventListener( UIEvent.EVENT_DOWN, setupScrollDown );
				_bottom_button.addEventListener( UIEvent.EVENT_UP, setupSnap );
				_bottom_button.addEventListener( UIEvent.EVENT_OUT, setupSnap );
				bottomY = Math.floor( ( _visible_height + _height_offset ) - currentClip.height );
				currentClip.y = bottomY;
			}
			else
			{
				bottomY = Math.floor( _visible_height + _height_offset );
			}
			
			currentClip = _scroller.thumb;
			if( currentClip != null )
			{
				_thumb = new UIButton();
				_ui_array.push( _thumb );
				_thumb.init( currentClip, false );
				_thumb.addEventListener( UIEvent.EVENT_DOWN, setupThumb );
				_min_thumb_height = currentClip.height;
			}
			
			currentClip = _scroller.background;
			if( currentClip != null )
			{
				_bg = new UIButton();
				_ui_array.push( _bg );
				_bg.init( currentClip, false );
				_bg.addEventListener( UIEvent.EVENT_DOWN, jump );
				currentClip.height = bottomY - currentClip.y;
			}
			
			enabled = false;
			
		}
		
		
		private function setupScrollUp( ... args ): void
		{
			userScrolled();
			setMode( SCROLL_UP );
			scrollBy( UP );
		}
		
		
		private function setupScrollDown( ... args ): void
		{
			userScrolled();
			setMode( SCROLL_DOWN );
			scrollBy( DOWN );
		}
		
		
		private function clearMode( ... args ): void
		{
			if( _thumb != null )
			{
				if( _thumb.stage != null )
				{
					// added for clearing release outside
					_thumb.clip.stage.removeEventListener( MouseEvent.MOUSE_UP, clearMode );
				}
			}
			if( _type == CLIP )
			{
				// make sure it is on a pixel
				_content.y = Math.round( _content.y );
			}
			updateThumbPos();
			setMode( null );
		}
		
		
		private function setupSnap( ... args ): void
		{
			if( _current_mode != SNAPPING )
			{
				userScrolled();
				setMode( SNAPPING );
				snap();
			}
		}
		
		private function setupThumb( ... args ): void
		{
			userScrolled();
			setMode( DRAG );
			// added for release outside
			_thumb.clip.stage.addEventListener( MouseEvent.MOUSE_UP, clearThumb, false, 0, true );
			// scrollBy( UP );
		}
		
		private function clearThumb( p_event: Event ): void
		{
			if( _current_mode == DRAG )
			{
				_thumb.clip.stage.removeEventListener( MouseEvent.MOUSE_UP, clearThumb );
				setupSnap()
			}
		}
		
				
		private function jump( ... args ): void
		{
			userScrolled();
			var direction: Number = DOWN;
			
			var currentThumbY: Number = _thumb.clip.y;
			var currentMouseY: Number = _ui_clip.mouseY;
			
			if( currentMouseY < currentThumbY )
			{
				direction = UP;
			}
			page( direction );
		}
		
		
		private function clearTween(): void
		{
			TweenLite.killTweensOf( _content, false );
		}
		
		
		private function snap(): void
		{
			if( _snap_step > 0 && !isNaN( _jump_direction ) )
			{
				var start: Number = _content.y;
				var goal: Number;
				
				if ( _jump_direction == 1 )
				{
					goal = Math.ceil( start / _snap_step ) * _snap_step;
				}
				else
				{
					goal = Math.floor( start / _snap_step ) * _snap_step;
				}
				setupTween( goal );
			}
		}
		
		private function setupTween( p_goal: Number ): void
		{
			clearTween();
			var start: Number;
			var delta: Number;
			var transitonSteps: Number;
					
			if( _type == CLIP )
			{
				start = _content.y;
				
				p_goal = makeValidClipY( p_goal );
				
				delta = p_goal - start;
				
				transitonSteps = Math.min( TRANSITION_STEPS, Math.floor( Math.abs( delta / 2 ) ) );
				
				if ( delta > 3 || delta < -3 )
				{
					setMode( SNAPPING );
					TweenLite.to( _content, transitonSteps/30, { y: p_goal, onComplete: clearMode, ease: Sine.easeOut } );
				}
				else
				{
					clearMode();
					_content.y = p_goal;
					updateThumbPos();
				}
			}
			else
			{
				start = _content_field.scrollV;
				
				delta = p_goal - start;
				
				transitonSteps = Math.min( TRANSITION_STEPS, Math.floor( Math.abs( delta / 2 ) ) );
				
				
				if ( transitonSteps > 3 || transitonSteps < -3 )
				{
					setMode( SNAPPING );
					TweenLite.to( _content_field, transitonSteps/30, { scrollV: p_goal, onComplete: clearMode } );
				}
				else
				{
					clearMode();
					scrollTo( Math.round( p_goal ) );
					updateThumbPos();
				}
			}
		}
		
		
		// sets the visiblity of the thumb set the scripts of the variaous parts of the scroller  	
		private function updateThumbHeight(): void
		{
			var newHeight: Number;
			var event: Event;
			
			if( _type == CLIP )
			{
				_last_content_height = getAdjustedContentHeight();
				
				if ( _last_content_height <= _visible_height )
				{
					
					// hide the parts and turn off the scripts
					_thumb.clip.height = _bg.clip.height;
					_thumb.clip.y = _bg.clip.y;
					enabled = false;
					
					if( _scroller.visible || _first_time )
					{
						scrollerVisible = false;
						_mouse_hit.visible = false; // done so that it doesn't block events
						event = new Event( SCROLLER_VISIBILITY )
						dispatchEvent( event );
					}
				}
				else
				{
					
					newHeight = _visible_height/( _last_content_height - _height_offset ) * _bg.clip.height;
					if ( newHeight < _min_thumb_height ) newHeight = _min_thumb_height;
					_thumb.clip.height = newHeight;
					enabled = true;
										
					if( !_scroller.visible || _first_time )
					{
						scrollerVisible = true;
						_mouse_hit.visible = true;
						event = new Event( SCROLLER_VISIBILITY );
						dispatchEvent( event );
					}
				}
			}
			else
			{
				
				// _type == TEXT
				var textMaxV: Number = _content_field.maxScrollV;
				var visibleLines: Number = ( _content_field.bottomScrollV - _content_field.scrollV ) + 1;
				var total: Number = ( textMaxV + visibleLines ) - 1;
				if ( textMaxV <= 1 )
				{
					// hide the parts and turn off the scripts
					_thumb.clip.height = _bg.clip.height;
					_thumb.clip.y = _bg.clip.y;
					enabled = false;
					
					if( _scroller.visible || _first_time )
					{
						scrollerVisible = false;
						_mouse_hit.visible = false; // done so that it doesn't block events
						event = new Event( SCROLLER_VISIBILITY )
						dispatchEvent( event );
					}
				}
				else
				{
					newHeight = ( visibleLines / total ) * _bg.clip.height;
					if ( newHeight < _min_thumb_height ) newHeight = _min_thumb_height;
					_thumb.clip.height = newHeight;
					var delta: Number = ( _thumb.clip.y + newHeight ) - ( _bg.clip.y + _bg.clip.height );
					if( delta > 0 )
					{
						_thumb.clip.y -= delta; // attenpt to get rid of artifact
					}
					enabled = true;
					
					if( !_scroller.visible || _first_time )
					{
						scrollerVisible = true;
						_mouse_hit.visible = true;
						event = new Event( SCROLLER_VISIBILITY );
						dispatchEvent( event );
					}
				}
			}
		}
	
	
		/**
		 * resetThumb
		 * description Causes content to scroll to its home position and updates the thumb.
		 * returns void
		 */
		private function resetThumb(): void
		{
			if( _type == CLIP )
			{
				updateThumbHeight();
				updateThumbPos();
			}
			else
			{
				// TEXT... reverse the order... jelps with artifacts
				updateThumbPos();
				updateThumbHeight();
			}
			_first_time = false;
		}
		
		
		/**
		 * update
		 * Does the actual work of update. May be called directly if there is no need fo the frame delay.
		 * usage: <code>var <i>myScroll.update()</i>();</code>
		 * @returns void
		 */	
		private function update( p_event: Event = null ): void
		{
			if( _type == CLIP )
			{
				var currentHeight: Number = getAdjustedContentHeight();
				if( currentHeight != _last_content_height || _first_time )
				{
					var event: Event = new Event( CONTENT_HEIGHT_CHANGE )
					dispatchEvent( event );
					
					_last_content_height = currentHeight;
					
					tweenMask();
					
					if ( minY > 0 )
					{
						_content.y = 0;
					}
					else if( _content.y < minY )
					{
						_content.y = minY;
					}
					
					resetThumb();
				}
			}
			else
			{
				// _type == TEXT
				if( _current_mode != DRAG )
				{
					resetThumb();
				}
				else
				{
					updateScroll();
				}
			}
			
				
		}
			
		
		/**
		 * page up, down - PAGE_OVERLAP.
		 * passed 1 or -1.
		 */
		private function page( direction: Number ): void
		{
			if( direction == UP || direction == DOWN )
			{
				if( _type == CLIP )
				{
					var currentY: Number = _content.y;
			
					var newY: Number = Math.round( currentY + ( direction * ( _visible_height - PAGE_OVERLAP ) ) );
					
					newY = makeValidClipY( newY );
					
					if( _snap_step > 0 )
					{
						newY = Math.round( newY / _snap_step ) * _snap_step;
					}
					
					setupTween( newY );
					
				}
				else
				{
					// _type == TEXT
					var visibleLines: Number = _content_field.bottomScrollV - _content_field.scrollV;
					setupTween( ( ( visibleLines * direction ) * -1 ) + _content_field.scrollV );
				}
				
				updateThumbPos();
			}
		}
		
		
		private function scrollBy( direction: Number ): void
		{
			if( _type == CLIP )
			{
				var currentY: Number = _content.y;
				var newY: Number = Math.round( currentY + ( direction * PAGE_OVERLAP ) );
				
				_jump_direction = ( direction > 0 ) ? 1 : -1;
				
				scrollTo( -newY );
			}
			else
			{
				// _type == TEXT
				scrollTo( _content_field.scrollV - direction );
			}
		}
	
		// causes the thumb to move to the apporiae position relative to the displayed
		private function updateThumbPos(): void
		{
			var range: Number = getRange();
			var newY: Number;
			
			if( _type == CLIP )
			{
				newY = - ( ( _content.y / ( getAdjustedContentHeight() - _visible_height ) ) * range ) + _bg.clip.y;
			}
			else
			{
				// _type == TEXT
				newY = ( ( ( _content_field.scrollV - 1 ) / ( _content_field.maxScrollV - 1 ) ) * range ) + _bg.clip.y;
			}
			if( isNaN( newY ) ) newY = 0;
			newY = Math.max( _bg.clip.y, newY );
			_thumb.clip.y = newY;
		}
			
			
		private function onMouseWheel( p_event: Event ): void
		{
			
			userScrolled();
			
			var delta: Number = p_event[ "delta" ];
			var goal: Number;
			
			if( _type == CLIP )
			{
				if( _scroller.visible )
				{
					if( _snap_step > 0 )
					{
						if ( delta > 0 )
						{
							goal = ( Math.ceil( _content.y / _snap_step ) * _snap_step ) + _snap_step;
						}
						else
						{
							goal = ( Math.floor( _content.y / _snap_step ) * _snap_step ) - _snap_step;
						}
					}
					else
					{
						// just move it
						goal = _content.y + ( delta * SCROLL_SPEED );
					}
					setupTween( goal );
				}
			}
			else
			{
				// TEXT
				scrollBy( delta );
			}
		};
		
		
		private function updateTumb(): void
		{
			var bgClip: MovieClip = _bg.clip;
			var thumbClip: MovieClip = _thumb.clip;
			var lastY: Number = thumbClip.y;
			var newY: Number = ( bgClip.y + ( bgClip.mouseY * bgClip.scaleY ) ) - _thumb_offset;
			var maxY: Number = ( bgClip.y + bgClip.height ) - thumbClip.height;
			
			if( newY < bgClip.y )
			{
				newY = bgClip.y;
			}
			if( newY > maxY )
			{
				newY = maxY;
			}
			
			if( lastY != newY )
			{
				thumbClip.y = newY;
			}
		}
		
		// used during dragging. Sets the position of the content
		private function updateScroll(): void
		{
			updateTumb();
			
			var newY: Number;
			var ratio: Number = getRatio();
				
			if( _type == CLIP )
			{
				var contentHeight: Number = getAdjustedContentHeight();
				var lastY: Number = _content.y;
				
				newY = - Math.floor( ratio * ( contentHeight - _visible_height ) );
				newY = makeValidClipY( newY );
				
				if( lastY != newY )
				{
					_jump_direction = ( newY > lastY ) ? 1 : -1;
					_content.y = newY;
				}
			}
			else
			{
				// _type == TEXT
				var visibleLines: Number = _content_field.bottomScrollV - _content_field.scrollV;
				var total: Number = ( _content_field.maxScrollV + visibleLines );
				var hiddenLines: Number = total - visibleLines;
				_content_field.scrollV = Math.ceil( ratio * hiddenLines );
			}
		}
		
		private function getRange(): Number
		{
			return Math.floor( _bg.clip.height - _thumb.clip.height );
		}
		
		private function getRatio(): Number
		{
			return ( _thumb.clip.y - _bg.clip.y ) / getRange();
			
		}
		
		
		override public function set enabled( p_value: Boolean ): void
		{
			super.enabled = p_value;
			var len: Number = _ui_array.length;
			for( var i: int = 0; i < len; i++ )
			{
				_ui_array[ i ].enabled = p_value;
			}
		}
		
		private function getAdjustedContentHeight(): Number
		{
			var results: Number = _content.height;
			if( _snap_step > 0 )
			{
				results = Math.round( results / _snap_step ) * _snap_step;
			}
			return results;
		}
		
		private function get minY(): Number
		{
			return Math.round( _visible_height - getAdjustedContentHeight() );
		}
		
		private function makeValidClipY( p_value: Number ): Number
		{
			if( p_value > 0 )
			{
				return 0;
			}
			else if( p_value < minY )
			{
				return minY;
			}
			else
			{
				return p_value;
			}
		}
		
		
		private function userScrolled(): void
		{
			var event: Event = new Event( USER_SCROLLED );
			dispatchEvent( event );			
		}
		
		public function kill(): void
		{
			if( _timer != null )
			{
				_timer.stop();
				_timer.removeEventListener( TimerEvent.TIMER, updatePosition );
			}
			_ui_clip.removeEventListener( Event.ENTER_FRAME, update );
			_ui_clip.removeEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
		}
		
		private function tweenMask(): void
		{
			TweenLite.killTweensOf( _mask, false );
			var start: Number = _mask.scaleY;
				
			var goal: Number = Math.min( 1, _content.height / _visible_height );
				
			var delta: Number = goal - start;
				
			var transitonSteps: int = Math.min( TRANSITION_STEPS, Math.floor( Math.abs( delta / 2 ) ) );
				
			if ( Math.abs( delta ) > 3 )
			{
				TweenLite.to( _mask, transitonSteps/30, { scaleY: goal, ease: Sine.easeOut } );
			}
			else
			{
				_mask.scaleY = goal;
			}
		}
		
	}
}
