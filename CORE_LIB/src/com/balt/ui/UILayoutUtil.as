package com.balt.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * 
	 * @author adriaan scholvinck
	 * @version 1.0 create
	 * @version 1.1 add center horizontal param
	 */
	public class UILayoutUtil
	{
		public function UILayoutUtil()
		{
			
		}
		
		public static function configIconButton( p_buttonClip: MovieClip, 
												 p_txtField: TextField = null, 
												 p_icon:* = null, 
												 p_centerVertical: Boolean = false, 
												 p_centerHorizontal: Boolean = false,
												 p_minWidth: Number = 0, 
												 p_minTextSize: Number = 0, 
												 p_xTextMargin: Number = 0,
												 p_isReverse:Boolean = false,
									   			 p_target_field:String = null ): void
		{
			
			
			p_minWidth = Math.ceil( p_minWidth ); // snap them to pixels
			p_minTextSize = Math.ceil( p_minTextSize ); // snap them to pixels
			var textTFWidth:int = 0;
			
			var assetOffset: int = 0;
			var asset_mc: MovieClip = p_buttonClip.getChildByName( "asset_mc" ) as MovieClip;
			var text_mc: MovieClip;
			var bg_mc: MovieClip = p_buttonClip.getChildByName( "bg_mc" ) as MovieClip;
			
			if ( p_txtField != null ) {
				p_txtField.mouseEnabled = false;
				
				
				
				// text_mc can be tinted on the timeline
				if(p_target_field){
					text_mc = p_buttonClip.getChildByName( p_target_field ) as MovieClip;
				}else{
					text_mc = p_buttonClip.getChildByName( "text_mc" ) as MovieClip;
				}
				
				text_mc.x = Math.round(p_xTextMargin);
				if( text_mc != null )
				{
					var contents_mc: MovieClip = text_mc.getChildByName( "contents_mc" ) as MovieClip;
					if( contents_mc != null )
					{
						clearClip( contents_mc );
						contents_mc.addChild( p_txtField );
					}
					else
					{
						clearClip( text_mc );
						text_mc.addChild( p_txtField );
					}
				}
				else
				{
					p_buttonClip.addChild( p_txtField );
				}
				if( p_centerVertical )
				{
					p_txtField.y = Math.round( ( p_buttonClip.height - p_txtField.height ) / 2 );
				}
				
				if ( p_centerHorizontal ) {
					p_txtField.x = Math.round( ( p_buttonClip.width - p_txtField.width ) / 2 );
				}
				textTFWidth = Math.round(p_txtField.width);
			} else {
				
			}
			
			if ( bg_mc != null ) {
				// now the hit
				bg_mc.width = Math.ceil( Math.max( p_minWidth, Math.round( Math.ceil( Math.max( p_buttonClip.width , p_minTextSize ) ) ) ) );
				bg_mc.height = Math.round( p_buttonClip.height );
			}
			
			if( asset_mc != null )
			{
				if ( p_icon != null ) {
					clearClip ( asset_mc );
					asset_mc.addChild( p_icon );
				} 
				assetOffset = asset_mc.x;
				
				if( p_centerVertical )
				{
					asset_mc.y = Math.round( ( p_buttonClip.height - asset_mc.height ) / 2 );
				}
				
				if ( bg_mc != null ) {
					if ( p_centerHorizontal ) {
						asset_mc.x = Math.round( ( bg_mc.width - asset_mc.width) / 2 );
					} else {
						// arrow label button use
						if ( p_isReverse ) {
							if ( text_mc != null ) {
								text_mc.x = Math.round( asset_mc.width );
							}
						} else {
							asset_mc.x = Math.round( textTFWidth + p_xTextMargin + assetOffset );
						}
					}
					if ( p_centerVertical ) {
						asset_mc.y = Math.round( ( bg_mc.height - asset_mc.height) / 2 );
					}
				}else {
					if ( p_centerHorizontal ) {
						asset_mc.x = Math.round( (p_buttonClip.width - asset_mc.width) / 2 );
					} else {
						// arrow label button use
						if ( p_isReverse ) {
							if ( text_mc != null ) {
								text_mc.x = Math.round( assetOffset + asset_mc.width );	
							}
						} else {
							asset_mc.x = Math.round( p_buttonClip.width + assetOffset );
						}
					}
					if ( p_centerVertical ) {
						asset_mc.y = Math.round( (p_buttonClip.height - asset_mc.height) / 2 );
					} 
				}
			}
		}
		
		public static function centerVertical ( p_clip: DisplayObjectContainer ):void {
			var thisHeight:Number = p_clip.height;
			for (var i:uint = 0; i < p_clip.numChildren; i++ )
			{
				var currentClip:DisplayObject = p_clip.getChildAt( i );
				currentClip.y = Math.round(thisHeight/2 - currentClip.height/2);
			}
		}
		
		public static function clearClip( p_clip: DisplayObjectContainer ): void
		{
			if ( p_clip != null ) {
				while( p_clip.numChildren > 0 )
				{
					p_clip.removeChildAt( 0 );
				}
				p_clip.scaleX = p_clip.scaleY = 1;
			}
		}
	}
}