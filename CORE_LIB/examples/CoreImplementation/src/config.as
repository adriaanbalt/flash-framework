
import flash.display.StageAlign;
import flash.display.StageScaleMode;
var config:Object = 
{
	
	siteConfig:
	{
		stageScaleMode:StageScaleMode.NO_SCALE,
		stageAlign:StageAlign.TOP_LEFT,
		siteWidth:800,
		siteHeight:600,
		contextMenu:
		{
			copyright:"BALT Core Implementation"
		},
		crossDomain:
		{
			allowDomain:"*",
			allowInsecureDomain:"*"
			//loadPolicyFile:"crossdomain.xml"
		}
	},
	sitePaths:
	{
		//local:
		swfPath:"assets/"
	},
	depotConfig:
	{
		css:"view.css",
		asset:"assets.swf",
		font:"fonts.swf"
	},
	servicesConfig:
	{
		metricsToggle:false
	}
	
}