package btn 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author jacky
	 */
	public class BaseBtnFbAlbums extends BaseBtn 
	{
		
		public function BaseBtnFbAlbums() 
		{
			onClick = function():void {
				trace('new Event("BaseBtnFbAlbums")');
				dispatchEvent(new Event("BaseBtnFbAlbums", true));
			}
			onRollOver = function():void {
				trace("over");
				gotoAndPlay("lv1");
			}
			onRollOut = function():void {
				trace("out");
				gotoAndPlay("lv2");
			}

		}
		
	}

}