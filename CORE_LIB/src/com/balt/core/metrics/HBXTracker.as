

/**
 * subclasses Tracker
 * implements the HitBox metrics 
 * 
 * tracks pages via javascript calls to the browser
 * 
 * @author adriaan scholvinck
 * @version oct 21 2008
 */

package com.balt.core.metrics
{
//	import com.balt.core.SiteURL;
	import com.balt.core.metrics.Javascript;
	import com.adobe.utils.StringUtil;

	public class HBXTracker extends Tracker
	{
	
		private static var CAMPAIGN					: String  	= "_hbCampaign";
		private static var PAGEVIEW 				: String	= "_hbPageView";
		private static var REFERER					: String	= "_hbSet";
		private static var LINK						: String	= "_hbLink"; // ?
	
		/**
		 * Hitbox Tracker Constructor
		 * @param projectName (string) : project name aka the root location
		 * @param flashvars (object) : holds referer and campaign information
		 * @see Site.as : instantiated by the site as a module and connected when needed
		 */
		public function HBXTracker( $projectName : String, $flashvars : Object = null ) {
			super( $projectName, $flashvars );
			trace ( "HitBox Tracker v1.0");
		}
			
		/**
		 * Tracks a page view event
		 * 
		 * @param locationString (String) : the location of the page being tracked (used to create the vcon)
		 * @param pageName (String) : the name of the page to track
		 * @param referer (String) : overrides the referer field of the Tracker object
		 * @param campaign (String) : overrides the campaign field of the Tracker object
		 */
		public override function trackPageView($locationString:String = null, $pageName:String = null, $referer:String = null, $campaign:String = null ) : void	
		{	
			// Use the parameters if passed
			if ( $referer != null ) this.referer = $referer;
			if ( $campaign != null ) this.campaign = $campaign;
			
			var vcon : String = prefix;
			
			if ( ( $locationString != null ) && ( $locationString != "" )) {
				vcon += hbxStrip( StringUtil.replace($locationString, ",", "/") ).toLowerCase() + "/";
			}
			
			$pageName = hbxStrip($pageName).toLowerCase();
				
			if( isLocal() ) {
				
				trace(" metrics locally - debug only, no call made.");
				
			} else {
				
				// This  array holds all the javascript calls that need to be made
				var funcArr : Array = new Array;
				
				// If we need to track a referrer, then add a javascript call to set that 
				// variable for the hitbox script.
				if (this.trackReferer) {
					funcArr.push({name:REFERER, parameters: ["rf", this.referer]});
				}
					
				// If we need to track the campaign, then add a js call to the hitbox
				// function to track campaigns, otherwise just use the pageview function
				if (this.campaign) {
					funcArr.push({name:CAMPAIGN, parameters: [this.campaign, $pageName, vcon]});
					this.trackCampaign = true;
				} else {
					funcArr.push({name:PAGEVIEW, parameters: [$pageName, vcon]});
				}
				
				// Finally, execute the javascript calls on the array
				Javascript.executeAll(funcArr);
			}
			
			// Update the referer variable to be used on the next metrics call
			// referer = SiteURL.getDomain(_root) + vcon + $pageName;
			// updates the universal referer in the Site
		}
		
			
		/**
		 * Utility method to remove unwanted characters from hbx input
		 * @param $str (String) : string to strip
		 * @return formatted String
		 */
		public function hbxStrip( $str:String ):String {
			$str = $str.split("|").join("");
			$str = $str.split("&").join("");
			$str = $str.split("'").join("");
			$str = $str.split("#").join("");
			$str = $str.split("$").join("");
			$str = $str.split("%").join("");
			$str = $str.split("^").join("");
			$str = $str.split("*").join("");
			$str = $str.split(":").join("");
			$str = $str.split("!").join("");
			$str = $str.split("<").join("");
			$str = $str.split(">").join("");
			$str = $str.split("~").join("");
			$str = $str.split(";").join("");
			$str = $str.split(" ").join("+");
			return $str;    
		}	
	}
}