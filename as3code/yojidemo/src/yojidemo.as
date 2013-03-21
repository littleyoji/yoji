package
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.events.TweenEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display3D.IndexBuffer3D;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.system.System;
	import flash.system.TouchscreenType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mat.Grid;
	
	[SWF(width ="380",height="580",frameRate="30",backgroundColor ="0xffffff")]
	public class yojidemo extends Sprite
	{
		private var _game:frame;
		
		private var _grid:Grid;
		
		private var _player_1_hp:int = 150;
		private var _player_2_hp:int = 210;
		private var _player_1_max_hp:int = 150;
		private var _player_2_max_hp:int = 210;
		
		private var _player_1_skill_list:Array = [{skillId:1,skillLv:1},{skillId:2,skillLv:1},{skillId:3,skillLv:1},{skillId:4,skillLv:1},{skillId:5,skillLv:1}];
		private var _player_2_skill_list:Array = [{skillId:1,skillLv:1},{skillId:2,skillLv:1}];
		
		private var _player_1_atk:int = 10;
		private var _arr_wait_skills:Array;
		/**
		 * 敌人行动时间 
		 */		
		private var _player_2_action_limit:Number = 10;
		
		
		private var _skill_config:Dictionary;
		private const _config_skill:Array = 
			[
				{skillId:1,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1},
				{skillId:2,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1},
				{skillId:3,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1},
				{skillId:4,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1},
				{skillId:5,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1},
				{skillId:100,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1},
				{skillId:101,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1},
				
			];
		
		/**
		 * 连招等待时间 
		 */		
		private var _player_1_cob_limit:Number = 5;
		
		
		/**
		 * 角色1连招当前时间 
		 */		
		private var _player_1_cob_now:Number = 0;
		/**
		 * 连招消除增益 
		 */		
		private var _player_1_cob_buffer:Number = 0.4;
		
		/**
		 * 监测时间片 
		 */		
		private var _player_1_cob_cost:Number = 0.1;
		private var _now_1:int = 0;
		private var _now_2:int = 0;
		private var _now_3:int = 0;
		private var _now_4:int = 0;
		private var _now_5:int = 0;
		private var _cube_1_max:int = 10;
		private var _cube_2_max:int = 10;
		private var _cube_3_max:int = 10;
		private var _cube_4_max:int = 10;
		private var _cube_5_max:int = 10;
		
		private var _in_skill_ready:Boolean = false;
		
		private var _power:Number = 1;
		
		private var _powerScale:Number = 0.01;
		
		
		private var _player_1_cob_timer:Timer;
		public function yojidemo()
		{
			if(stage)
			{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}else
			{
				init();
			}
		}
		
		/**
		 *　 
		 * @param e
		 * 
		 */
		public function init(e:Event=null):void
		{
			_game = new frame();
			this.addChild(_game);
			_player_1_cob_timer = new Timer(1000*_player_1_cob_cost,0);
			import com.greensock.layout.*;
			stage.align = StageAlign.BOTTOM;
			_game.mc_actor_1.gotoAndPlay('act_1');
			_game.mc_actor_2.gotoAndPlay('act_1');
			
			_game.txt_hp_1.autoSize = TextFieldAutoSize.LEFT;
			_game.txt_hp_2.autoSize = TextFieldAutoSize.RIGHT;
			_game.txt_cube1.autoSize = TextFieldAutoSize.CENTER;
			_game.txt_cube2.autoSize = TextFieldAutoSize.CENTER;
			_game.txt_cube3.autoSize = TextFieldAutoSize.CENTER;
			_game.txt_cube4.autoSize = TextFieldAutoSize.CENTER;
			_game.txt_cube5.autoSize = TextFieldAutoSize.CENTER;
			
			_game.txt_power.visible =false;
			_game.mc_cob_bar.visible = false;
			//装载游戏数据
			_player_1_max_hp = _player_1_max_hp;
			_player_2_max_hp = _player_2_max_hp;
			player_1_hp = _player_1_hp;
			player_2_hp = _player_2_hp;
			cube_1_value = 0;
			cube_2_value = 0;
			cube_3_value = 0;
			cube_4_value = 0;
			cube_5_value = 0;
			_grid = new Grid(_game.mc_canvas,this);
			_grid.set_size(5,5);
			_grid.createMap();
			_arr_wait_skills = [];
			trace(Multitouch.supportsTouchEvents);
			trace(Multitouch.supportsGestureEvents);
			flash.ui.Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		}
		/**
		 * 设置玩家1的生命值 
		 * @param value
		 * 
		 */		
		public function set player_1_hp(value:int):void
		{
			_player_1_hp = value;
			var toWidth:Number = _player_1_hp/_player_1_max_hp * 112;
			
			TweenLite.to(_game.mc_bar_1,0.4,{'width':toWidth});

			_game.txt_hp_1.text = _player_1_hp + "/" +_player_1_max_hp;
		}
		/**
		 *  
		 * @param value
		 * 
		 */		
		public function set player_1_maxhp(value:int):void
		{
			_player_1_max_hp = value;
			var toWidth:Number = _player_1_hp/_player_1_max_hp * 112;
			TweenLite.to(_game.mc_bar_1,0.4,{'width':toWidth});
			_game.txt_hp_1.text = _player_1_hp + "/" +_player_1_max_hp;
		}
		
		/**
		 * 设置玩家2的生命值 
		 * @param value
		 * 
		 */		
		public function set player_2_hp(value:int):void
		{
			_player_2_hp = value;
			var toWidth:Number = _player_2_hp/_player_2_max_hp * 112;
			TweenLite.to(_game.mc_bar_2,0.4,{'width':toWidth});
			_game.txt_hp_2.text = _player_2_hp + "/" +_player_2_max_hp;
		}
		
		public function set player_2_maxhp(value:int):void
		{
			_player_2_max_hp = value;
			var toWidth:Number = _player_2_hp/_player_2_max_hp * 112;
			TweenLite.to(_game.mc_bar_1,0.4,{'width':toWidth});
			_game.txt_hp_1.text = _player_2_hp + "/" +_player_2_max_hp;
		}
		
		public function set cube_1_value(value:int):void
		{
			_now_1 = value;
			_game.txt_cube1.text = _now_1+'/'+_cube_1_max;
		}
		public function set cube_2_value(value:int):void
		{
			_now_2 = value;
			_game.txt_cube2.text = _now_2+'/'+_cube_2_max;
		}
		public function set cube_3_value(value:int):void
		{
			_now_3 = value;
			_game.txt_cube3.text = _now_3+'/'+_cube_3_max;

		}
		public function set cube_4_value(value:int):void
		{
			_now_4 = value;
			_game.txt_cube4.text = _now_4+'/'+_cube_4_max;

		}
		public function set cube_5_value(value:int):void
		{
			_now_5 = value;
			_game.txt_cube5.text = _now_5+'/'+_cube_5_max;

		}
		
		/**
		 * 消除结束后进入技能预备阶段
		 * 
		 */		
		public function activeSkill():Boolean
		{
			//TODO: 检查宝石数量，是否超过10,若已超过进入蓄力模式
			if(_in_skill_ready)
			{
				return _in_skill_ready;
			}
			for(var i:int=1;i<6;i++)
			{
				if(this['_now_'+i]>this['_cube_'+i+'_max'])
				{
					_arr_wait_skills.push(i);
					_in_skill_ready = true;
				}
			}
			if(_in_skill_ready)
			{
				_game.mc_actor_1.gotoAndPlay('act_2');
				_game.txt_power.visible = true;
				
				_game.mc_cob_bar.scaleX = 1;
				_game.mc_cob_bar.visible =true;
				_player_1_cob_now = 0;
				_player_1_cob_timer.addEventListener(TimerEvent.TIMER,addPowerPerTimer);
				_player_1_cob_timer.start();
			}
			return _in_skill_ready;
		}
		
		/**
		 * 释放技能 
		 * 
		 */		
		private function castSkill():void
		{
			//TODO: 继续增加内容
			_in_skill_ready = false;
			
			//TODO: 处理技能释放计算伤害
			var damage:Array = [];
			for(var i:int=0;i<_arr_wait_skills.length;i++)
			{
				var cost:int = this['_now_'+_arr_wait_skills[i]];
				var now_damage:Number = _power*(cost/this['_cube_'+_arr_wait_skills[i]+'_max']*_player_1_atk);
				this['cube_'+_arr_wait_skills[i]+'_value'] = 0;
				now_damage = Math.ceil(now_damage);
				damage.push(now_damage);
			}
			damagePlayer2(damage);
			_power = 1;
			_game.txt_power.visible =false;
			
			_game.mc_actor_1.gotoAndPlay('act_3');
		}
		
		private function damagePlayer2(arr:Array):void
		{
			var total:int = 0;
			var timeline:TimelineLite = new TimelineLite();
			for(var i:int = 0;i<arr.length;i++)
			{
				total += arr[i];
			}
			player_2_hp = _player_2_hp- total;
		}
		/**
		 * 蓄力模式下积累技能条 
		 * @param value
		 * 
		 */		
		private function addPower(value:int):void
		{
			_power +=value*_powerScale;
			_game.txt_power.text = Math.ceil(_power*100)+'%Power!!';
			_player_1_cob_now -= _player_1_cob_buffer;
			_game.mc_cob_bar.scaleX = (_player_1_cob_limit-_player_1_cob_now)/_player_1_cob_limit;
		}
		
		/**
		 * 蓄力状态下时间片操作 
		 * @param e
		 * 
		 */		
		private function addPowerPerTimer(e:TimerEvent):void
		{
			if(_player_1_cob_now >_player_1_cob_limit)
			{
				//释放技能，并中止
				_player_1_cob_timer.removeEventListener(TimerEvent.TIMER,addPowerPerTimer);
				_player_1_cob_timer.stop();
				_player_1_cob_timer.reset();
				_game.mc_cob_bar.visible = false;
				castSkill();
				return;
			}else
			{
				_player_1_cob_now+= _player_1_cob_cost;
				TweenLite.to(_game.mc_cob_bar,_player_1_cob_cost,{
					scaleX:(_player_1_cob_limit-_player_1_cob_now)/_player_1_cob_limit
				});
			}
		}
		/**
		 * 获得了多少颗什么宝石 
		 * 
		 */
		public function awardBijou(index:int,value:int):void
		{
			if(_in_skill_ready)
			{
				addPower(value);
			}else
			{
				this['cube_'+index+'_value'] = this['_now_'+index] + value;
			}
		}
	}
}