package com.balt.core.path
{
	import com.balt.text.TextUtil;
	import com.balt.util.PathUtil;
	
	import flash.display.DisplayObjectContainer;

	public class PathManager implements IPathManager
	{		
		private var _localeStr:String;
		private var _currentDomain:String;
		
		private var cssPath:String		= "css/";
		private var fontPath:String 	= "font/";
		private var imagePath:String	= "image/";
		private var soundPath:String	= "sound/";
		private var swfPath:String		= "swf/";		
		private var videoPath:String	= "video/";
		private var xmlPath:String		= "xml/";	

		public function PathManager( rootObj:DisplayObjectContainer, swfPath:String )
		{	
			this.setRootPath( rootObj, swfPath );						
		}

		public function getRootPath():String
		{
			return PathUtil.pathRoot;
		}		
		
		public function updatePaths( pathList:* ):void
		{
			this._localeStr = pathList.locale;			
			
			for( var item:String in pathList )
			{
				if( this.hasOwnProperty( item ) )
				{
					this[item] = pathList[item];
				}
			}			
		}		
		
		public function getDomain():String
		{
			return _currentDomain;
		}
		
		public function getLocale():String
		{
			return this._localeStr;
		}	
		
		public function getCSSPath( absolutePath:Boolean = true ):String
		{
			var path:String;
			
			if( !absolutePath ) path = this.cssPath;
			else path = PathUtil.pathRoot + this.cssPath;
			
			return path;
		}
		
		public function getFontPath( absolutePath:Boolean = true ):String
		{
			var path:String;
			
			if( !absolutePath ) path = this.fontPath;
			else path = PathUtil.pathRoot + this.fontPath;
			
			return path;
		}
		
		public function getImagePath( absolutePath:Boolean = true ):String
		{
			var path:String;
			
			if( !absolutePath ) path = this.imagePath;
			else path = PathUtil.pathRoot + this.imagePath;
			
			return path;
		}
		
		public function getSoundPath( absolutePath:Boolean = true ):String
		{
			var path:String;
			
			if( !absolutePath ) path = this.soundPath;
			else path = PathUtil.pathRoot + this.soundPath;
			
			return path;
		}		
		
		public function getSWFPath( absolutePath:Boolean = true ):String
		{
			var path:String;
			
			if( !absolutePath ) path = this.swfPath;
			else path = PathUtil.pathRoot + this.swfPath;
			
			return path;
		}

		public function getVideoPath( absolutePath:Boolean = true ):String
		{
			var path:String;
			
			if( !absolutePath ) path = this.videoPath;
			else path = PathUtil.pathRoot + this.videoPath;
			
			return path;
		}
		
		public function getXMLPath( absolutePath:Boolean = true ):String
		{
			var path:String;
			
			if( !absolutePath ) path = this.xmlPath;
			else path = PathUtil.pathRoot + this.xmlPath;
			
			return path;
		}
		
		public function updateLocaleString( localeStr:String ):void
		{
			this._localeStr = localeStr;
		}			
		
		public function cleansePath( inPath:String ):String
		{
			return PathUtil.cleansePath( inPath );
		}

		public function ensureTrailingSeparator( inPath:String, newSeparator:String ):String
		{
			return PathUtil.ensureTrailingSeparator( inPath, newSeparator );
		}

		public function removeTrailingSeparator( inPath:String, newSeparator:String ):String
		{
			return PathUtil.removeTrailingSeparator( inPath, newSeparator );
		}

		public function trimTrailingSlash( inPath:String ):String
		{
			return PathUtil.trimTrailingSlash( inPath );
		}

		public function ensureLeadingSeparator( inPath:String, newSeparator:String ):String
		{
			return PathUtil.ensureLeadingSeparator( inPath, newSeparator );
		}
		
		public function ensureTrailingSlash( inPath:String ):String
		{
			return PathUtil.ensureTrailingSlash( inPath );
		}		

		public function ensureExtension( inPath:String, extension:String ):String
		{
			return PathUtil.ensureExtension( inPath, extension );
		}

		public function hasExtension( inPath:String, extensions:* ):Boolean
		{
			return PathUtil.hasExtension( inPath, extensions );
		}

		public function isSwfFormat( inPath:String ):Boolean
		{
			return PathUtil.isSwfFormat( inPath );
		}

		public function isImageFormat( inPath:String ):Boolean
		{
			return PathUtil.isImageFormat( inPath );  
		}

		public function isImageOrSwfFormat( inPath:String ):Boolean
		{
			return PathUtil.isImageOrSwfFormat( inPath );
		}

		public function makePathAbsolute( relativePath:String, addThisPart:String ):String
		{
			return PathUtil.makePathAbsolute( relativePath, addThisPart );
		}
		
		public function makePathRelative( fullPath:String, stripOffThisPart:String ):String
		{
			return PathUtil.makePathRelative( fullPath, stripOffThisPart );
		}

		public function isRelativePath( inPath:String ):Boolean
		{
			return PathUtil.isRelativePath( inPath );
		}

		public function extractFolder( inPath:String, fileSep:String, includeTrailingSep:Boolean, trySlash:Boolean ):String
		{
			return PathUtil.extractFolder( inPath, fileSep, includeTrailingSep, trySlash );
		}
		
		public function unitTest():void
		{
			PathUtil.unitTest();
		}
		
		private function setRootPath( rootObj:DisplayObjectContainer, swfPath:String ):void
		{
			PathUtil.setPathRoot( rootObj, swfPath );
			this._currentDomain = setDomain( PathUtil.pathRoot );			
		}			
		
		private function setDomain( url:String ):String
		{
			//if need be you could change this method to pass both the protocol and domain within an object or whatever
				
			var domain:String = url;
			//pull protocol to determine if we need http:// or https://
			var protocol:String = url.slice(0, url.lastIndexOf('//')+2);
			
			//if this isn't a local test set domain based on domain, else set to a default if assets will be loaded from an external domain, or for service calls
			if (url.indexOf('file:') == -1)
			{
				var tempUrl:String = url.slice(url.lastIndexOf('//')+2, url.length);
				var rawDomain:String = tempUrl.substr(0,tempUrl.indexOf('/'));
				domain = protocol + rawDomain;
			}
			else
			{
				//local = true;
				//domain = some domain that would work for localhost stuff I guess
			}
			
			return domain;
		}
	}
}