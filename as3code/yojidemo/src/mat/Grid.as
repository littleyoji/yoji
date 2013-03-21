package mat
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class Grid
	{
		private var _game:yojidemo;
		private var _mc_canvas:gridview;
		
		private var _col_max:int = 6;
		
		private var _row_max:int = 6;
		
		private var _move_max:int =1;
		
		/**
		 * 消除所使用的地图 
		 */		
		private var _map_cube:Array;
		private var _random_key:int = 0;
		
		private var _move_able:int =0;
		
		private var _clear_timer:Timer;
		private var _update_timer:Timer;
		/**
		 * 该次移动的被改变位置的所有宝石以及其对应的起点 ，
		 * 
		 * 
		 * 'cube':CubeVo,该cube
		 * 'col':int,所在列
		 * 'row':int,所在行
		 */		
		private var _arr_line_list:Array;
		
		
		/**
		 * 将要被消除的所有宝石，由check生成，由clear方法销毁并计数 
		 */		
		private var _arr_clear_list:Array;
		
		/**
		 * 消除字典，用于存储消除的队列，以消除对象为索引 
		 */		
		private var _dic_clear_cube:Dictionary;
		
		private var _update_over:Boolean = false;
		/**
		 * 该容器宽度 
		 */		
		private const _width:Number = 344;
		/**
		 * 该容器高度 
		 */		
		private const _height:Number = 344;
		
		private var _clear_num:int = 3;
		private var _selected_cube:CubeVo;
		private var _target_cube:CubeVo;
		/**
		 * 游戏中出现的宝石 
		 */		
		private var _bijou_used:Array = [1,2,3,4];
		public function Grid(mc_canvas:gridview,game:yojidemo)
		{
			this._mc_canvas = mc_canvas;
			
			_game = game;
			_clear_timer = new Timer(400,1);
			_clear_timer.addEventListener(TimerEvent.TIMER_COMPLETE,clearOverHandler);
			_update_timer = new Timer(300,1);
			_update_timer.addEventListener(TimerEvent.TIMER_COMPLETE,updateOverHandler);
			
		}
		
		public function get row_max():int
		{
			return _row_max;
		}
		
		public function get col_max():int
		{
			return _col_max;
		}
		
		private function downHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			var current:Sprite = e.currentTarget as Sprite;
			var target:Point = new Point(current.mouseX,current.mouseY);
			var col:int = Math.ceil(target.x/CubeVo.cube_size)-1;
			var row:int = Math.ceil(target.y/CubeVo.cube_size)-1;
			if(col>=0&&col<_col_max&&row>=0&&row<_row_max)
			{	
				_selected_cube = _map_cube[col][row];
				_target_cube = null;
				_move_able = _move_max;
				_arr_line_list = [{'cube':_selected_cube,'col':_selected_cube.col,'row':_selected_cube.row}];
			}
		}
		
		private function moveHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			if(_selected_cube!=null&&_move_able!=0)
			{
				var current:Sprite = e.currentTarget as Sprite;
				var target:Point = new Point(current.mouseX,current.mouseY);
				var col:int = Math.ceil(target.x/CubeVo.cube_size)-1;
				var row:int = Math.ceil(target.y/CubeVo.cube_size)-1;
				if(col>=0&&col<_col_max&&row>=0&&row<_row_max)
				{
					//_target_cube = _arr_bijou[col][row];
					//TODO:新算法，根据移动距离计算出四方向并计算两者交换
					var moveX:int = col-_selected_cube.col;
					var moveY:int = row-_selected_cube.row;
					if(moveX!=0||moveY!=0)
					{
						if(moveX<=moveY&&moveX>=-moveY)
						{
							//处理向右
							_target_cube = _map_cube[_selected_cube.col][_selected_cube.row+1];
						}else if(moveX<=moveY&&moveX<-moveY)
						{
							//处理向左运动
							_target_cube = _map_cube[_selected_cube.col-1][_selected_cube.row];
						}else if(moveX>moveY&&moveX>=-moveY)
						{
							//处理向右
							_target_cube = _map_cube[_selected_cube.col+1][_selected_cube.row];
						}else if(moveX>moveY&&moveX<-moveY)
						{
							//处理向上
							_target_cube = _map_cube[_selected_cube.col][_selected_cube.row-1];
							
						}else
						{
							trace("noresult");
						}
					}else
					{
						_target_cube = null;
						return;
					}
				}	
				else
				{	
					_target_cube = null;
					return;
				}
				if(_target_cube!=null&&_target_cube!=_selected_cube)
				{
					//确认发生移动，并将移动者加入复原队列
					_move_able--;
					if()
					_arr_line_list.push({'cube':_target_cube,'col':_target_cube.col,'row':_target_cube.row});
					changePosition(_selected_cube,_target_cube);
				}
			}
		}
		
		private function upHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			
			if(checkDelete())
			{
				clear();
			}else
			{
				returnOrigin();
			}
		}
		
		
		
		private function startTouchHandler(e:TouchEvent):void
		{
			e.stopPropagation();
			var current:Sprite = e.currentTarget as Sprite;
			var target:Point = new Point(current.mouseX,current.mouseY);
			var col:int = Math.ceil(target.x/CubeVo.cube_size)-1;
			var row:int = Math.ceil(target.y/CubeVo.cube_size)-1;
			if(col>=0&&col<_col_max&&row>=0&&row<_row_max)
			{	
				_selected_cube = _map_cube[col][row];
				_target_cube = null;
				_move_able = _move_max;
				_arr_line_list = [{'cube':_selected_cube,'col':_selected_cube.col,'row':_selected_cube.row}];
			}
		}
		
		private function moveTouchHandler(e:TouchEvent):void
		{
			e.stopPropagation();
			if(_selected_cube!=null&&_move_able!=0)
			{
				var current:Sprite = e.currentTarget as Sprite;
				var target:Point = new Point(current.mouseX,current.mouseY);
				var col:int = Math.ceil(target.x/CubeVo.cube_size)-1;
				var row:int = Math.ceil(target.y/CubeVo.cube_size)-1;
				if(col>=0&&col<_col_max&&row>=0&&row<_row_max)
				{
					//_target_cube = _arr_bijou[col][row];
					//TODO:新算法，根据移动距离计算出四方向并计算两者交换
					var moveX:int = col-_selected_cube.col;
					var moveY:int = row-_selected_cube.row;
					if(moveX!=0||moveY!=0)
					{
						if(moveX<=moveY&&moveX>=-moveY)
						{
							//处理向右
							_target_cube = _map_cube[_selected_cube.col][_selected_cube.row+1];
						}else if(moveX<=moveY&&moveX<-moveY)
						{
							//处理向左运动
							_target_cube = _map_cube[_selected_cube.col-1][_selected_cube.row];
						}else if(moveX>moveY&&moveX>=-moveY)
						{
							//处理向右
							_target_cube = _map_cube[_selected_cube.col+1][_selected_cube.row];
						}else if(moveX>moveY&&moveX<-moveY)
						{
							//处理向上
							_target_cube = _map_cube[_selected_cube.col][_selected_cube.row-1];
							
						}else
						{
						}
					}else
					{
						_target_cube = null;
						return;
					}
				}	
				else
				{	
					_target_cube = null;
					return;
				}
				if(_target_cube!=null&&_target_cube!=_selected_cube)
				{
					//确认发生移动，并将移动者加入复原队列
					if(_target_cube.intween)
					{
						return;
					}
					_move_able--;
					_arr_line_list.push({'cube':_target_cube,'col':_target_cube.col,'row':_target_cube.row});
					changePosition(_selected_cube,_target_cube);
				}
			}
		}
		
		private function upTouchHandler(e:TouchEvent):void
		{
			e.stopPropagation();
			
			if(checkDelete())
			{
				clear();
			}else
			{
				returnOrigin();
			}
		}
		
		/**
		 * 回滚操作 
		 * 
		 */		
		private function returnOrigin():void
		{
			for(var i:int =_arr_line_list.length-1;i>=0;i--)
			{
				var cube:CubeVo = _arr_line_list[i].cube;
				var col:int = _arr_line_list[i].col;
				var row:int = _arr_line_list[i].row;
				moveCube(cube,col,row);
			}
		}
		/**
		 * 检查消除方法，是否为移动消除 
		 * @return 
		 * 
		 */		
		public function checkDelete():Boolean
		{
			_arr_clear_list = [];		//初始化一个新的消除队列
			_dic_clear_cube = new Dictionary(); //初始化一个新的 消除关系字典
			var sameValue:int = 0;		//默认初始化不存在的宝石值
			var arr_temp:Array;
			for(var col:int = 0;col<_col_max;col++)
			{
				arr_temp = [];
				for(var row:int = 0;row<_row_max;row++)
				{
					//检查列是否存在消除，并把对应消除存入列表与消除字典
					var cube:CubeVo = _map_cube[col][row];
					if(sameValue == cube.value)
					{
						arr_temp.push(cube);
					}else
					{
						if(arr_temp.length>=_clear_num)
						{
							_arr_clear_list.push(arr_temp);
							for each(var obj:CubeVo in arr_temp)
							{
								_dic_clear_cube[obj] = arr_temp;
							}
						}
						sameValue = cube.value;
						arr_temp = [cube];
					}	
				}
				//一列循环结束,检测是否有满足
				if(arr_temp.length>=3)
				{	
					_arr_clear_list.push(arr_temp);
					for each(obj in arr_temp)
					{
						_dic_clear_cube[obj] = arr_temp;
					}
				}
			}
			sameValue = 0;
			for(row = 0;row<_row_max;row++)
			{
				arr_temp = [];
				for(col = 0;col<_col_max;col++)
				{
					//检查列是否存在消除，并把对应消除存入列表与消除字典
					cube = _map_cube[col][row];
					if(sameValue == cube.value)
					{
						arr_temp.push(cube);
					}else
					{
						if(arr_temp.length>=_clear_num)
						{
							//长度大于3,检查其中每一个元素
							var notIn:Boolean = true;
							for each(obj in arr_temp)
							{
								if(_dic_clear_cube[obj]!=null)
								{
									var arr_dic:Array = _dic_clear_cube[obj];
									for each(var tempobj:CubeVo in arr_temp)
									{
										if(obj!=tempobj)
											arr_dic.push(tempobj);
									}
									arr_temp = arr_dic;
									notIn = false;
								}
							}
							for each(obj in arr_temp)
							{
								_dic_clear_cube[obj] = arr_temp;
							}
							if(notIn)
							{
								_arr_clear_list.push(arr_temp);	
							}
						}
						sameValue = cube.value;
						arr_temp = [cube];
					}	
				}
				//一列循环结束,检测是否有满足
				if(arr_temp.length>=_clear_num)
				{	
					if(arr_temp.length>=_clear_num)
					{
						//长度大于3,检查其中每一个元素
						notIn = true;
						for each(obj in arr_temp)
						{
							if(_dic_clear_cube[obj]!=null)
							{
								arr_dic = _dic_clear_cube[obj];
								for each(tempobj in arr_temp)
								{
									if(obj!=tempobj)
										arr_dic.push(tempobj);
								}
								arr_temp = arr_dic;
								notIn = false;
							}
						}
						for each(obj in arr_temp)
						{
							_dic_clear_cube[obj] = arr_temp;
						}
						if(notIn)
						{
							_arr_clear_list.push(arr_temp);	
						}
					}
				}
			}
			if(_arr_clear_list.length!=0)
			{
				return true;
			}else
			{
				return false;
			}
		}
		
		public function createMap():void
		{
			while(_mc_canvas.numChildren)
			{
				_mc_canvas.removeChildAt(0);
			}
			_map_cube = new Array();
			//TODO:根据随机数产生 对应的 宝石并下落
			for(var i:int= 0;i<_col_max;i++)
			{
				_map_cube.push(new Array());
				for(var j:int = 0;j<_row_max;j++)
				{
					var index:int = Math.floor((Math.random()*_bijou_used.length));
					var cube:CubeVo = new CubeVo(_bijou_used[index]);
					setPosition(i,j,cube);
				}
			}
			
			workAbleScene(true);
		}
		
		public function updateAllCube():void
		{
			for(var col:int=0;col<_col_max;col++)
			{
				for(var row:int = _row_max-1;row>=0;row--)
				{
					if(_map_cube[col][row]==null)
					{
						var needcreate:Boolean = true;
						for(var i:int = row;i>=0;i--)
						{
							
							if(_map_cube[col][i]!=null)
							{
								//发生一次剪切式位移
								moveCube(_map_cube[col][i],col,row);
								_map_cube[col][i] = null;
								needcreate = false;
								break;
							}
						}
						if(needcreate)
						{
							var index:int = Math.floor((Math.random()*_bijou_used.length));
							var cube:CubeVo = new CubeVo(_bijou_used[index]);
							//setPosition(i,j,cube);
							setPosition(col,-1,cube);
							moveCube(cube,col,row);
						}
					}
				}
			}
			_update_timer.reset();
			_update_timer.start();
		}
		/**
		 * 基本操作跟随的
		 * 更换位置 但不产生消除
		 * @param cube
		 * @param toCube
		 * 
		 */		
		private function changePosition(cube:CubeVo,toCube:CubeVo):void
		{
			var toRow:int = toCube.row;
			var toCol:int = toCube.col;
			var col:int = cube.col;
			var row:int = cube.row;
			
			moveCube(cube,toCol,toRow);
			
			moveCube(toCube,col,row);
		}
		
		/**
		 * 携带动画的setposition 
		 * @param cube
		 * @param toCol
		 * @param toRow
		 * 
		 */		
		private function moveCube(cube:CubeVo,toCol:int,toRow:int):void
		{
			_map_cube[toCol][toRow] = cube;
			if(cube!=null)
			{
				cube.intween = true;
				cube.position(toCol,toRow);
				TweenLite.to(cube,0.3,{
					x:toCol*CubeVo.cube_size,
					y:toRow*CubeVo.cube_size
				});
			}
		}
		/**
		 * 只用于初始化 
		 * @param col
		 * @param row
		 * @param cube
		 * 
		 */		
		private function setPosition(col:int,row:int,cube:CubeVo):void{
			if(row==-1)
			{
				//初始化新生成的宝石,需要紧接执行move方法来初始化该宝石的位置
				cube.x = col*CubeVo.cube_size;
				cube.y = row*CubeVo.cube_size;
				_mc_canvas.addChild(cube);
				return;
			}
			_map_cube[col][row] = cube;
			if(cube!=null)
			{
				cube.position(col,row);
				cube.x = col*CubeVo.cube_size;
				cube.y = row*CubeVo.cube_size;
				_mc_canvas.addChild(cube);
			}
		}
		public function set_size(col:int,row:int):void
		{
			_row_max = row;
			_col_max = col;
			_mc_canvas.scaleX = _width/_col_max/CubeVo.cube_size;
			_mc_canvas.scaleY = _height/_row_max/CubeVo.cube_size;
		}
		
		/**
		 * 计算消除以及消除处理 
		 * 
		 */		
		private function clear():void
		{
			workAbleScene(false);
			//TODO:应采取锁屏策略，并通知场景开始消除
			for(var i:int = 0;i<_arr_clear_list.length;i++)
			{
				var arr:Array = _arr_clear_list[i];
				var value:int = arr[0].value;
				var num:int = arr.length;
				_game.awardBijou(value,num);
				for(var j:int =0;j<arr.length;j++)
				{
					var cube:CubeVo = arr[j];
					_map_cube[cube.col][cube.row] = null;
					cube.dispose();
				}
			}
			_arr_clear_list = null;
			_dic_clear_cube = null;
			_selected_cube = null;
			_target_cube = null;
			_arr_clear_list = null;
			//TODO: 等待消除完成，开始生成新的宝石
			_clear_timer.reset();
			_clear_timer.start();
			_update_over = false;
		}
		
		/**
		 * 消除时间结束 
		 * @param e
		 * 
		 */		
		private function clearOverHandler(e:TimerEvent):void
		{
			e.stopPropagation();
			updateAllCube();
		}
		
		/**
		 * 等待更新结束 
		 * @param e
		 * 
		 */		
		private function updateOverHandler(e:TimerEvent):void
		{
			e.stopPropagation();
			if(checkDelete())
			{
				clear();
			}else
			{
				_update_over = true;
				if(_update_over)
				{
					workAbleScene(true);
				}
				_game.activeSkill();
			}
		}
		
		public function workAbleScene(enable:Boolean):void
		{
			if(enable)
			{
				if(Multitouch.supportsTouchEvents)
				{
					_mc_canvas.addEventListener(TouchEvent.TOUCH_BEGIN,startTouchHandler);
					_mc_canvas.addEventListener(TouchEvent.TOUCH_MOVE,moveTouchHandler);
					_mc_canvas.addEventListener(TouchEvent.TOUCH_END,upTouchHandler);
				}else
				{
					_mc_canvas.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
					_mc_canvas.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
					_mc_canvas.addEventListener(MouseEvent.MOUSE_UP,upHandler);
				}
			}else
			{
				if(Multitouch.supportsTouchEvents)
				{
				_mc_canvas.removeEventListener(TouchEvent.TOUCH_BEGIN,startTouchHandler);
				_mc_canvas.removeEventListener(TouchEvent.TOUCH_MOVE,moveTouchHandler);
				_mc_canvas.removeEventListener(TouchEvent.TOUCH_END,upTouchHandler);
				}else
				{
				_mc_canvas.removeEventListener(MouseEvent.MOUSE_DOWN,downHandler);
				_mc_canvas.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
				_mc_canvas.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
				}
			}
		}
	}
}