package com.balt.coreimplementation.data
{
	import com.balt.coreimplementation.services.ServicesConstants;
	import com.balt.util.PathUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	public class StorageConst
	{
		public static var EVENT_ON_DATA_PROGRESS	:String = ProgressEvent.PROGRESS;
		public static var EVENT_ON_DATA_ERROR		:String = IOErrorEvent.IO_ERROR;
		public static var EVENT_ON_DATA_LOADED 		:String = Event.COMPLETE;
		
		private static var rootPath:String = ServicesConstants.getServices().getPathManager().getRootPath();
		
		// xml data file paths.
		public static var MAIN_XML_PATH:String = rootPath + "xml/main.xml";
		public static var NAV_XML_PATH:String = rootPath + "xml/navigation.xml";
		public static var LOCATION_XML_PATH:String = rootPath + "xml/location.xml";
	}
}