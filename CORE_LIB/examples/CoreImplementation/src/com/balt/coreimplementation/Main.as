package com.balt.coreimplementation
{
	import com.balt.core.location.ILocation;
	import com.balt.core.location.LocationConstants;
	import com.balt.core.log.Log;
	import com.balt.core.log.LoggerFireBug;
	import com.balt.coreimplementation.display.MainView;
	import com.balt.coreimplementation.display.PreView;
	import com.balt.coreimplementation.services.ServicesConstants;
	import com.balt.coreimplementation.services.ServicesFactory;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Main
	{	
		private var _mainTimeline:DisplayObjectContainer;
		private var _view:ILocation;
		private var _configObj:Object;
		private var _swfPath:String;		
		
		public function Main( mainTimeline:DisplayObjectContainer, configObj:Object, swfPath:String )
		{
			this._mainTimeline = mainTimeline;
			this._configObj = configObj;
			this._swfPath = swfPath;
			
			Log.logger = LoggerFireBug;
			Log.level = Log.LEVEL_INFO;
			
			if( !this._mainTimeline.stage ) this._mainTimeline.addEventListener( Event.ADDED_TO_STAGE, init );
			else init( null );
		}
		
		public function get mainTimeline():DisplayObjectContainer
		{
			return this._mainTimeline;
		}
		
		private function init( evt:Event ):void
		{
			Log.info( "Main.init" );
			this._mainTimeline.removeEventListener( Event.ADDED_TO_STAGE, init );

			// create services
			var servicesFactory:ServicesFactory = new ServicesFactory();
			servicesFactory.addEventListener( ServicesConstants.ON_INIT, onServicesInit );
			servicesFactory.addEventListener( ServicesConstants.ON_COMPLETE, onServicesComplete );
			servicesFactory.createService( this._mainTimeline, this._configObj, this._swfPath );
		}

		private function onServicesInit( evt:Event ):void
		{
			evt.target.removeEventListener( ServicesConstants.ON_INIT, onServicesInit );
			Log.info( "Services.init" );
			
			//var preloader:PreView = new PreView();
			//this._mainTimeline.addChild( preloader );
		}

		private function onServicesComplete( evt:Event ):void
		{
			evt.target.removeEventListener( ServicesConstants.ON_COMPLETE, onServicesComplete );
			Log.info( "Services.complete" );
			
			// create view
			this._view = new MainView( this._mainTimeline );
			this._view.addEventListener( LocationConstants.EVENT_ON_INIT, onViewInit );
			
			// add view
			this._mainTimeline.addChild( Sprite( this._view ) );
		}
		
		private function onViewInit ( evt:Event ):void{ }
		
		private function stageResize( evt:Event ):void { }	
	}
}