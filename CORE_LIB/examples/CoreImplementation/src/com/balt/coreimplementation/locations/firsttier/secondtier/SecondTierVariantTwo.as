package com.balt.coreimplementation.locations.firsttier.secondtier {
	import com.gs.TweenLite;
	import com.gs.easing.Quad;
	import com.balt.core.location.LocationConstants;
	import com.balt.coreimplementation.display.ViewConstants;
	import com.balt.coreimplementation.services.ServicesConstants;
	import com.balt.events.ObjectDataEvent;
	import com.balt.media.video.FLVPlayer;
	import com.balt.media.video.FLVPlayerControls;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author adriaan scholvinck
	 */
	public class SecondTierVariantTwo extends SecondTierAbstract {
		 
		public var id : String;
		
		protected var loadCount : Number = 0;
		protected var totalLoadCount : Number = 0;
	
	// -- containers
		protected var flvplayer : FLVPlayerControls;
		protected var hasVideo : Boolean = false;
		
	// -- text
	        
		public function SecondTierVariantTwo( $dataObj : Object )
		{
			super( $dataObj );
			this.addEventListener( Event.ADDED_TO_STAGE, init );
		}

		// public

		public override function init( data : * = null ) : void {
			this.removeEventListener( Event.ADDED_TO_STAGE, init );
			
			buildVideo();
					
		}
		
		public override function show ( $locationStringArray:Array, $depth:int, $param:* = null ) : Boolean {
			showComplete();
			checkVideoLoad();
			
			ServicesConstants.getServices().getTracker().trackPageView( null, dataObj.metrics );
			
			return true;
		}
		
		public override function hide():void {
			hideComplete();
			TweenLite.to(this, .5, { autoAlpha:0, ease: Quad.easeOut } );	
			flvplayer.STOP();
		}
		
		public function stageResize( $e : Event = null ) : void {
		}

// private

// ___________________________________________________________________________________________
// 		VIDEO
// ___________________________________________________________________________________________
		
		private function checkVideoLoad( $e : Event = null ) : void {
			if ( loadCount >= totalLoadCount ) {
				flvplayer.visible = true;
				flvplayer.RESUME();
				TweenLite.to(this, .5, { autoAlpha:1, ease: Quad.easeOut } );
			} else {
				var timer : Timer = new Timer( 1000, 0 );
				timer.addEventListener( TimerEvent.TIMER_COMPLETE, checkVideoLoad );
				timer.start();
			}
		}
		
		private function buildVideo() : void {
			if ( dataObj.video.toString() != "" ) {
				hasVideo = true;
				flvplayer = new FLVPlayerControls( ServicesConstants.getServices().getAssetManager().getLibrary(), ViewConstants.VIDEO_WIDTH, ViewConstants.VIDEO_HEIGHT );
				flvplayer.addEventListener( FLVPlayer.EVENT_ON_START, onVideoStart );
				flvplayer.addEventListener( FLVPlayer.EVENT_ON_CUEPOINT, onVideoCuepoint );
				flvplayer.addEventListener( FLVPlayer.EVENT_ON_STOP, onVideoComplete );
				flvplayer.visible = false;
				this.addChild( flvplayer );
				var autoplay : Boolean = dataObj.video.autoplay == "true" ? true : false;
				var loop : Boolean = dataObj.video.loop == "true" ? true : false;
				flvplayer.setup(dataObj.video.path.toString(), autoplay, loop, dataObj.video.cuepoints );
			}
		}
		
		protected function onVideoStart( $e : Event = null ) : void {
			onSectionInit();
		}
		
		
		private function onVideoComplete( $e : Event = null ) : void {
			// TODO change location to the next video
		}
		
		private function onVideoCuepoint( $e : ObjectDataEvent ) : void {
			if ( $e.data.name != "" ) {
			}
		}
		
// protected
		
		protected function onSectionInit( $event : Event = null ) : void {
			loadCount++;
			if ( loadCount >= totalLoadCount ) {
				
				this.dispatchEvent( new Event ( LocationConstants.EVENT_ON_INIT ) );
				stageResize();
			}
		}
		
		protected function drawSquare( $target : Sprite, $w : Number, $h : Number ) : void {
			$target.graphics.clear();
			$target.graphics.beginFill( ViewConstants.FONT_LIGHT_COLOR, 1);
			$target.graphics.drawRoundRectComplex(
				0,
				0,
				$w,
				$h,
				0,
				0,
				0,
				0
			);
			$target.graphics.endFill();	
		}
		
		protected override function destroy() : void {	
		}
	
	}
}
