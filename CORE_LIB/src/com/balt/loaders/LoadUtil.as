package com.balt.loaders
{
	import com.balt.log.Log;	
	import com.balt.text.CSSObject;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;	

	public class LoadUtil
	{	
		public function LoadUtil(){ }
		
		/**
		 * @description load data file ex) xml and txt file 
		 * @param p_path
		 * @param p_successCB
		 * @param p_errorCB
		 * 
		 */
		public static function loadData( url:String, onComplete:Function, onError:Function = null, onProgress:Function = null, onOpen:Function = null ):URLLoader
		{
			var loader:URLLoader = new URLLoader();
			
			loader.addEventListener( Event.COMPLETE, onComplete );
			loader.addEventListener( IOErrorEvent.IO_ERROR, ( onError!=null) ? onError : onErrorLoad );
			loader.addEventListener( ProgressEvent.PROGRESS, ( onProgress!=null ) ? onProgress : onProgressLoad );
			if( onOpen!=null )loader.addEventListener( Event.OPEN, onOpen );
			
			loader.load( new URLRequest( url ) );
			return loader;
		}
		
		/**
		 * @description load image or movie ex) swf, jpg, png files
		 * @param p_path external file url
		 * @param p_successCB callback function when it sucess
		 * @param p_errorCB callback function when it fail
		 * 
		 */
		public static function loadExternal ( url:String, onComplete:Function, onError:Function = null, onProgress:Function = null, onOpen:Function = null  ):Loader
		{
			var loader:Loader;
			loader = new Loader();
			
			if ( url == "" )
			{
				Log.traceMsg( "LoadUtil: Error trying to load meaningless path", Log.ERROR );
				return loader;
			}

			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onComplete );
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, ( onProgress!=null ) ? onProgress : onProgressLoad );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ( onError!=null ) ? onError : onErrorLoad );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.NETWORK_ERROR, ( onError!=null ) ? onError : onErrorLoad );
			if( onOpen!=null )loader.contentLoaderInfo.addEventListener( Event.OPEN, onOpen );
			
			var context: LoaderContext = new LoaderContext( );
			context.checkPolicyFile = true;
			
			if( Security.sandboxType == Security.REMOTE )
			{
				context.securityDomain = SecurityDomain.currentDomain;
			}
			
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			loader.load( new URLRequest( url ), context );
			return loader;
		}
		
		public static function loadImage( url:String, onComplete:Function, onError:Function = null, onProgress:Function = null, onOpen:Function = null ):Loader
		{
			return loadExternal( url, onComplete, onError, onProgress, onOpen );
		}
		
		public static function loadSWF( url:String, onComplete:Function, onError:Function = null, onProgress:Function = null, onOpen:Function = null ):Loader
		{
			return loadExternal( url, onComplete, onError, onProgress, onOpen );
		}
		
		public static function loadCSS( url:String, onComplete:Function, onError:Function = null, onProgress:Function = null, onOpen:Function = null ):CSSObject
		{
			var loader:CSSObject = new CSSObject();
			
			loader.addEventListener( Event.COMPLETE, onComplete );
			loader.addEventListener( IOErrorEvent.IO_ERROR, ( onError!=null ) ? onError : onErrorLoad );
			loader.addEventListener( ProgressEvent.PROGRESS, ( onProgress!=null ) ? onProgress : onProgressLoad );
			if(onOpen!=null)loader.addEventListener( Event.OPEN, onOpen );
			
			loader.load( new URLRequest( url ) );
			return loader;
		}
		
		private static function onErrorLoad( p_errorEvent:IOErrorEvent ):void
		{
			Log.traceMsg( "*** LoadUtil.onErrorLoad: " + p_errorEvent.text, Log.ERROR );
			//log ( p_errorEvent , this );
			throw ( p_errorEvent );
		}
		
		private static function onProgressLoad( $e:ProgressEvent ):void
		{
			var percent : Number = ( $e.bytesLoaded / $e.bytesTotal ) * 100;
			Log.traceMsg( "*** LoadUtil.onProgress: bytesLoaded: " + $e.bytesLoaded +
							 " | bytesTotal: " + $e.bytesTotal + " | percent: " + percent, Log.ESOTERIC );
		}
	}
}