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
	import mat.PlayerVo;
	import mat.SkillManager;
	
	[SWF(width ="380",height="580",frameRate="24",backgroundColor ="0xffffff")]
	public class yojidemo extends Sprite
	{
		private var _game:frame;
		
		private var _grid:Grid;
		
		private var _sound:battle;
		private var _player_1_data:Object = {
			'hp':150,
			'max_hp':150,
			'skill_list':[1,2,3,4,5],
			'atk':10,
			'def':12,
			'power':1,
			'action_wait':0,
			'cob_base_limit':5,
			'cob_effect':0.4,
			'powerScale':0.01
		};
		
		private var _player_2_data:Object = {
			'hp':570,
			'max_hp':570,
			'skill_list':[5],
			'atk':5,
			'def':18,
			'power':1,
			'action_wait':10,
			'cob_base_limit':5,
			'cob_effect':0.4,
			'powerScale':0.01
		};
		private var _player_1:PlayerVo;
		private var _player_2:PlayerVo;
		
		/**
		 * 檢測時間碎片，單位秒 
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
		
		/**
		 * 等待發動技能列表 
		 */		
		private var _arr_wait_skills:Array;
		private var _in_skill_ready:Boolean = false;
		
		private var _power:Number = 1;
		/**
		 * 蓄力倒計時計時器
		 */		
		private var _cob_timer:Timer;
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
			_cob_timer = new Timer(1000*_player_1_cob_cost,0);
			
			stage.align = StageAlign.BOTTOM;
			
			
			_game.txt_hp_1.autoSize = TextFieldAutoSize.LEFT;
			_game.txt_hp_2.autoSize = TextFieldAutoSize.RIGHT;
			_game.txt_cube1.autoSize = TextFieldAutoSize.CENTER;
			_game.txt_cube2.autoSize = TextFieldAutoSize.CENTER;
			_game.txt_cube3.autoSize = TextFieldAutoSize.CENTER;
			_game.txt_cube4.autoSize = TextFieldAutoSize.CENTER;
			_game.txt_cube5.autoSize = TextFieldAutoSize.CENTER;
			
			_game.txt_power.visible =false;
			_game.mc_cob_bar.visible = false;
			
			_sound = new battle();
			
			initData();
			
			_grid = new Grid(_game.mc_canvas,this);
			_grid.set_size(6,6);
			_grid.createMap();
			_arr_wait_skills = [];
			trace(Multitouch.supportsTouchEvents);
			trace(Multitouch.supportsGestureEvents);
			flash.ui.Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			_sound.play(0,int.MAX_VALUE);
		}
		
		private function initData():void
		{
			
			_player_1 = new PlayerVo(_player_1_data,_game.mc_actor_1,_game.mc_bar_1,_game.txt_hp_1);
			_player_2 = new PlayerVo(_player_2_data,_game.mc_actor_2,_game.mc_bar_2,_game.txt_hp_2);
			
			_player_1.showAction('stand');
			_player_2.showAction('stand');
			_player_1.player_maxhp = _player_1.max_hp;
			_player_2.player_maxhp = _player_2.max_hp;
			_player_1.player_hp = _player_1.hp;
			_player_2.player_hp = _player_2.hp;
			cube_1_value = 0;
			cube_2_value = 0;
			cube_3_value = 0;
			cube_4_value = 0;
			cube_5_value = 0;
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
		public function playerActiveSkill():Boolean
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
				_player_1.showAction('power');
				_game.txt_power.visible = true;
				
				_game.mc_cob_bar.scaleX = 1;
				_game.mc_cob_bar.visible =true;
				_player_1.cob_now_time = 0;
				_cob_timer.addEventListener(TimerEvent.TIMER,addPowerPerTimer);
				_cob_timer.start();
			}
			return _in_skill_ready;
		}
		
		/**
		 * 释放技能 
		 * 
		 */		
		private function castSkill(player:PlayerVo,target:PlayerVo):void
		{
			
			_in_skill_ready = false;
			
			//TODO: 处理技能释放计算伤害
			var arr_skills:Array = [];
			for(var i:int=0;i<_arr_wait_skills.length;i++)
			{
				var cost:int = this['_now_'+_arr_wait_skills[i]];
				var now_cost:Number = _power*(cost/this['_cube_'+_arr_wait_skills[i]+'_max']);
				this['cube_'+_arr_wait_skills[i]+'_value'] = 0;
				now_cost = Math.ceil(now_cost);
				arr_skills.push({'skill':_player_1.skill_list[_arr_wait_skills[i]-1],'cost':now_cost});
			}
			SkillManager.instanse.showSkill(_player_1,_player_2,arr_skills,skillCastCallBack);
			
			_power = _player_1.power;
			_game.txt_power.visible =false;
			_grid.lock(true);
		}
		/**
		 * 玩家技能播放完毕 
		 * 
		 */		
		private function skillCastCallBack():void
		{
			_grid.lock(false);
		}
		
//		private function damagePlayer2(arr:Array):void
//		{
//			var total:int = 0;
//			var timeline:TimelineLite = new TimelineLite();
//			for(var i:int = 0;i<arr.length;i++)
//			{
//				total += arr[i];
//			}
//			_player_2.player_hp = _player_2.hp- total;
//		}
		/**
		 * 蓄力模式下积累技能条 
		 * @param value
		 * 
		 */		
		private function addPower(value:int):void
		{
			_power +=value*_player_1.powerScale;
			_game.txt_power.text = Math.ceil(_power*100)+'%Power!!';
			_player_1.cob_now_time -= _player_1.cob_effect;
			_game.mc_cob_bar.scaleX = (_player_1.cob_base_limit-_player_1.cob_now_time)/_player_1.cob_base_limit;
		}
		
		/**
		 * 蓄力状态下时间片操作 
		 * @param e
		 * 
		 */		
		private function addPowerPerTimer(e:TimerEvent):void
		{
			if(_player_1.cob_now_time >_player_1.cob_base_limit)
			{
				//释放技能，并中止
				_cob_timer.removeEventListener(TimerEvent.TIMER,addPowerPerTimer);
				_cob_timer.stop();
				_cob_timer.reset();
				_game.mc_cob_bar.visible = false;
				castSkill(_player_1,_player_2);
				return;
			}else
			{
				_player_1.cob_now_time+= _player_1_cob_cost;
				TweenLite.to(_game.mc_cob_bar,_player_1_cob_cost,{
					scaleX:(_player_1.cob_base_limit-_player_1.cob_now_time)/_player_1.cob_base_limit
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