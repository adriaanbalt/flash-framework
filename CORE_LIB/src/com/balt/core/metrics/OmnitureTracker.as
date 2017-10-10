// FIXME - needs to be generalized so as not to be hardcoded to use Nokia stuff
package com.balt.core.metrics {

	import com.omniture.ActionSource;
		
	/**
	 * @author scholvincka
	 */
	public class OmnitureTracker extends Tracker {
		
		private var s:ActionSource;
		
		public function OmnitureTracker( $projectName : String, $flashvars : Object = null ) {
			super( $projectName, $flashvars );
			configActionSource();
		}
		
		private function configActionSource():void {
		
			s = new ActionSource();
		
			/* Specify the Report Suite ID(s) to track here */
			s.account = "nokiaglobalfwg0prod";
		
			/* You may add or alter any code config here */
			s.pageName = "";
			s.pageURL = "";
		
			s.charSet = "UTF-8";
			s.currencyCode = "USD";
		
			/* Turn on and configure ClickMap tracking here */
			s.trackClickMap = true;
			s.movieID = "";
		
		
			/* Turn on and configure debugging here */
			s.debugTracking = true;
			s.trackLocal = true;
		
			/* WARNING: Changing any of the below variables will cause drastic changes
			to how your visitor data is collected.  Changes should only be made
			when instructed to do so by your account manager.*/
			s.visitorNamespace = "nokia";
			s.trackingServer = "nokia.112.2o7.net";
		
			this.addChild(s);
		}
		
		public override function trackPageView($locationString:String = null, $pageName:String = null, $referer:String = null, $campaign:String = null ) : void	{
			
			trace ( "trackPageView(: " + $pageName + " ) " );
			
			s.prop6	= "ncomfwus";
			s.pageName = $pageName;
			s.channel = "nokia:nokiausa.com:fw";
			s.server = "nokiausa.com";
			s.prop1	= "nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing";
			s.prop2 = "nokia:nokiausa.com:fw:find products:all phones:nokia n900";
			s.prop3 = "nokia:nokiausa.com:fw:find products:all phones";
			s.prop4 = "nokia:nokiausa.com:fw:find products";
			s.prop5 = "nokia:nokiausa.com:fw";
			s.prop23 = "en:US";
			s.eVar23 = "en:US";
			s.evar7 = $pageName;
			
			s.track();
			
		}
		
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:n900 tab:processing power	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:n900 tab:internal storage	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:n900 tab:fast wireless	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:n900 tab:camera	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:n900 tab:design	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:n900 tab:GPS

//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:maemo tab:web browser	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:maemo tab:multitasking	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:maemo tab:desktops	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:maemo tab:geotags	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:maemo tab:friends	

//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:video tab:landing	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:video tab:n900	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:video tab:video2	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:video tab:video3	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:video tab:video4	
//		nokia:nokiausa.com:fw:find products:all phones:nokia n900:landing:video tab:video5		
		
	}
}
