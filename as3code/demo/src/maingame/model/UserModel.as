package maingame.model
{
	import com.nbu.framework.model.BaseModel;
	import com.nbu.framework.utils.Singleton;
	
	import maingame.model.vo.UserVO;

	public class UserModel extends BaseModel
	{
		/**
		 * 用户信息 
		 */		
		private var _userInfo:UserVO;
		
		private var _current_sceneId:String;
		
		
		public function UserModel()
		{
		}
		
		public static function get instance():UserModel
		{
			return Singleton.getInstance(UserModel);
		}
		public function get current_sceneId():String
		{
			return _current_sceneId;
		}
		
		public function get userInfo():UserVO
		{
			return _userInfo;
		}
	}
}