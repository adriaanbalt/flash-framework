// Class uses third-party AlivePDF utility - see http://www.alivepdf.org
package com.balt.data
{
	import com.balt.log.Log;
	import com.balt.text.TextUtil;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.alivepdf.colors.RGBColor;
	
	import org.alivepdf.colors.RGBColor;
	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pages.Page;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Method;
	
	public class AlivePDF
	{
		private var myPDF:PDF;
		
		public function AlivePDF()
		{
		}

		public function generatePDF (pdfFilePath:String):void {
			myPDF = new PDF (Orientation.PORTRAIT, Unit.POINT, Size.LETTER);
			myPDF.addPage();
		
			myPDF.lineStyle(new RGBColor(0xFF0000), 2); // Type needs to be "Color"
			myPDF.drawCircle(300, 300, 100);
			
			// Set new attributes when creating a page
			myPDF.addPage (new Page(Orientation.LANDSCAPE, Unit.POINT, Size.LETTER));
			
			// Saving
			var stream:FileStream = new FileStream();
			var file:File = new File (pdfFilePath);
			
			try {
				stream.open (file, FileMode.WRITE);
				var bytes:ByteArray = myPDF.save (Method.LOCAL);
				stream.writeBytes(bytes);
				stream.close();
			} catch (err:Error) {
				Log.traceMsg("Error AlivePDF.generatePDF: " + err.message + 
				TextUtil.quotes(pdfFilePath), Log.ALERT);
			}
		}
	}
}