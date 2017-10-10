package com.balt.ui {
	import com.gs.TweenLite;
	import com.gs.easing.Bounce;
	import com.gs.easing.Sine;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;	

	public class UISimpleButton extends UIButton
	{
		protected var out_mc: Sprite;
		protected var over_mc: Sprite;
		protected var down_mc: Sprite;
		protected var selected_mc: Sprite;
		protected var disabled_mc: Sprite;
		protected var clips:Array;
		protected var clipNames:Array
		
		public function UISimpleButton(p_useHand:Boolean=true)
		{
			super(p_useHand);
		}
		
		public override function init(p_clip:MovieClip=null, 
									  p_addChild:Boolean=true ):void {
			
			super.init( p_clip, p_addChild );
			
			out_mc = new Sprite();
			over_mc = new Sprite();
			down_mc =  new Sprite();
			selected_mc = new Sprite();
			disabled_mc = new Sprite();
			clips = [out_mc, over_mc, down_mc, selected_mc, disabled_mc];
			clipNames = ["out_mc", "over_mc", "down_mc", "selected_mc", "disabled_mc"];
			
			for (var i:uint=0; i<clipNames.length; i++) {
				var clip:Sprite = clips[i];
				clip.name = clipNames[i];
				if ( clip.name != "out_mc" ) {
					clip.alpha = 0;
				} else {
					clip.alpha = 1;
				}
				addChild(clip);
			}
			addChild(out_mc);
	 	}
		
		public function setup( outState:DisplayObject,
							   overState:DisplayObject,
							   downState:DisplayObject = null,
							   selectedState:DisplayObject = null,
							   disabledState:DisplayObject = null ):void {
			
			out_mc.addChild( outState );
			over_mc.addChild( overState );
			
			if ( downState == null ) {
				down_mc = over_mc;
			} else {
				down_mc.addChild( downState );
			}
					
			if ( selectedState == null ) {
				selected_mc = over_mc;
			} else {
				selected_mc.addChild( selectedState );
			}
						
			if ( disabledState == null ) {
				disabled_mc = over_mc;
			} else { 
				disabled_mc.addChild( disabledState );
			}
		}
		
		public override function useDefaultLabel(): void
		{
			gotoLabel( OUT );
		}
		
		public override function gotoLabel( p_label: String ): void
		{
			//clearTween();
			switch ( p_label) {
				case OVER:
					focusClip( over_mc );
				break;
				case OUT:
					focusClip( out_mc );
				break;
				case DOWN:
					focusClip( down_mc );
				break;
				case DISABLED:
					focusClip( disabled_mc );
				break;
				case SELECTED:
					focusClip( selected_mc );
				break;
				default:
					
				break;
			}
		}
		
		protected function focusClip( mc:Sprite, speed:Number = 0.3 ):void {
			//this.disabled = true;
			if ( clips != null ) {
				for (var i:uint=0; i<clips.length; i++) {
					var clipName:String = Sprite(clips[i]).name;
					if ( clipName != mc.name ) {
						TweenLite.to( clips[i], speed+0.1, { autoAlpha: 0, ease: Bounce.easeOut } );
					}
				}
				TweenLite.to( mc, speed, { autoAlpha: 1, onComplete: onTweenComplete, ease: Sine.easeOut } );
			}
		}
		
		protected function onTweenComplete () :void {
			//this.disabled = false;
		}

	}
}