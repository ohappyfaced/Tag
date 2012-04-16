package 
{

	import flash.display.MovieClip;


	public class Obstacle extends MovieClip
	{
		public var radius:Number;
		public var center:Vector2;


		public function Obstacle(aX:Number, aY:Number)
		{
			// constructor code
			this.x = aX;
			this.y = aY;
			center = new Vector2(this.x, this.y);
			radius = this.width / 2;
		}
	}

}