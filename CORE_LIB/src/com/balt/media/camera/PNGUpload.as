package com.balt.media.camera {
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;	

	public class PNGUpload
	{
		/* 
		 * CONSTRUCTOR: (location of script, png, _success function, _error function, _param for POST)
		 * USAGE: PNGUpload.upload
		 */
		public static function upload(_upURL:String,_data:ByteArray,_filename:String,_param:Object,_success:Function,_error:Function):void 
		{
			var uploadURL:URLRequest;
			
			uploadURL = new URLRequest();
			uploadURL.url = _upURL;
			uploadURL.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
			uploadURL.method = URLRequestMethod.POST;
			uploadURL.data = UploadPostHelper.getPostData( _filename, _data,_param);
			uploadURL.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );

			var urlLoader : URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.load( uploadURL );
			
			urlLoader.addEventListener( Event.COMPLETE, _success );
			urlLoader.addEventListener( IOErrorEvent.IO_ERROR, _error);
				
		}	
	}
	
}
