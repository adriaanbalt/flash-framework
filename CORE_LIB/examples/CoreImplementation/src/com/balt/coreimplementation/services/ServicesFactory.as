/**
 * @author adriaan scholvinck | adriaan@liquidium.com
 */

package com.balt.coreimplementation.services
{	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class ServicesFactory extends EventDispatcher
	{
		public static var _service:IServices;
		
		public function ServicesFactory()
		{
		}
		
		public function createService( mainTimeline:DisplayObjectContainer, configObj:Object, swfPath:String ):void
		{
			_service = new Services();
			_service.addEventListener( ServicesConstants.ON_INIT, onServicesEvent);
			_service.addEventListener( ServicesConstants.ON_COMPLETE, onServicesEvent); 
			_service.initialize( mainTimeline, configObj, swfPath );
		}
		
		private function onServicesEvent( evt:Event ):void
		{
			this.dispatchEvent( evt );
		}

	}
}