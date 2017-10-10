package com.balt.fonts
{
	import flash.text.Font;
	/**
	 * Class: UniversLightStd
	 * 
	 * Description: Class instantiation is all that is need to embed these font classes. For easiest use, unless the need for multiple font swfs is needed, simply create a fontLibrary class.
	 * 				Once a fontLibrary class in your project is created, add that class as a module to publish separately in your project, load that swf in as an asset and your specific fonts will be accessible.
	 * 				Some of these fonts are able to be loaded by their respective ttf files. It seems to be rather touchy and unlike AS documentation states, not all .ttf and .otf files can be loaded in this manner.
	 * 				Therefore it seems probably best to load most fonts, unless absolutely necessary, via the "systemFont" attribute rather than the "source" attribute.
	 * 				For a reference on how to use the source attribute see class Impact()
	 * 
	 * 				<p>
	 * 					For reference to what unicode ranges are appropriate for your project see the unicodeTable file in the following areas<br/><br/>
	 * 
	 * 					Mac Flash CS4: Applications/Adobe Flash CS4/en/First Run/FontEmbedding/UnicodeTable.xml
	 * 					Mac Flex Builder: Applications/[FlexbuilderFolder]/sdks/3.2.0/frameworks/flash-unicode-table.xml (also applies to flex builder plugin)
	 * 				</p>
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author	Thaylin D. Burns
	 * @see com.balt.fonts.Impact
	 */
	public class UniversLightStd
	{
		
		[Embed(systemFont="Univers LT Std", fontStyle="45 Light", mimeType='application/x-font', unicodeRange="U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+0100-U+01FF,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183")] 
		public static var font:Class;
		
		public function UniversLightStd()
		{
			Font.registerFont(font);
		}
	
	}
}