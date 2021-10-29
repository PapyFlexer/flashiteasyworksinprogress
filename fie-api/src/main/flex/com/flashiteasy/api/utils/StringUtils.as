/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.utils
{
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;

	/**
	 * The <code><strong>StringUtils</strong></code> class is
	 * an utility class dealing with Strings
	 */
	public class StringUtils
	{
		
		/**
		 * 
		 * @default " \t\n\r"
		 */
		public static const WHITESPACE:String = " \t\n\r"; /**< Whitespace characters (space, tab, new line and return). */
		
		/**
		 * Concerts a string intio an array, passing a string and a delimiter.
		 * @param string
		 * @param delimiter
		 * @return 
		 */
		public static function StringToArray ( string: String , delimiter : String = "," ) : Array 
		{
			string = removeBrackets(string ) ;
			return string.split(delimiter);
		}
		
		/**
		 * Removes brackets from a string.
		 * @param s
		 * @return 
		 */
		public static function removeBrackets(s:String) : String 
		{
			if(s.indexOf("[",0) == 0 )
			{
				s=s.slice(1);
				s=s.slice(0,s.lastIndexOf("]"));
			}
			return s;
		}
		
		/**
			Creates an "universally unique" identifier (RFC 4122, version 4).
			
			@return Returns an UUID.
		*/
		public static function uuid():String {
			const specialChars:Array = new Array('8', '9', 'A', 'B');
			
			return StringUtils.createRandomIdentifier(8, 15) + '-' + StringUtils.createRandomIdentifier(4, 15) + '-4' + StringUtils.createRandomIdentifier(3, 15) + '-' + specialChars[NumberUtils.randomIntegerWithinRange(0, 3)] + StringUtils.createRandomIdentifier(3, 15) + '-' + StringUtils.createRandomIdentifier(12, 15);
		}
		
		/**
			Creates a random identifier of a specified length and complexity.
			
			@param length: The character length of the random identifier.
			@param racine: The number of unique/allowed values for each character (61 is the maximum complexity).
			@return Returns a random identifier.
			@usageNote For a case-insensitive identifier pass in a max <code>racine</code> of 35, for a numberic identifier pass in a max <code>racine</code> of 9.
		*/
		public static function createRandomIdentifier(length:uint, racine:uint = 61):String {
			const characters:Array = new Array('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');
			const id:Array         = new Array();
			racine                  = (racine > 61) ? 61 : racine;
			
			while (length--) {
				id.push(characters[NumberUtils.randomIntegerWithinRange(0, racine)]);
			}
			
			return id.join('');
		}
		
		/**
			Detects URLs in a String and wraps them in a link.
			
			@param source: String in which to automatically wrap links around URLs.
			@param window: The browser window or HTML frame in which to display the URL.
			@param className: An optional CSS class name to add to the link. You can specify multiple classes by seperating the class names with spaces.
			@return Returns the String with any URLs wrapped in a link.
		*/
		public static function autoLink(source:String, window:String = "_blank", className:String = null):String {
			const pattern:RegExp = /\b(([\w-]+\:\/\/?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|\/)))/g;
			className            = (className != "" && className != null) ? ' class="' + className + '"' : '';
			window               = (window != null) ? ' target="' + window + '"' : '';
			
			return source.replace(pattern, '<a href="$1"' + window + className + '>$1</a>');
		}
		
		/**
			Converts all applicable characters to HTML entities.
			
			@param source: String to convert.
			@return Returns the converted string.
		*/
		public static function htmlEncode(source:String):String {
			return new XML(new XMLNode(XMLNodeType.TEXT_NODE, source)).toXMLString();
		}
		
		/**
			Converts all HTML entities to their applicable characters.
			
			@param source: String to convert.
			@return Returns the converted string.
		*/
		public static function htmlDecode(source:String):String {
			return new XMLDocument(source).firstChild.nodeValue;
		}

		
		/**
			Determines if String is only comprised of punctuation characters (any character other than the letters or numbers).
			
			@param source: String to check.
			@param allowSpaces: Indicates to count spaces as punctuation <code>true</code>, or not to <code>false</code>.
			@return Returns <code>true</code> if String is only punctuation; otherwise <code>false</code>.
		*/
		public static function isPunctuation(source:String, allowSpaces:Boolean = true):Boolean {
			if (StringUtils.getNumbersFromString(source).length != 0 || StringUtils.getLettersFromString(source).length != 0)
				return false;
			
			if (!allowSpaces)
				return source.split(' ').length == 1;
			
			return true;
		}
		
		
		/**
			Determines if String is only comprised of numbers.
			
			@param source: String to check.
			@return Returns <code>true</code> if String is a number; otherwise <code>false</code>.
		*/
		public static function isNumber(source:String):Boolean {
			var trimmed:String = StringUtils.trim(source);
			
			if (trimmed.length < source.length || source.length == 0)
				return false;
			
			return !isNaN(Number(source));
		}
		
		
		/**
			Returns all the numeric characters from a String.
			
			@param source: String to return numbers from.
			@return String containing only numbers.
		*/
		public static function getNumbersFromString(source:String):String {
			var pattern:RegExp = /[^0-9]/g;
			return source.replace(pattern, '');
		}
		
		/**
			Returns all the letter characters from a String.
			
			@param source: String to return letters from.
			@return String containing only letters.
		*/
		public static function getLettersFromString(source:String):String {
			var pattern:RegExp = /[[:digit:]|[:punct:]|\s]/g;
			return source.replace(pattern, '');
		}
		
		/**
			Determines if String contains search String.
			
			@param source: String to search in.
			@param search: String to search for.
			@return Returns the frequency of the search term found in source String.
		*/
		public static function contains(source:String, search:String):uint {
			var pattern:RegExp = new RegExp(search, 'g');
			return source.match(pattern).length;
		}
		
		/**
			Strips whitespace (or other characters) from the beginning of a String.
			
			@param source: String to remove characters from.
			@param removeChars: Characters to strip (case sensitive). Defaults to whitespace characters.
			@return String with characters removed.
		*/
		public static function trimLeft(source:String, removeChars:String = StringUtils.WHITESPACE):String {
			var pattern:RegExp = new RegExp('^[' + removeChars + ']+', '');
			return source.replace(pattern, '');
		}
		
		/**
			Strips whitespace (or other characters) from the end of a String.
			
			@param source: String to remove characters from.
			@param removeChars: Characters to strip (case sensitive). Defaults to whitespace characters.
			@return String with characters removed.
		*/
		public static function trimRight(source:String, removeChars:String = StringUtils.WHITESPACE):String {
			var pattern:RegExp = new RegExp('[' + removeChars + ']+$', '');
			return source.replace(pattern, '');
		}
		
		/**
			Strips whitespace (or other characters) from the beginning and end of a String.
			
			@param source: String to remove characters from.
			@param removeChars: Characters to strip (case sensitive). Defaults to whitespace characters.
			@return String with characters removed.
		*/
		public static function trim(source:String, removeChars:String = StringUtils.WHITESPACE):String {
			var pattern:RegExp = new RegExp('^[' + removeChars + ']+|[' + removeChars + ']+$', 'g');
			return source.replace(pattern, '');
		}
		
		/**
			Removes additional spaces from String.
			
			@param source: String to remove extra spaces from.
			@return String with additional spaces removed.
		*/
		public static function removeExtraSpaces(source:String):String {
			var pattern:RegExp = /( )+/g;
			return StringUtils.trim(source.replace(pattern, ' '), ' ');
		}
		
		/**
			Removes tabs, linefeeds, carriage returns and spaces from String.
			
			@param source: String to remove whitespace from.
			@return String with whitespace removed.
		*/
		public static function removeWhitespace(source:String):String {
			var pattern:RegExp = new RegExp('[' + StringUtils.WHITESPACE + ']', 'g');
			return source.replace(pattern, '');
		}
		
		/**
			Removes characters from a source String.
			
			@param source: String to remove characters from.
			@param remove: String describing characters to remove.
			@return String with characters removed.
		*/
		public static function remove(source:String, remove:String):String {
			return StringUtils.replace(source, remove, '');
		}
		
		/**
			Replaces target characters with new characters.
			
			@param source: String to replace characters from.
			@param remove: String describing characters to remove.
			@param replace: String to replace removed characters.
			@return String with characters replaced.
		*/
		public static function replace(source:String, remove:String, replace:String):String {
			return source.split(remove).join(replace);
		}
		
		/**
			Removes a character at a specific index.
			
			@param source: String to remove character from.
			@param position: Position of character to remove.
			@return String with character removed.
		*/
		public static function removeAt(source:String, position:int):String {
			return StringUtils.replaceAt(source, position, '');
		}
		
		/**
			Replaces a character at a specific index with new characters.
			
			@param source: String to replace characters from.
			@param position: Position of character to replace.
			@param replace: String to replace removed character.
			@return String with character replaced.
		*/
		public static function replaceAt(source:String, position:int, replace:String):String {
			var parts:Array = source.split('');
			parts.splice(position, 1, replace);
			return parts.join('');
		}
		
		/**
			Adds characters at a specific index.
			
			@param source: String to add characters to.
			@param position: Position in which to add characters.
			@param addition: String to add.
			@return String with characters added.
		*/
		public static function addAt(source:String, position:int, addition:String):String {
			var parts:Array = source.split('');
			parts.splice(position, 0, addition);
			return parts.join('');
		}
		
		/**
			Counts the number of words in a String.
			
			@param source: String in which to count words.
			@return The amount of words.
		*/
		public static function getWordCount(source:String):uint {
			return StringUtils.removeExtraSpaces(StringUtils.doTrim(source)).split(' ').length;
		}
		
		/**
			Extracts all the unique characters from a source String.
			
			@param source: String to find unique characters within.
			@return String containing unique characters from source String.
		*/
		public static function getUniqueCharacters(source:String):String {
			var unique:String = '';
			var i:uint        = 0;
			var char:String;
			
			while (i < source.length) {
				char = source.charAt(i);
				
				if (unique.indexOf(char) == -1)
					unique += char;
				
				i++;
			}
			
			return unique;
		}
		
		/**
		 * Removes all whitespaces from a string.
		 * @param s
		 * @return 
		 */
		public static function removeWhiteSpace(s:String):String
		{
			s=s.split("\n").join("");
			s=s.split("\r").join("");
			s=s.split(" ").join("");
			return s;
		}
		
		/**
		 * Removes "ParameterSet" from a ParameterSet name (ie. 'ActionParameterSet' becomes 'Action') to build an xml tag wghen unserializing controls
		 * @param parameterNamer
		 * @return 
		 */
		public static function getTagNameFromParameterSet( parameterNamer : String ) : String
		{
			return parameterNamer.replace("ParameterSet", "").toLowerCase();
		}
		
		/**
		 * Transfoms a 'true' or 'false' string into a Boolean.
		 * @param s
		 * @return true if 'true' is passed, false otherwise.
		 */
		public static function StringToBoolean( s:  String ) : Boolean 
		{
			if( s == "true")
				return true;
			else
				return false;
		}
		/**
		*	Returns everything after the first occurrence of the provided character in the string.
		*
		*	@param p_string The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function afterFirst(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.indexOf(p_char);
			if (idx == -1) { return ''; }
			idx += p_char.length;
			return p_string.substr(idx);
		}

		/**
		*	Returns everything after the last occurence of the provided character in p_string.
		*
		*	@param p_string The string.
		*
		*	@param p_char The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function afterLast(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.lastIndexOf(p_char);
			if (idx == -1) { return ''; }
			idx += p_char.length;
			return p_string.substr(idx);
		}

		/**
		*	Determines whether the specified string begins with the specified prefix.
		*
		*	@param p_string The string that the prefix will be checked against.
		*
		*	@param p_begin The prefix that will be tested against the string.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function beginsWith(p_string:String, p_begin:String):Boolean {
			if (p_string == null) { return false; }
			return p_string.indexOf(p_begin) == 0;
		}

		/**
		*	Returns everything before the first occurrence of the provided character in the string.
		*
		*	@param p_string The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function beforeFirst(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.indexOf(p_char);
        	if (idx == -1) { return ''; }
        	return p_string.substr(0, idx);
		}

		/**
		*	Returns everything before the last occurrence of the provided character in the string.
		*
		*	@param p_string The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function beforeLast(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.lastIndexOf(p_char);
        	if (idx == -1) { return ''; }
        	return p_string.substr(0, idx);
		}

		/**
		*	Returns everything after the first occurance of p_start and before
		*	the first occurrence of p_end in p_string.
		*
		*	@param p_string The string.
		*
		*	@param p_start The character or sub-string to use as the start index.
		*
		*	@param p_end The character or sub-string to use as the end index.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function between(p_string:String, p_start:String, p_end:String):String {
			var str:String = '';
			if (p_string == null) { return str; }
			var startIdx:int = p_string.indexOf(p_start);
			if (startIdx != -1) {
				startIdx += p_start.length; // RM: should we support multiple chars? (or ++startIdx);
				var endIdx:int = p_string.indexOf(p_end, startIdx);
				if (endIdx != -1) { str = p_string.substr(startIdx, endIdx-startIdx); }
			}
			return str;
		}

		/**
		*	Description, Utility method that intelligently breaks up your string,
		*	allowing you to create blocks of readable text.
		*	This method returns you the closest possible match to the p_delim paramater,
		*	while keeping the text length within the p_len paramter.
		*	If a match can't be found in your specified length an  '...' is added to that block,
		*	and the blocking continues untill all the text is broken apart.
		*
		*	@param p_string The string to break up.
		*
		*	@param p_len Maximum length of each block of text.
		*
		*	@param p_delim delimter to end text blocks on, default = '.'
		*
		*	@returns Array
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function block(p_string:String, p_len:uint, p_delim:String = "."):Array {
			var arr:Array = new Array();
			if (p_string == null || !doContain(p_string, p_delim)) { return arr; }
			var chrIndex:uint = 0;
			var strLen:uint = p_string.length;
			var replPatt:RegExp = new RegExp("[^"+escapePattern(p_delim)+"]+$");
			while (chrIndex <  strLen) {
				var subString:String = p_string.substr(chrIndex, p_len);
				if (!doContain(subString, p_delim)){
					arr.push(truncate(subString, subString.length));
					chrIndex += subString.length;
				}
				subString = subString.replace(replPatt, '');
				arr.push(subString);
				chrIndex += subString.length;
			}
			return arr;
		}

		/**
		*	Capitallizes the first word in a string or all words..
		*
		*	@param p_string The string.
		*
		*	@param p_all (optional) Boolean value indicating if we should
		*	capitalize all words or only the first.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function capitalize(p_string:String, ...args):String {
			var str:String = doTrimLeft(p_string);
			trace('capl', args[0])
			if (args[0] === true) { return str.replace(/^.|\b./g, _upperCase);}
			else { return str.replace(/(^\w)/, _upperCase); }
		}

		/**
		*	Determines whether the specified string contains any instances of p_char.
		*
		*	@param p_string The string.
		*
		*	@param p_char The character or sub-string we are looking for.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function doContain(p_string:String, p_char:String):Boolean {
			if (p_string == null) { return false; }
			return p_string.indexOf(p_char) != -1;
		}

		/**
		*	Determines the number of times a charactor or sub-string appears within the string.
		*
		*	@param p_string The string.
		*
		*	@param p_char The character or sub-string to count.
		*
		*	@param p_caseSensitive (optional, default is true) A boolean flag to indicate if the
		*	search is case sensitive.
		*
		*	@returns uint
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function countOf(p_string:String, p_char:String, p_caseSensitive:Boolean = true):uint {
			if (p_string == null) { return 0; }
			var char:String = escapePattern(p_char);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.match(new RegExp(char, flags)).length;
		}

		/**
		*	Levenshtein distance (editDistance) is a measure of the similarity between two strings,
		*	The distance is the number of deletions, insertions, or substitutions required to
		*	transform p_source into p_target.
		*
		*	@param p_source The source string.
		*
		*	@param p_target The target string.
		*
		*	@returns uint
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function editDistance(p_source:String, p_target:String):uint {
			var i:uint;

			if (p_source == null) { p_source = ''; }
			if (p_target == null) { p_target = ''; }

			if (p_source == p_target) { return 0; }

			var d:Array = new Array();
			var cost:uint;
			var n:uint = p_source.length;
			var m:uint = p_target.length;
			var j:uint;

			if (n == 0) { return m; }
			if (m == 0) { return n; }

			for (i=0; i<=n; i++) { d[i] = new Array(); }
			for (i=0; i<=n; i++) { d[i][0] = i; }
			for (j=0; j<=m; j++) { d[0][j] = j; }

			for (i=1; i<=n; i++) {

				var s_i:String = p_source.charAt(i-1);
				for (j=1; j<=m; j++) {

					var t_j:String = p_target.charAt(j-1);

					if (s_i == t_j) { cost = 0; }
					else { cost = 1; }

					d[i][j] = _minimum(d[i-1][j]+1, d[i][j-1]+1, d[i-1][j-1]+cost);
				}
			}
			return d[n][m];
		}

		/**
		*	Determines whether the specified string ends with the specified suffix.
		*
		*	@param p_string The string that the suffic will be checked against.
		*
		*	@param p_end The suffix that will be tested against the string.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function endsWith(p_string:String, p_end:String):Boolean {
			return p_string.lastIndexOf(p_end) == p_string.length - p_end.length;
		}

		/**
		*	Determines whether the specified string contains text.
		*
		*	@param p_string The string to check.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function hasText(p_string:String):Boolean {
			var str:String = removeExtraWhitespace(p_string);
			return !!str.length;
		}

		/**
		*	Determines whether the specified string contains any characters.
		*
		*	@param p_string The string to check
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function isEmpty(p_string:String):Boolean {
			if (p_string == null) { return true; }
			return !p_string.length;
		}

		/**
		*	Determines whether the specified string is numeric.
		*
		*	@param p_string The string.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function isNumeric(p_string:String):Boolean {
			if (p_string == null) { return false; }
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test(p_string);
		}

		/**
		* Pads p_string with specified character to a specified length from the left.
		*
		*	@param p_string String to pad
		*
		*	@param p_padChar Character for pad.
		*
		*	@param p_length Length to pad to.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function padLeft(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) { s = p_padChar + s; }
			return s;
		}

		/**
		* Pads p_string with specified character to a specified length from the right.
		*
		*	@param p_string String to pad
		*
		*	@param p_padChar Character for pad.
		*
		*	@param p_length Length to pad to.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function padRight(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) { s += p_padChar; }
			return s;
		}

		/**
		*	Properly cases' the string in "sentence format".
		*
		*	@param p_string The string to check
		*
		*	@returns String.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function properCase(p_string:String):String {
			if (p_string == null) { return ''; }
			var str:String = p_string.toLowerCase().replace(/\b([^.?;!]+)/, capitalize);
			return str.replace(/\b[i]\b/, "I");
		}

		/**
		*	Escapes all of the characters in a string to create a friendly "quotable" sting
		*
		*	@param p_string The string that will be checked for instances of remove
		*	string
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function quote(p_string:String):String {
			var regx:RegExp = /[\\"\r\n]/g;
			return '"'+ p_string.replace(regx, _quote) +'"'; //"
		}

		/**
		*	Removes all instances of the remove string in the input string.
		*
		*	@param p_string The string that will be checked for instances of remove
		*	string
		*
		*	@param p_remove The string that will be removed from the input string.
		*
		*	@param p_caseSensitive An optional boolean indicating if the replace is case sensitive. Default is true.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function doRemove(p_string:String, p_remove:String, p_caseSensitive:Boolean = true):String {
			if (p_string == null) { return ''; }
			var rem:String = escapePattern(p_remove);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.replace(new RegExp(rem, flags), '');
		}

		/**
		*	Removes extraneous whitespace (extra spaces, tabs, line breaks, etc) from the
		*	specified string.
		*
		*	@param p_string The String whose extraneous whitespace will be removed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function removeExtraWhitespace(p_string:String):String {
			if (p_string == null) { return ''; }
			var str:String = doTrim(p_string);
			return str.replace(/\s+/g, ' ');
		}

		/**
		*	Returns the specified string in reverse character order.
		*
		*	@param p_string The String that will be reversed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function reverse(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.split('').reverse().join('');
		}

		/**
		*	Returns the specified string in reverse word order.
		*
		*	@param p_string The String that will be reversed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function reverseWords(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.split(/\s+/).reverse().join('');
		}

		/**
		*	Determines the percentage of similiarity, based on editDistance
		*
		*	@param p_source The source string.
		*
		*	@param p_target The target string.
		*
		*	@returns Number
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function similarity(p_source:String, p_target:String):Number {
			var ed:uint = editDistance(p_source, p_target);
			var maxLen:uint = Math.max(p_source.length, p_target.length);
			if (maxLen == 0) { return 100; }
			else { return (1 - ed/maxLen) * 100; }
		}

		/**
		*	Remove's all < and > based tags from a string
		*
		*	@param p_string The source string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function stripTags(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/<\/?[^>]+>/igm, '');
		}

		/**
		*	Swaps the casing of a string.
		*
		*	@param p_string The source string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function swapCase(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/(\w)/, _swapCase);
		}

		/**
		*	Removes whitespace from the front and the end of the specified
		*	string.
		*
		*	@param p_string The String whose beginning and ending whitespace will
		*	will be removed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function doTrim(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/^\s+|\s+$/g, '');
		}

		/**
		*	Removes whitespace from the front (left-side) of the specified string.
		*
		*	@param p_string The String whose beginning whitespace will be removed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function doTrimLeft(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/^\s+/, '');
		}

		/**
		*	Removes whitespace from the end (right-side) of the specified string.
		*
		*	@param p_string The String whose ending whitespace will be removed.
		*
		*	@returns String	.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function doTrimRight(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/\s+$/, '');
		}

		/**
		*	Determins the number of words in a string.
		*
		*	@param p_string The string.
		*
		*	@returns uint
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function wordCount(p_string:String):uint {
			if (p_string == null) { return 0; }
			return p_string.match(/\b\w+\b/g).length;
		}

		/**
		*	Returns a string truncated to a specified length with optional suffix
		*
		*	@param p_string The string.
		*
		*	@param p_len The length the string should be shortend to
		*
		*	@param p_suffix (optional, default=...) The string to append to the end of the truncated string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function truncate(p_string:String, p_len:uint, p_suffix:String = "..."):String {
			if (p_string == null) { return ''; }
			p_len -= p_suffix.length;
			var trunc:String = p_string;
			if (trunc.length > p_len) {
				trunc = trunc.substr(0, p_len);
				if (/[^\s]/.test(p_string.charAt(p_len))) {
					trunc = doTrimRight(trunc.replace(/\w+$|\s+$/, ''));
				}
				trunc += p_suffix;
			}

			return trunc;
		}

		/* **************************************************************** */
		/*	These are helper methods used by some of the above methods.		*/
		/* **************************************************************** */
		private static function escapePattern(p_pattern:String):String {
			// RM: might expose this one, I've used it a few times already.
			return p_pattern.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, '\\$1');
		}

		private static function _minimum(a:uint, b:uint, c:uint):uint {
			return Math.min(a, Math.min(b, Math.min(c,a)));
		}

		private static function _quote(p_string:String, ...args):String {
			switch (p_string) {
				case "\\":
					return "\\\\";
				case "\r":
					return "\\r";
				case "\n":
					return "\\n";
				case '"':
					return '\\"';
				default:
					return '';
			}
		}

		private static function _upperCase(p_char:String, ...args):String {
			trace('cap latter ',p_char)
			return p_char.toUpperCase();
		}

		private static function _swapCase(p_char:String, ...args):String {
			var lowChar:String = p_char.toLowerCase();
			var upChar:String = p_char.toUpperCase();
			switch (p_char) {
				case lowChar:
					return upChar;
				case upChar:
					return lowChar;
				default:
					return p_char;
			}
		}
		

	}
}