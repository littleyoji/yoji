package mat
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class SkillManager
	{
		private var _dic_skills:Dictionary;
		
		private var _player:PlayerVo;
		private var _target:PlayerVo;
		
		private var _skill:SkillVo;
		
		/**
		 * 伤害列表 
		 */		
		private var _arr_damage:Array;
		
		/**
		 * 技能响应回调 
		 */		
		private var _call_back:Function;
		private static var _this:SkillManager;
		private const _config_skill:Array = 
			[
				{id:1,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1,name:'震天'},
				{id:2,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1,name:'百万雄蜂'},
				{id:3,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1,name:'Power Wave'},
				{id:4,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1,name:'灰霭'},
				{id:5,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1,name:'Power'},
			];
		
		public function SkillManager()
		{
			_dic_skills = new Dictionary();
			for each(var obj:Object in _config_skill)
			{
				var skillVo:SkillVo = new SkillVo(obj);
				_dic_skills[skillVo.id] = skillVo;
			}
		}
		
		public static function get instanse():SkillManager
		{
			if(_this==null)
			{
				_this = new SkillManager();
			}
			return _this;
		}
		public function getSkillById(id:String):SkillVo
		{
			return _dic_skills[id];
		}
		/**
		 * 释放技能以及技能监听 
		 * @param player 發動者
		 * @param target 被擊者
		 * @param arr_skill
		 * 
		 */		
		public function showSkill(player:PlayerVo,target:PlayerVo,arr_skill:Array,callback:Function):void
		{
			var max:int = 0;
			var cost:Number = 0;
			var show:SkillVo = null;
			_arr_damage = [];
			_player = player;
			_target = target;
			_call_back = callback;
			for(var i:int = 0;i<arr_skill.length;i++)
			{
				cost = arr_skill[i].cost;
				if(cost>max)
				{
					max = cost;
					show = arr_skill[i].skill;
				}
				_arr_damage.push(Math.ceil(cost*_player.atk));
				//计算伤害并将伤害加入伤害列表
			}
			_skill = show;
			player.showAction('skill_'+show.id);
			player.view.addEventListener(Event.ENTER_FRAME,waitDamageHandler);
		}
		
		/**
		 * 等待造成伤害 
		 * @param e
		 * 
		 */		
		private function waitDamageHandler(e:Event):void
		{
			if(_player.view.currentFrameLabel == "skill_"+_skill.id+"_damage")
			{
				_player.view.removeEventListener(Event.ENTER_FRAME,waitDamageHandler);
				_player.view.addEventListener(Event.ENTER_FRAME,waitDamageEndHandler);
				_target.showAction("damage");
			}
		}
		
		/**
		 * 等待技能伤害完毕 
		 * @param e
		 * 
		 */		
		private function waitDamageEndHandler(e:Event):void
		{
			if(_player.view.currentFrameLabel == "skill_"+_skill.id+"_damage_end")
			{
				_player.view.removeEventListener(Event.ENTER_FRAME,waitDamageEndHandler);
				_player.view.addEventListener(Event.ENTER_FRAME,skillEndHandler);
				_target.showDamage(_arr_damage);
			}
		}
		
		/**
		 * 技能结束 
		 * @param e
		 * 
		 */		
		private function skillEndHandler(e:Event):void
		{
			if(_call_back!=null)
			{
				_call_back();
			}
			_player.view.removeEventListener(Event.ENTER_FRAME,skillEndHandler);
		}
	}
}