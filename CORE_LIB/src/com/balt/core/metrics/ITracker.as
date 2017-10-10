/**
 * Interface for Tracker.
 *
 * @author adriaan scholvinck
 * @version oct 21 2008
 */
 
package com.balt.core.metrics
{
	public interface ITracker 
	{
		function trackPageView( $locationString:String = null, $pageName:String = null, $referer:String = null, $campaign:String = null ) : void;
		function updatePrefix( $directory : String ) : void;
		function getReferer() : String;
		function getCampaign() : String;
	}
}