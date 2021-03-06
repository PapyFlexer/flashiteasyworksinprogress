package com.flashiteasy.admin.users
{
	/**
	 * 
	 * @author gillesroquefeuil
	 */
	public class User
	{
		
		private var _usrfirstname : String;
		private var _usrlastname : String;
		private var _usremail : String;
		private var _usrlogin : String;
		private var _usrpassword : String;
		private var _usradminlevel : Number;
		private var _usrlanguage : String;
		
		private var _allowedDomains : String;
		
		/**
		 * 
		 * @param firstname
		 * @param lastname
		 * @param email
		 * @param login
		 * @param password
		 * @param adminlevel
		 * @param language
		 */
		public function User(firstname : String, lastname : String, email : String, login : String, password : String, adminlevel : String, language : String)
		{
			_usrfirstname = firstname;
			_usrlastname = lastname;
			_usremail = email;
			_usrlogin = login;
			_usrpassword = password;
			_usradminlevel = getNumericAdminLevel(adminlevel);
			_usrlanguage = language;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get usrfirstname() :  String
		{
			return _usrfirstname;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set usrfirstname(value : String) : void
		{
			_usrfirstname = value;
		}

		/**
		 * 
		 * @return 
		 */
		public function get usrlastname() :  String
		{
			return _usrlastname;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set usrlastname(value : String) : void
		{
			_usrlastname = value;
		}

		/**
		 * 
		 * @return 
		 */
		public function get usrlogin() :  String
		{
			return _usrlogin;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set usrlogin(value : String) : void
		{
			_usrlogin = value;
		}

		/**
		 * 
		 * @return 
		 */
		public function get usremail() :  String
		{
			return _usremail;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set usremail(value : String) : void
		{
			_usremail = value;
		}

		/**
		 * 
		 * @return 
		 */
		public function get usrpassword() :  String
		{
			return _usrpassword;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set usrpassword(value : String) : void
		{
			_usrpassword = value;
		}

		/**
		 * 
		 * @return 
		 */
		public function get usradminlevel() :  uint
		{
			return _usradminlevel;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set usradminlevel(value : uint) : void
		{
			_usradminlevel = value;
		}
		
		
		/**
		 * 	
		 * @param adminLevel
		 * @return 
		 */
		public function getNumericAdminLevel(adminLevel : String) : uint
		{
			return AdminLevels.ADMIN_LEVELS.lastIndexOf(adminLevel);
		}
	}
}