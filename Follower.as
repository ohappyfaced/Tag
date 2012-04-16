package 
{

	public class Follower extends SteeringVehicle
	{
		public static var followWeight:Number = 10;
		public static var avoidWeight:Number = 10;
		public static var sepWeight:Number = 10;
		public static var _followingTurtle:SteeringVehicle;
		public var leader:Boolean;
		private var room:Obstacle;
		
		var roomArray:Array;

		public function Follower(aMan:Manager, aX:Number = 0, aY:Number = 0, aSpeed:Number = 0)
		{
			// constructor code
			super(aMan, aX, aY, aSpeed);
			//aMan.addChild(this);
			leader = false;
		}
		
		public function get followingTurtle():SteeringVehicle
		{
			return _followingTurtle;
		}
		
		public function set followingTurtle(ft:SteeringVehicle):void
		{
			_followingTurtle = ft;
		}
		
		override protected function calcSteeringForce():Vector2
		{
			var forces:Vector2 = new Vector2();
			// if following a turtle add that 
			if(leader)
			{
				forces = forces.add(this.seek(new Vector2(100,100)));
			}
			else
			{
				// otherwise it seeks a room
				forces = forces.add(follow());
			}
			forces.add(separate().multiply(sepWeight));
			return forces;
		}
		
		// follow seeks the turtle they are following's position
		private function follow() : Vector2
		{
			var followVector:Vector2;
			followVector = this.seek(_followingTurtle.position);
			
			return followVector;
		}
		
		private function separate() : Vector2
		{
			var tempVec:Vector2 = new Vector2();
			// get closest neighbor
			tempVec = _manager.nearestNeighbor(this, 20);
			tempVec = this.flee(tempVec);
			return tempVec;
		}

	}

}