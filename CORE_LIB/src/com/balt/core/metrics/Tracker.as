

/**
 * Implements metrics functions for the site.
 */

package com.balt.core.metrics {
	import com.balt.core.metrics.ITracker;

	import flash.display.Sprite;
	import flash.display.Stage;

	public class Tracker extends Sprite implements ITracker 
	{
	
		private var PROJECT_NAME	 				: String; // referenced variable used in the vcon to denote which director/project this is
		private var flashvars						: Object; // referenced variable containing the initial referer and campaign information
		
		internal var prefix							: String; // the vcon
		
		internal var trackReferer 					: Boolean = false; // whether or not to track the referer
		internal var referer 						: String;		
		internal var trackCampaign 					: Boolean = false; // whether or not to track the campaign
		internal var campaign						: String;
	
		/**
		 * Tracker Constructor
		 * @param projectName (string) : project name aka the root location
		 * @param flashvars (object) : holds referer and campaign information
		 * @see Site.as : instantiated by the site as a module and connected when needed
		 */
		public function Tracker( $projectName : String, $flashvars : Object = null )
		{
			PROJECT_NAME = $projectName;
			flashvars = $flashvars;
//			grabmetricsParams();
		}
			
		/**
		 * Tracks a page view event
		 * 
		 * @param locationString the location of the page being tracked (used to create the vcon)
		 * @param pageName the name of the page to track
		 * @param campaign overrides the campaign field of the Tracker object
		 * @param referer overrides the referer field of the Tracker object
		 */
		public function trackPageView($locationString:String = null, $pageName:String = null, $referer:String = null, $campaign:String = null ) : void	{
			var vcon : String = prefix;
			trace("Tracker.trackPageView() : vcon=" + vcon + " - page=" + $pageName + "); - debug only, no call made.");
		}
		
		
		/**
		 * updatePrefix
		 * @param prefix (String) : string that is added in between the project name (aka root) and the location data that follows
		 * 
		 * could be used with the Locale Manager @see Site.as 
		 */
		public function updatePrefix( $directory : String ) : void {
			prefix = "/" + PROJECT_NAME + "/" + $directory + "/";
		}
		

		public function getReferer():String {
			return referer;
		}
		public function getCampaign():String {
			return campaign;
		}
		
		internal function isLocal( $roofRef : Object = null ) : Boolean {
			// based off of the Site
			if ( $roofRef == null ) $roofRef = Stage;
		//	if ( getDomain( $roofRef ) == "file://" ) return true;
			return false;
		}
	/* 	internal function getDomain( $rootRef : Object ) : String {
			var count : int = 0;
			var len : int = $rootRef._url.length; // this doesnt exist
			trace ( "getDomain() len: " + len );
			for ( var i : int = 0; i < len; i++ ){
				if ( $rootRef._url.charAt(i) == "/" ){
					count++;
				}
				if ( count == 3 ) {
					return $rootRef._url.slice( i, len );
				}
			}
			return "";
		} */
		
		/**
		 * grabmetricsParams
		 * @version saves data from the flashvars
		 */
		private function grabmetricsParams() : void{
	
			// Track the referer		
			this.referer = (( flashvars.referer == undefined ) || ( flashvars.referer == "" )) ? "bookmark" : flashvars.referer;
			trackReferer = true;
					
			// Check to see if we have a campaign tag to track
			if (flashvars.campaign) {
				this.campaign= flashvars.campaign;
				trackCampaign = true;
			}
		}
	}
}