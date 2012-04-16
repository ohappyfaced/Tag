package 
{
	
	public class Vector2
	{
		//members of vector class
		private var _x: Number;
		private var _y: Number;
		//constant for conversion from degrees to radians
		public static const DEGRAD: Number = Math.PI/180;
		
		//constructor
		public function Vector2(x:Number=0, y:Number=0)
		{
			_x = x;
			_y = y;
		}
		
		//accessors and mutators -- getters and setters
		public function get x( ) : Number 			{return _x; }
		public function get y( ) : Number 			{return _y; }
		public function set x(x: Number) : void 	{ _x = x; }
		public function set y(y: Number) : void 	{_y = y; }
		
		// public methods

		// returns vector sum of this vector and v2 
		public function add(v2 : Vector2): Vector2
		{
			return new Vector2(_x + v2.x,  _y + v2.y);			
		}
		
		//subtracts v2 from this vector and returns vector difference
		
		public function subtract(v2 : Vector2): Vector2
		{
			return new Vector2(_x - v2.x, _y - v2.y);			
		}
	
		// multiplys this vector by scalar num and returns scaled vector
		public function multiply(num : Number): Vector2
		{
			return new Vector2(_x * num,  _y * num);			
		}
		
		// divides this vector by scalar num and returns scaled vector
		public function divide(num : Number): Vector2
		{
			return new Vector2(_x / num,  _y / num);			
		}
		
		//--------------------------------------------//
		// returns distance between this vector and v2
		public  function distance(v2 : Vector2): Number
		{
			var deltaX = _x - v2.x;
			var deltaY = _y - v2.y;
			return Math.sqrt(deltaX * deltaX + deltaY * deltaY);
		}
		
		// returns squared distance between this vector and v2  
		public function distanceSqr(v2 : Vector2): Number
		{
			var deltaX = _x - v2.x;
			var deltaY = _y - v2.y;
			return (deltaX * deltaX + deltaY * deltaY);
		}	
		
		// returns length or magnitude of this vector
		public function magnitude( ) : Number
		{
			return Math.sqrt(_x * _x + _y * _y);
		}
		
		
		
		// makes this a unity vector (magnitude = 1)
		public function normalize( ) : void
		{
			var mag : Number = Math.sqrt(_x * _x + _y * _y);
			if (mag == 0)
			{
				_x = 0;
				_y = 0;
			}
			else
			{
				_x = _x / mag;
				_y = _y / mag;
			}
		}
		
		// returns a unit vector in direction of this vector
		public function getNormalized( ) : Vector2
		{
			var mag : Number = Math.sqrt(_x * _x + _y * _y);
			return new Vector2(_x / mag, _y / mag);
		}		
		
		// returns angle of this vector in degrees
		public function get angle( ) : Number
		{
			return Math.atan2(_y, _x) * 180 / Math.PI;
		}
		
		// returns a unit vector in direction angle supplied in degrees
		public static function degToVec(deg: Number): Vector2
		{
			var rad = deg * DEGRAD;
			return new Vector2(Math.cos(rad), Math.sin(rad));
		}
		
		// returns a unit vector in direction angle supplied in radians
		public static function radToVec(rad: Number): Vector2
		{
			return new Vector2(Math.sin(rad), Math.cos(rad));
		}
		
		// -----------------------additional vector methods---------------
		
		// returns the dot product of this vector and and v2
		public function dot(v2 : Vector2): Number
		{
			return (_x * v2.x + _y * v2.y);
		}
		
		// rotates this vector by deg degrees
		public function rotate( deg: Number): void
		{
			var rad = deg * DEGRAD;
			var cos = Math.cos(rad);
			var sin = Math.sin(rad);
			var temp = _x;
			_x = _x * cos -  _y * sin;
			_y = _y  * cos +  temp * sin;
		}
		
		// returns a copy of this vector rotated 90 degrees cw
		public function perpRight( ): Vector2
		{
			return new Vector2(-_y, _x);
		}
		
		public function toString( ): String
		{
			return("x:" + int(_x*100)/100 + ",\ty:" + int(_y*100)/100);
		}
		

	}
}