package  
{
	import flash.display.MovieClip;
	
	public class VectorTurtle extends MovieClip
	{
		// protected >> private
		//added _right and getter for velocity
		private var _position : Vector2;
		private var _fwd : Vector2;
		private var _right : Vector2;
		private var _radius : Number;
		
		protected var _speed : Number;
		protected var _velocity : Vector2;
		protected var _manager : Manager;
		protected var _fwdVec: Vector2;
		
		
		//constructor 
		public function VectorTurtle(aMan:Manager, anX:Number = 0, 
								aY:Number = 0, aSpeed:Number = 10) 
		{
			_manager = aMan;
			x= anX;
			y = aY;
			_radius = Math.sqrt(width*width + height*height)/2;//new
			_position = new Vector2(x, y);
			_speed = aSpeed;
			_fwd = new Vector2(1, 0);
			_right = _fwd.perpRight( );//new
			_velocity = _fwd.multiply(_speed);
			_fwdVec = _fwd.multiply(30);
		}

		//accessors and mutators -- getters and setters
		public function get position( )		: Vector2				{ return  _position;	}
		public function get fwd( )			: Vector2				{ return _fwd;			}
		public function get speed( )		: Number				{ return _speed;		}
		public function get velocity( )		: Vector2				{ return _velocity;		}
		public function get radius( )		: Number				{ return _radius;		}
		public function get fwdVec( )		: Vector2				{ return _fwdVec;		}

		public function set position(pos : Vector2): void
		{
			_position.x = pos.x;
			_position.y = pos.y;
			x = pos.x;
			y = pos.y;
		}
			
		//use this setter whenever you change the fwd vector
		public function set fwd(vec: Vector2): void
		{
			_fwd.x = vec.x;
			_fwd.y = vec.y;
			_fwd.normalize( );
			_right = _fwd.perpRight( );//new
			_fwdVec = _fwd.multiply(50);
			rotation = _fwd.angle;
		}

		public function set speed(amt:Number):void	{_speed = amt; }
		
	
		
		//---------------------------------------//
		public function update( dt : Number): void
		{
			// calculate velocity
			// call move to update position
			_velocity = _fwd.multiply(_speed);
			move(_velocity.multiply(dt));
		}
	
		public function turnRight(ang: Number): void
		{
			// change rotation
			// change forward vector to reflect new orientation
			rotation += ang;
			_fwd = Vector2.degToVec(rotation);
		}
		
		public function turnLeft(ang: Number): void
		{
			// change rotation
			// change forward vector to reflect new orientation
			rotation -= ang;
			_fwd = Vector2.degToVec(rotation);
		}
	
		public function turnAbs(ang: Number): void
		{
			rotation = ang;
			_fwd = Vector2.degToVec(rotation);
		}
		
		public function move( motion:Vector2): void
		{
			// calculate new position by adding the motion vector to old position
			// update MovieClip's coordinates 
			_position = _position.add(motion);
			x = _position.x;
			y = _position.y;
		}
	}
}
