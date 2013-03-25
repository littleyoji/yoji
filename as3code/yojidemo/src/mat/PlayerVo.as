package mat
{
	import com.greensock.TweenLite;
	
	import flash.text.TextField;

	public class PlayerVo
	{
		/**
		 * 生命值 
		 */		
		public var hp:int;
		
		/**
		 * 最大生命值 
		 */		
		public var max_hp:int;
		
		/**
		 * 技能列表 
		 */		
		public var skill_list:Vector.<SkillVo>;
		
		/**
		 * 攻擊力 
		 */		
		public var atk:int;
		
		/**
		 * 防禦力 
		 */		
		public var def:int;
		
		/**
		 * 該npc行動等待時閒，單位秒 
		 */		
		public var action_wait:Number;
		
		/**
		 * 畜氣基礎時間 ，單位秒
		 */		
		public var cob_base_limit:Number;
		
		/**
		 * 當前時間 
		 */		
		public var cob_now_time:Number;
		
		/**
		 * 畜氣階段消除增益 
		 */		
		public var cob_effect:Number;
		
		/**
		 * 蓄力前基礎力量 
		 */		
		public var power:Number = 1;
		
		/**
		 * 蓄力產生效果 
		 */		
		public var powerScale:Number = 0.01;
		
		/**
		 * 对象角色
		 */		
		private var _view:Role;
		
		/**
		 * 血条 
		 */		
		private var _hp_bar:bloodbar;
		
		/**
		 * 血量文本 
		 */		
		private var _hp_text:TextField;
		
		
		private const _hp_bar_width:Number = 112;
		public function showAction(act:String):void
		{
			if(_view!=null)
			{
				_view.gotoAndPlay(act);
			}
		}
		
		/**
		 * 顯示傷害，並修改當前hp 負值為傷害，正值為回復
		 * @param arr
		 * 
		 */		
		public function showDamage(arr:Array):void
		{
			
		}
		
		public function set player_hp(value:int):void
		{
			hp = value;
			var toWidth:Number = hp/max_hp * _hp_bar_width;
			TweenLite.to(_hp_bar,0.4,{'width':toWidth});
			_hp_text.text = hp + "/" + max_hp;
		}
		public function set player_maxhp(value:int):void
		{
			max_hp = value;
			var toWidth:Number = hp/max_hp * _hp_bar_width;
			TweenLite.to(_hp_bar,0.4,{'width':toWidth});
			_hp_text.text = hp + "/" + max_hp;
		}
		/**
		 * 构造方法 
		 * @param data
		 * @param actor
		 * @param txt
		 * 
		 */		
		public function PlayerVo(data:Object,actor:Role,hpbar:bloodbar,txt:TextField)
		{
			hp = data.hp;
			max_hp = data.max_hp;
			atk = data.atk;
			def = data.def;
			action_wait = data.action_wait;
			cob_base_limit = data.cob_base_limit;
			cob_effect = data.cob_effect;
			cob_now_time = 0;
			power = data.power;
			powerScale = data.powerScale;
			
			_view = actor;
			_hp_bar = hpbar;
			_hp_text = txt;
		}
	}
}