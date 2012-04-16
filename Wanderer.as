package  {
	
	public class Wanderer extends SteeringVehicle
	{ 
		// tweak these value to tune behavior
		public static var wanderWeight:Number = 10;
		public static var sepWeight:Number = 5;
		public static var containWeight:Number = 10;
		public var isIt:Boolean = false;
		public var justTagged:Boolean = false;
		public var it:SteeringVehicle;
		public var tagTimer:Number;
		public var closestObject:SteeringVehicle;
		
		private var _wanderRad:Number = 4;
		private var _wanderAng :Number = 0;
		private var _wanderDist :Number = 10;
		private var _wanderMax :Number = 2;
		private var _center : Vector2;
		private var _tether: Number = 150;
		
		var obsArray:Array;
		

		public function Wanderer(aMan:Manager, aX:Number=0, aY:Number=0, aSpeed:Number=0 )
		{
			super(aMan, aX, aY, aSpeed);
			aMan.addChild(this);
			_center = new Vector2(583, 113);
		}	
		
		override public function update(dt:Number): void
		{
			//call calcSteeringForce (override in subclass) to get steering force
			var steeringForce:Vector2 = calcSteeringForce( ); 
			
			// clamp steering force to max force
			steeringForce = super.clampSteeringForce(steeringForce);
	
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
			
			if(justTagged)
			{
				if(tagTimer < 1000)
				{
					tagTimer += dt;
				}
				else
				{
					justTagged = false;
				}
			}
		}
			
		//this calcSteeringForce combines two forces: tether and wander
		//arbitration can be contolled by changing the weights
		override protected function calcSteeringForce( ):Vector2
		{
			var forces:Vector2 = new Vector2( );
			forces = forces.add(wander().multiply(5));	
			forces = forces.add(separate());
			forces = forces.add(contain().multiply(100));
			if(isIt)
			{
				if(!justTagged)
				{
					forces = forces.add(this.seek(_manager.nearestNeighbor(this, 250)).multiply(3));
				}
			}
			else
			{
				forces = forces.add(this.flee(it.position).multiply(10));
			}
			
			return forces;
		}
		
		public function changeIt(newIt:SteeringVehicle)
		{
			it = newIt;
		}
		
		public function gotTagged()
		{
			isIt = true;
			justTagged = true;
		}
		
		//wander is an implementation of the Reynolds wander behavior
		private function wander() :Vector2
		{
			_wanderAng += (Math.random()*_wanderMax *2 - _wanderMax);
			var redDot :Vector2 = position.add(fwd.multiply(_wanderDist));
			var offset :Vector2 = fwd.multiply(_wanderRad);
			offset.rotate(_wanderAng);
			redDot = redDot.add(offset);
			return seek(redDot);
		}
		
		private function contain() : Vector2
		{
			graphics.clear();
			var probe:Vector2 = new Vector2(position.x + fwdVec.x, position.y + fwdVec.y);
			
			if(probe.x < 360)
			{
				trace("x<360");
				return this.seek(_center); 
			}
			if(probe.x > stage.stageWidth - 20)
			{
				trace("x<780");
				return this.seek(_center); 
			}
			if(probe.y < 20)
			{
				trace("y<20");
				return this.seek(_center);
			}
			if(probe.y > 230)
			{
				trace("y>230");
				return this.seek(_center);
			}
			
			var rightProbe:Vector2 = new Vector2(this.fwd.x, this.fwd.y);
			rightProbe.rotate(45);
			if(this.position.x + rightProbe.x * 20 < 360)
			{
				trace("x1<360");
				return this.seek(_center); 
			}
			if(this.position.x + rightProbe.x * 20 > stage.stageWidth - 20)
			{
				trace("x1>780");
				return this.seek(_center); 
			}
			if(this.position.y + rightProbe.y * 20 < 20)
			{
				trace("y1<20");
				return this.seek(_center);
			}
			if(this.position.y + rightProbe.y * 20 > 230)
			{
				trace("y1>230");
				return this.seek(_center);
			}
			
			var leftProbe:Vector2 = new Vector2(this.fwd.x, this.fwd.y);
			leftProbe.rotate(-45);
			if(this.position.x + leftProbe.x * 20 < 360)
			{
				trace("x2<360");
				return this.seek(_center); 
			}
			if(this.position.x + leftProbe.x * 20 > stage.stageWidth - 20)
			{
				trace("x2>780");
				return this.seek(_center); 
			}
			if(this.position.y + leftProbe.y * 20 < 20)
			{
				trace("y2<20");
				return this.seek(_center);
			}
			if(this.position.y + leftProbe.y * 20 > 230)
			{
				trace("y2>230");
				return this.seek(_center);
			}
			
			//returnVector = this.seek(returnVector);
			
			return new Vector2();
		}
		
		// keep birds from going on top of each other
		private function separate() : Vector2
		{
			var tempVec:Vector2 = new Vector2();
			// get closest neighbor
			tempVec = _manager.nearestNeighbor(this, 10);
			tempVec = this.flee(tempVec);
			return tempVec;
		}

	}
}
