package com.balt.coreimplementation.locations.firsttier {
	import com.gs.TweenLite;
	import com.gs.easing.Linear;
	import com.balt.core.location.Location;
	import com.balt.core.location.LocationConstants;
	import com.balt.core.location.LocationData;
	import com.balt.coreimplementation.data.StorageConst;
	import com.balt.coreimplementation.data.dataInterface.ILocationStorage;
	import com.balt.coreimplementation.display.ViewConstants;
	import com.balt.coreimplementation.locations.firsttier.secondtier.SecondTierVariantOne;
	import com.balt.coreimplementation.locations.firsttier.secondtier.SecondTierVariantTwo;
	import com.balt.coreimplementation.services.ServicesConstants;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;

	/**
	 * @author adriaan scholvinck
	 */
	public class FirstTier extends Location {
		
		private var active : Boolean = false;

		private var storage : ILocationStorage;
		
		private var dataArr : Array;
		private var idsList : String;
		private var cur_sec_id : String;
		
		private var container : Sprite;
		private var displayChildren : Array;
		
		private var built : Boolean = false;
		
		public function FirstTier()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
// public

		public override function init( data : * = null ) : void {
			this.removeEventListener( Event.ADDED_TO_STAGE, init );

			// we can start a download here before an animation is completed from a previous section
			// set the storage container
			storage = ServicesConstants.getServices().getMiddleware().getLocationStorage();
			storage.loadData( StorageConst.LOCATION_XML_PATH );
			storage.addEventListener(StorageConst.EVENT_ON_DATA_LOADED, dataLoadComplete );
			
			displayChildren = new Array();
		}
		
		public override function show ( $locationStringArray:Array, $depth:int, $param:* = null ) : Boolean {
			// begin download of all small dataArr

			// set the HTML <title> tag
			ServicesConstants.getServices().getURLAddress().setTitle( ViewConstants.HTML_TITLE_VIDEOS );

			cur_sec_id = $locationStringArray[ $depth ];
			
			var locationData : LocationData;
			
			if ( ($locationStringArray[0].indexOf( "tab" ) != -1) && $locationStringArray[1] != null ){
				// we have a sub item
				if ( idsList.indexOf( $locationStringArray[1] ) != -1 ) {
					if ( built == false ) {
						// build the features only after we've gone to this section, otherwise no need to download all those iamges
						build();
					}
					for ( var i : Number = 0; i < dataArr.length; i++ ) {
						if ( $locationStringArray[1] == dataArr[i].id ) {
							if ( displayChildren[i] ) {
								childLocation = displayChildren[i];
							}  else {
								if ( $locationStringArray[1] == "id" ) {
									childLocation = new SecondTierVariantOne( dataArr[i] );
									childLocation.addEventListener( LocationConstants.EVENT_ON_INIT, sectionInit );
								} else {
									childLocation = new SecondTierVariantTwo( dataArr[i] );
									childLocation.addEventListener( LocationConstants.EVENT_ON_INIT, sectionInit ); 
								}
								container.addChild ( childLocation as Sprite );
								displayChildren[i] = childLocation; 
							}
							stageResize();
							break;
						} 
					} // end for
					dispatchEvent( new DataEvent( LocationConstants.UPDATE_NAVIGATION, false, false, String($locationStringArray) ) );
					
				} else {
					this.dispatchEvent(new Event(LocationConstants.EVENT_ON_SHOW_FINISHED ) );
					// change location w/ default video
					locationData = new LocationData( [ViewConstants.VIDEOS_DEEP_LINK, dataArr[0].id] );
					ServicesConstants.getServices().getLocationManager().changeLocation( locationData );
					return true;	
				}
			} else {
				this.dispatchEvent(new Event(LocationConstants.EVENT_ON_SHOW_FINISHED ) );
				// change location w/ default video
				locationData = new LocationData( [ViewConstants.VIDEOS_DEEP_LINK, dataArr[0].id] );
				ServicesConstants.getServices().getLocationManager().changeLocation( locationData );
				return true;
			}
				
			TweenLite.to(this, .5, { autoAlpha:1, onComplete:showComplete, ease: Linear.easeOut } );
			
			return true;
		}
		
		private function sectionInit( $e : Event ) : void {
		}
		
		protected override function shown() : void {
		//	childLocation.shown();
		}
		
		public override function hide():void {
			TweenLite.to(this, .5, { autoAlpha:0, onComplete:hideComplete, ease: Linear.easeOut } );	
		}
		
		public function stageResize( $event : Event = null ) : void {
		}
		
// private

		private function build() : void {
			built = true;
			
			container = new Sprite();
			this.addChild( container );
			container.x = 0;
			container.y = 0;
		}
		
		private function dataLoadComplete( $event : Event ) : void {
			storage.removeEventListener(StorageConst.EVENT_ON_DATA_LOADED, dataLoadComplete );
			dataArr = storage.getArray();
			
			for ( var i : int = 0; i < dataArr.length; i++ ) {
				idsList += dataArr[i].id + " ";
				
			}
			
			this.dispatchEvent( new Event ( LocationConstants.EVENT_ON_INIT ) );
		}
		
		protected override function destroy() : void {
			active = false;
		}
	}
}
