/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.controls.Validator
{
	import com.flashiteasy.api.controls.TextInputElementDescriptor;
	
	
	/**
	 * 
	 * The <code><strong>IsCreditCardValidator</strong></code> class checks if the string input is a regulard visa, amex or master card
	 */

	public class IsCreditCardValidator extends AbstractValidator
	{
		
		/**
		 * Constructor
		 */
		public function IsCreditCardValidator( owner : TextInputElementDescriptor ) 
		{
			this.owner = owner;
			super();
		}
		
		/** @inheritDoc **/
		override public function validateString( value : String ) : Boolean
		{
			var isCard : Boolean  = false;
			var visaExpression : RegExp = new RegExp("^ 4 [0-9] (12 }(?:[ 0-9] (3))? $") ;//Tous les numéros de carte Visa commencent par un 4. De nouvelles cartes ont 16 chiffres. Les anciennes cartes ont 13.
			var masterCardExpression : RegExp = new RegExp("^ 5 [1-5] [0-9] (14) $");// Tous les numéros de MasterCard commencer par les numéros 51 à 55. Tous ont 16 chiffres.
			var amExpExpression : RegExp = new RegExp(" ^ 3 [47] [0-9] (13) $");// numéros de cartes American Express commencer avec 34 ou 37 et ont 15 chiffres.
			var dinersExpression : RegExp  = new RegExp("^ 3 (?: 0 [0-5] | [68] [0-9]) [0-9] (11) $");// numéros de carte Diners Club commence avec 300 à 305, 36 ou 38. Tous ont 14 chiffres. Il ya les cartes Diners Club qui commencent par 5 et comporter 16 chiffres. Il s'agit d'une joint-venture entre Diners Club et MasterCard, et doivent être traitées comme une MasterCard.
			var discoverExpression : RegExp = new RegExp("^ 6 (?: 011 | 5 [0-9] (2)) [0-9] (12) $");// numéros de carte Découvrez commencer par 6011 ou 65. Tous ont 16 chiffres.
			var jcbExpression : RegExp = new RegExp("^ (?: 2131 | 1800 | 35 \ d (3)) \ d (11) $");// cartes JCB commençant par 2131 ou 1800 ont 15 chiffres. Les cartes JCB commençant par 35 ont 16 chiffres.
			var cards : Array = [visaExpression, masterCardExpression, amExpExpression, dinersExpression, discoverExpression, jcbExpression];
			for each ( var exp : RegExp in cards)
			{
				if ( exp.test( value ) )
				{
					isCard = true;
					break;
				}
			}
			return isCard;
		}
		
		/** @inheritDoc **/
		override public function getErrorString():String
		{
			return "this input is not a valid credit card number";
		}
				
	}
}