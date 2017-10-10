package
{
	import com.balt.coreimplementation.Main;
	import com.balt.coreimplementation.Model;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
 
	[SWF( width="800", height="600", frameRate="30", backgroundColor="#ffffff" )]
	
	public class MainFlex extends MovieClip
	{
		private var SWFpath:String = "swf/main.swf";
		private var XMLpath:String = "xml/config.xml";		
		
		public function MainFlex()
		{
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener( Event.COMPLETE, _onLoadComplete );
			l.load( new URLRequest( '../../bin/' + SWFpath ) );
			Model.getInstance().compiledFromFlex = true;
		}
		
		private function _onLoadComplete( $evt:Event ):void
		{
			var main:Main = new Main( $evt.target.content, XMLpath, SWFpath );
			addChild( main.mainTimeline );
		}
	}
}