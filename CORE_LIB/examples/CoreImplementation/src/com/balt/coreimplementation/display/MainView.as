package com.balt.coreimplementation.display
{
	import com.gs.TweenLite;
	import com.gs.easing.Linear;
	import com.balt.core.location.Location;
	import com.balt.core.location.LocationConstants;
	import com.balt.core.location.LocationData;
	import com.balt.core.log.Log;
	import com.balt.coreimplementation.data.StorageConst;
	import com.balt.coreimplementation.data.dataInterface.IMainStorage;
	import com.balt.coreimplementation.locations.firsttier.FirstTier;
	import com.balt.coreimplementation.nav.Navigation;
	import com.balt.coreimplementation.services.ServicesConstants;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;

	/**
	 * @author adriaan scholvinck
	 */
	public class MainView extends Location
	{	
		private var _mainTimeline:DisplayObjectContainer;
		private var cur_loc_id : String;
		
		public var contentClip : Sprite;
		
	// modules
		private var navigation : Navigation;
		private var storage : IMainStorage;
		
	// section
		private var firstTier : FirstTier;
		
	// loading
		private var defaultLocation : Array;
		private var totalSectionCount : int;
		private var sectionCount : int = 0;
		
		public function MainView( mainTimeline:DisplayObjectContainer )
		{
			this._mainTimeline = mainTimeline;
			this.addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
// public

		public function get mainTimeline():DisplayObjectContainer
		{
			return this._mainTimeline;
		}

		public override function init ( data: * = null ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, init );
			Log.info( "MainView.init" );
			
			// downloads XML; can contain numerous items such as color, fonts, and the starting section of the website
			storage = ServicesConstants.getServices().getMiddleware().getMainStorage();
			storage.loadData( StorageConst.MAIN_XML_PATH );
			storage.addEventListener(StorageConst.EVENT_ON_DATA_LOADED, dataLoadComplete );
			
			this.dispatchEvent( new Event ( LocationConstants.EVENT_ON_INIT ) );
		}
		
		public override function show ( $locationStringArray:Array, $depth:int, $param:* = null ) : Boolean {
			trace ( "" );
			Log.info( "new page:", $locationStringArray );
			Log.info( "$depth:", $depth );
			
			if ( $locationStringArray[ $depth ] ){
				childLocation = firstTier;
			} else {
				this.dispatchEvent(new Event(LocationConstants.EVENT_ON_SHOW_FINISHED ) );
				// change location w/ default video
				var locationData : LocationData = new LocationData( defaultLocation );
				ServicesConstants.getServices().getLocationManager().changeLocation( locationData );
				return true;
			}
			
			navigation.update( $locationStringArray );
			cur_loc_id = $locationStringArray[ $depth ];
			
			this.dispatchEvent(new Event(LocationConstants.EVENT_ON_SHOW_FINISHED ) );
			return true;
		}
		
		public override function hide():void {
			this.dispatchEvent(new Event(LocationConstants.EVENT_ON_HIDE_FINISHED ) );
		}
			
// private
		
		private function onUpdateNav( $e : DataEvent ) : void {
			navigation.update( $e.data.split ( "," ) );
		}
		
		private function stageResize( $event : Event = null ) : void {
			firstTier.stageResize( $event );
			navigation.stageResize( $event );
		}
		
		private function dataLoadComplete( $e : Event ) : void {
			defaultLocation = new Array();
			if ( storage.getDefault().indexOf(",") ) {
				defaultLocation = storage.getDefault().split(",");
			} else {
				defaultLocation = new Array( storage.getDefault() );
			}

			totalSectionCount = storage.getXMLData().numItemsToLoadTotal;

			// instantiate background 
			
						
			// layered container for locations
			contentClip = new Sprite();
			
			this.addChild( contentClip );
			
			// instantiate application locations
			firstTier = new FirstTier();
			firstTier.addEventListener( LocationConstants.EVENT_ON_INIT, onSectionInit );
			firstTier.addEventListener( LocationConstants.UPDATE_NAVIGATION, onUpdateNav );
			contentClip.addChild( firstTier );
			
			// instantiate navigation
			navigation = new Navigation();
			navigation.addEventListener( LocationConstants.EVENT_ON_INIT, onSectionInit );
			this.addChild( navigation );
		}
		
		private function onSectionInit( $event : Event = null ) : void {
			sectionCount++;
			if ( sectionCount == totalSectionCount ) {
				
				Log.info( "MainView.complete" );
				// root section connects all sub sections together via this top level control 
				var rootLocationData : LocationData = new LocationData( [] );
				rootLocationData.location = this;
				ServicesConstants.getServices().getLocationManager().setRootLocation( rootLocationData );
				
				// positioning
				stageResize();
				stage.addEventListener(Event.RESIZE, stageResize);
				
				// animate in
				TweenLite.to(this, .2, { alpha:1, ease: Linear.easeOut} );
			}
		}
		
	}
}

