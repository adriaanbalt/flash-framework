package com.balt.coreimplementation.locations.firsttier.secondtier {
	import com.gs.TweenLite;
	import com.gs.easing.Quad;
	import com.balt.core.location.LocationData;
	import com.balt.coreimplementation.display.ViewConstants;
	import com.balt.coreimplementation.services.ServicesConstants;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author adriaan scholvinck
	 */
	public class SecondTierVariantOne extends SecondTierAbstract {
		 
		private var landingHome : MovieClip;
	        
		public function SecondTierVariantOne( $dataObj : Object ) {
			super( $dataObj );
			
			this.addEventListener( Event.ADDED_TO_STAGE, init );
		}

		// public

		public override function init( data : * = null ) : void {
			this.removeEventListener( Event.ADDED_TO_STAGE, init );
			buildLanding();
		}
		
		public override function show ( $locationStringArray:Array, $depth:int, $param:* = null ) : Boolean {
			
			if ( $locationStringArray[$depth] != null ) {
				TweenLite.to(landingHome, .5, { autoAlpha:0, ease: Quad.easeOut } );
				//childLocation = null;
			} else {
				// show landing
				TweenLite.to(landingHome, .5, { autoAlpha:1, ease: Quad.easeOut } );
			}
			
			ServicesConstants.getServices().getTracker().trackPageView( null, dataObj.landingmetrics );
			
			showComplete();
			
			TweenLite.to(this, .5, { autoAlpha:1, ease: Quad.easeOut } );	
			return true;
		}
		
		public override function hide():void {
			hideComplete();
			TweenLite.to(this, .5, { autoAlpha:0, ease: Quad.easeOut } );	
		}
		
		public function stageResize( $e : Event = null ) : void {
		}
		
// private
		
		private function buildLanding() : void {	
		}
		
		private function watchVideo( $e : Event ) : void {
			var locationData : LocationData = new LocationData( [ViewConstants.VIDEOS_DEEP_LINK, "landing", "video"] );
			ServicesConstants.getServices().getLocationManager().changeLocation( locationData );
		}
		
// protected
		
		protected override function destroy() : void {	
		}
	
	}
}
