package com.balt.core.path
{
	public interface IPathManager
	{
		function getRootPath():String;
		function getDomain():String;
		function getLocale():String;
		function getCSSPath( absolutePath:Boolean = true ):String;
		function getFontPath( absolutePath:Boolean = true ):String;
		function getImagePath( absolutePath:Boolean = true ):String;
		function getSoundPath( absolutePath:Boolean = true ):String;
		function getSWFPath( absolutePath:Boolean = true ):String;
		function getVideoPath( absolutePath:Boolean = true ):String;
		function getXMLPath( absolutePath:Boolean = true ):String;
		function updateLocaleString( localeStr:String ):void;
		function updatePaths( pathList:* ):void;
		
		function cleansePath( inPath:String ):String;
		function ensureTrailingSeparator( inPath:String, newSeparator:String ):String;
		function removeTrailingSeparator( inPath:String, newSeparator:String ):String;
		function trimTrailingSlash( inPath:String ):String;
		function ensureLeadingSeparator( inPath:String, newSeparator:String ):String;
		function ensureTrailingSlash( inPath:String ):String;
		function ensureExtension( inPath:String, extension:String ):String;
		function hasExtension( inPath:String, extensions:* ):Boolean;
		function isSwfFormat( inPath:String ):Boolean;
		function isImageFormat( inPath:String ):Boolean;
		function isImageOrSwfFormat( inPath:String ):Boolean;
		function makePathAbsolute( relativePath:String, addThisPart:String ):String;
		function makePathRelative( fullPath:String, stripOffThisPart:String ):String;
		function isRelativePath( inPath:String ):Boolean;
		function extractFolder( inPath:String, fileSep:String, includeTrailingSep:Boolean, trySlash:Boolean ):String;
		function unitTest():void;
	}
}