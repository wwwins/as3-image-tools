package btn 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author jacky
	 */
	public class BaseBtnLocalFile extends BaseBtn 
	{
		
		public function BaseBtnLocalFile() 
		{
			onClick = function():void {
				trace('new Event("BaseBtnLocalFile")');
				dispatchEvent(new Event("BaseBtnLocalFile", true));
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