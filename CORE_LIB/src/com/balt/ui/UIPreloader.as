package com.balt.ui
{
	import flash.display.MovieClip;
	
	/**
	 * @author adriaan scholvinck
	 * The clip must be build with appropriate labels
	 */
	public class UIPreloader extends UIElement
	{
		public function UIPreloader()
		{
			super();
		}
		
		public override function init( p_clip: MovieClip = null, p_addChild: Boolean = true ): void
		{
			super.init( p_clip, p_addChild );
			_ui_clip.mouseEnabled = false;
			_ui_clip.mouseChildren = false;

		}
		
		public function turnOn(): void
		{
			gotoLabel( ON );
		}
		
		public function turnOff(): void
		{
			gotoLabel( OFF );
		}
		
	}
}