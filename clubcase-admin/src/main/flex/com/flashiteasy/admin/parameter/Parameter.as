package com.flashiteasy.admin.parameter
{
	public class Parameter
	{
		private var _type : String;
		private var _row : Number;
		private var _sequence : Number;
		private var _label : String;
        private var _labelField : String;
		private var _defaultValue : *;
		private var _min : String;
		private var _max : String;
		private var _interval:String;
		
		public var _name : String;
		

		public function Parameter( row:Number, sequence : Number, type : String, name : String, label : String,
		                          defaultValue : * = null, min : String = null, max : String = null,
		                          interval : String = null, labelField : String = null )
		{
			super();
			this._row = row;
			this._sequence = sequence;
			this._type = type;
			this._label = label;
			this._labelField = labelField;
			this._name = name;
			this._defaultValue = defaultValue;
			this._min = min;
			this._max = max;
			this._interval = interval;
		}
		public function get row() : Number
		{
			 return _row
		}


		public function get sequence() : Number
		{
			 return _sequence;
		}

		public function getType() : String
		{
			 return _type;
		}
		public function setType( value : String  ) : void
		{
			_type = value;
		}
		public function getLabel() : String
		{
			 return _label;
		}
		public function setLabel( value : String ) : void
		{
			_label = value;
		}
		
		public function getName() : String
		{
			 return _name;
		}
		public function setName( value : String ) : void
		{
			_name = value;
		}
		
		public function getDefaultValue() : *
		{
			 return _defaultValue;
		}
		public function setDefaultValue( value : * ) : void
		{
			_defaultValue = value;
		}
		
        public function getLabelField() : String
        {
            return _labelField;
        }
        
        public function setLabelField( value : String ) : void
        {
            _labelField = value;
        }
		
		public function getMin() : String
		{
			 return _min;
		}
		public function setMin( value : String ) : void
		{
			_min = value;
		}
		
		public function getMax() : String
		{
			 return _max;
		}
		public function setMax( value : String ) : void
		{
			_max = value;
		}
		
		public function getInterval() : String
		{
			 return _interval;
		}
		public function setInterval( value : String ) : void
		{
			_interval = value;
		}
	}
}