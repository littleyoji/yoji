package mat
{
	import flash.utils.Dictionary;

	public class SkillManager
	{
		private var _dic_skills:Dictionary;
		
		private const _config_skill:Array = 
			[
				{skillId:1,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1},
				{skillId:2,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1},
				{skillId:3,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1},
				{skillId:4,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1},
				{skillId:5,atkEffect:100,defEffect:100,atkBuffer:1.5,defBuffer:1},
			];
		
		public function SkillManager()
		{
		}
		
		/**
		 * 释放技能以及技能监听 
		 * @param player 發動者
		 * @param target 被擊者
		 * @param arr_skill
		 * 
		 */		
		public static function showSkill(player:Role,target:Role,arr_skill:Array):void
		{
			
		}
	}
}