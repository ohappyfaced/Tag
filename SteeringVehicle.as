package  
{
	public class SteeringVehicle extends VectorTurtle
	{
		protected var _maxSpeed: Number = 150;
		protected var _maxForce: Number = 150;
		protected var _mass: Number = 1.0;
	
		public function SteeringVehicle(aMan:Manager, aX:Number = 0, 
								aY:Number = 0, aSpeed:Number = 0) 
		{
			super(aMan, aX, aY, aSpeed);
			// initialize velocity to zero so movement results from applied force
			_velocity = new Vector2( );
		}
		
		public function set maxSpeed(s:Number)		{_maxSpeed = s;	}
		public function set maxForce(f:Number)		{_maxForce = f;	}
		public function get maxSpeed( )		{ return _maxSpeed;	}
		public function get maxForce( )		{ return _maxForce; }
		public function get right( )		{ return fwd.perpRight( ); }


		override public function update(dt:Number): void
		{
			//call calcSteeringForce (override in subclass) to get steering force
			var steeringForce:Vector2 = calcSteeringForce( ); 
			
			// clamp steering force to max force
			steeringForce = clampSteeringForce(steeringForce);
	
			// calculate acceleration: force/mass
			var acceleration:Vector2 = steeringForce.divide(_mass);
			// add acceleration for time step to velocity
			_velocity = _velocity.add(acceleration.multiply(dt));
			// update speed to reflect new velocity
			_speed = _velocity.magnitude( );
			// update fwd to reflect new velocity 
			fwd = _velocity;
			// clamp speed and velocity to max speed
			if (_speed > _maxSpeed)
			{
				_velocity = _velocity.divide(_speed);
				_velocity = _velocity.multiply(_maxSpeed);
				_speed = _maxSpeed;
			}
			// call move with velocity adjusted for time step
			move( _velocity.multiply(dt));
		}
		
				
		protected function calcSteeringForce( ):Vector2
		{
			var steeringForce : Vector2 = new Vector2( );
			//override in subclasses
			return new Vector2( );
		}

			
		protected function clampSteeringForce(force: Vector2 ): Vector2
		{
			var mag:Number = force.magnitude();
			if(mag > _maxForce)
			{
				force = force.divide(mag);
				force = force.multiply(_maxForce);
			}
			return force;
		}
		
			
		protected function seek(targPos : Vector2) : Vector2
		{
			// set desVel equal desired velocity
			var desVel:Vector2 = targPos.subtract(position);

			// scale desired velocity to max speed
			desVel.normalize( );
			desVel = desVel.multiply(_maxSpeed);

			// subtract current velocity from desired velocity
			// to get steering force
			var steeringForce:Vector2 = desVel.subtract(_velocity);
			//return steering force
			return steeringForce;
		}
		
		protected function flee(targPos : Vector2) : Vector2
		{
			// set desVel equal desired velocity
			var desVel:Vector2 = position.subtract(targPos);

			// scale desired velocity to max speed
			desVel.normalize( );
			desVel = desVel.multiply(_maxSpeed);

			// subtract current velocity from desired velocity
			// to get steering force
			var steeringForce:Vector2 = desVel.subtract(_velocity);
			return steeringForce;
			//return steering force
		}
		

			protected function avoid(obstaclePos:Vector2, obstacleRadius:Number, safeDistance:Number): Vector2 
			{
				var desVel: Vector2; //desired velocity
				var vectorToObstacleCenter: Vector2 = obstaclePos.subtract(position);
				var distance: Number = vectorToObstacleCenter.magnitude();
				
				//if vectorToCenter - obstacleRadius longer than safe return zero vector
				 if(distance - obstacleRadius > safeDistance ) 
				 	return new Vector2( );
					
				// if object behind me return zero vector
				if(  vectorToObstacleCenter.dot(fwd) < 0  ) 
					return new Vector2( );			
				
				// if sum of radii < dot of vectorToCenter with right return zero vector
				// 
				var rightDotVTOC:Number = vectorToObstacleCenter.dot(right);
				 if ((obstacleRadius + radius) < Math.abs(rightDotVTOC)) 
				 	return new Vector2( );
				 
				//desired velocity is to right or left depending on 
				// sign of  dot of vectorToCenter with right 
				if (rightDotVTOC > 0) //object is on right so we turn left
					desVel = right.multiply(-1);
				else  //object is on left so we turn right
					desVel = right;
					
				//increase magnitude when obstacle is close
				desVel = desVel.multiply(maxSpeed * safeDistance/distance);

				//subtract current velocity from desired velocity to get steering force
				var steeringForce:Vector2 = desVel.subtract(_velocity);
				return steeringForce;  //return steering force		
			}
			
		public function align (v1 : Vector2):Vector2
		{
			var desVel:Vector2 = v1.getNormalized( );
			desVel = desVel.multiply(maxSpeed);
			//subtract current velocity from desired velocity to get steering force
			var steeringForce:Vector2 = desVel.subtract(_velocity);
			return steeringForce;  //return steering force		
		
		}
	}
}



