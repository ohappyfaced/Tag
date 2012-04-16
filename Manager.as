package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.*;
	import fl.events.SliderEvent;
	import fl.controls.Slider;

	// The  manager  serves as a document class
	// for our this world

	public class Manager extends MovieClip
	{
		private var _turtleArray:Array;
		private var _lastTime:Number;
		private var _curTime:Number;
		private var _dt:Number;
		private var _howMany:Number = 12;
		private var _numObs:Number = 10;
		private var _numFollow:Number = 7;
		private var _obsArray:Array;
		private var _folArray:Array;

		public function Manager( )
		{
			_turtleArray = new Array( );
			_obsArray = new Array();
			_folArray = new Array();
			//event listener for to drive frame loop
			addEventListener(Event.ENTER_FRAME, frameLoop);
			this.buildWorld( );
		}

		private function buildWorld( ):void
		{
			var temp:Wanderer;
			for (var i : int = 0; i < _howMany; i++)
			{
				temp = new Wanderer(this,600,50);
				//temp.turnLeft(i * 360/_howMany);
				temp.turnLeft(200);
				
				if(i == 0)
				{
					temp.gotoAndPlay(5);
					temp.isIt = true;
					temp.changeIt(temp);
				}
				else
				{
					temp.changeIt(_turtleArray[0]);
				}
				
				_turtleArray.push(temp);
			}
			_lastTime = getTimer();
			
			var tempFollow:Follower;
			for(var k:Number = 0; k < _numFollow; k++)
			{
				tempFollow = new Follower(this,200+k,500+k);
				_folArray.push(tempFollow);
				if(k == 0)
				{
					_folArray[k].followingTurtle = _folArray[k];
					_folArray[k].leader = true;
				}
				else
				{
					_folArray[k].followingTurtle = _folArray[k-1];
				}
			}
		}
		
		public function get obsArray() : Array
		{
			return _obsArray;
		}
		
		public function get folArray() : Array
		{
			return _folArray;
		}
		
		// get the sum of the fwd vectors of the turtles
		public function sumFwd( ) : Vector2
		{
			var tempVec:Vector2 = new Vector2();
			for(var i:Number = 0; i < _turtleArray.length; i++)
			{
				tempVec = tempVec.add(_turtleArray[i].fwd);
			}
			return tempVec;
		}
		
		public function avgPosition( ) : Vector2
		{
			var tempVec:Vector2 = new Vector2();
			for(var i:Number = 0; i < _turtleArray.length; i++)
			{
				tempVec = tempVec.add(_turtleArray[i].position);
			}
			tempVec = tempVec.divide(_howMany);
			return tempVec;
		}
		
		public function nearestNeighbor(turtle:SteeringVehicle, dist:Number) : Vector2
		{
			var tempVec:Vector2 = new Vector2();
			for(var i:Number = 0; i < _turtleArray.length; i++)
			{
				if(_turtleArray[i] != turtle)
				{
					if(_turtleArray[i].position.distance(turtle.position) < dist)
					{
						dist = _turtleArray[i].position.magnitude;
						tempVec = _turtleArray[i].position;
					}
				}
			}
			return tempVec;
		}

		//This frameloop sends an update message to each turtle in the turtleArray
		private function frameLoop(e: Event ):void
		{
			//manage dt: change in time
			_curTime = getTimer();
			_dt = (_curTime - _lastTime) / 1000;
			_lastTime = _curTime;

			//tell the sprites to do their update
			for (var i:Number = 0; i < _turtleArray.length; i++)
			{
				_turtleArray[i].update(_dt);
			}
			
			for(var j:Number = 0; j < _numFollow; j++)
			{
				_folArray[j].update(_dt);
				if(j == 0)
				{
					_folArray[j].followingTurtle = _folArray[j];
				}
				else
				{
					_folArray[j].followingTurtle = _folArray[j-1];
				}
			}
		}
	}
}