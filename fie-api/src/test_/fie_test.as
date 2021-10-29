package {
	import com.flashiteasy.test.AllTest;
	import asunit.textui.TestRunner;
	import com.flashiteasy.test.TestFie;
	import com.flashiteasy.api.core.IUIElementContainer;

	import flash.utils.Dictionary;

	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.selection.InvisibleElementList;
	import com.flashiteasy.api.controls.*;
	import com.flashiteasy.api.container.*;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.ioc.IocContainer;
	import com.flashiteasy.api.parameters.*;
	import com.flashiteasy.api.utils.XMLParser;
	import com.flashiteasy.api.xml.impl.*;
	import com.asual.swfaddress.SWFAddress;		/**/
	import com.asual.swfaddress.SWFAddressEvent;	/**/
	import fl.core.UIComponent;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.Font;

	
	[SWF(width="1200", height="700", frameRate="60", backgroundColor="#FFFFFF" , scale="noscale" , allowFullScreen=true) ]
    		
	public class fie_test extends Sprite
	{
		
			// Import de fonts 
			
			[Embed(source="com/flashiteasy/api/font/DIN-Black.ttf",fontName="DB", fontWeight="normal", mimeType="application/x-font-truetype")]
			public var _font:Class;
			[Embed(source="com/flashiteasy/api/font/DIN-Bold.ttf", fontName="DB", fontWeight="bold", mimeType="application/x-font-truetype")]
			public var _font2:Class;
			
			// References globales au stage et au main
			
    		public static var GLOBAL_STAGE:Stage; 
			public static var GLOBAL_MAIN:fie_test; 
			

    		private var control:IUIElementDescriptor; //stock le container de la page en chargement
    		private var page_list:Array = new Array(); // Liste des blocks composant la page 
    		
    		// variable pour le chargement de page
    		
    		private var xml_files:Array = new Array(); // liste des fichiers xml a charger
    		private var xml_list:Array = new Array(); // Liste des xml charge 
    		private var pages:Array=new Array(); // noms des page chargé
			private var loadit:URLLoader; // chargeur des pages XML
			private var depth :Number = -1; // profondeur actuelle
			
			// ======= Navigation ================
			
			private var loadNav:URLLoader; // chargeur du xml de navigation
			private var navigation_xml:XML; // XML de navigation
			private var page_navigation:Dictionary= new Dictionary(); // Liste des pages du site
			private var save_pages:Array=new Array; // Sauvegarde de l arborescence de la page precedente

			private var count:int=-1;
			
    		public function fie_test() : void
    		{
    			
				
     			//test=new TestFie();
     			
    			Font.registerFont(_font);
    			Font.registerFont(_font2);
    			
    			fie_test.GLOBAL_STAGE = stage; 
    			fie_test.GLOBAL_MAIN = this; 
				stage.scaleMode= "noScale";
				stage.align="TC";
				stage.addEventListener(Event.RESIZE, onResize);
				loadit= new URLLoader();
				loadit.addEventListener(Event.COMPLETE, completeHandler);
				loadNav= new URLLoader();
				loadNav.addEventListener(Event.COMPLETE, navigationHandler);
				
				
				
				// Injection de parametres et des faces 
				// Ici l ensemble des parametres possible sont injecté
				// Il faudrait les injecter au run time et injecter seulement les parametres present dans le XML 
				
				IocContainer.registerType( TextElementDescriptor, IocContainer.GROUP_FACES, UIComponent );
				IocContainer.registerTypeList( TextElementDescriptor, IocContainer.GROUP_PARAMETERS,
					[ TargetParameterSet, AlignParameterSet , PaddingParameterSet , BackgroundColorParameterSet, TextOptionParameterSet ,TextParameterSet, SizeParameterSet, PositionParameterSet ]
				);
				IocContainer.registerType( XmlElementDescriptor, IocContainer.GROUP_FACES, UIComponent );
				IocContainer.registerTypeList( XmlElementDescriptor, IocContainer.GROUP_PARAMETERS,
					[ AlignParameterSet , BackgroundColorParameterSet , SizeParameterSet, PositionParameterSet , XmlParameterSet ,PaddingParameterSet , ResizeBehaviorParameterSet]
				);
				IocContainer.registerType( VideoElementDescriptor, IocContainer.GROUP_FACES, UIComponent );
				IocContainer.registerTypeList( VideoElementDescriptor, IocContainer.GROUP_PARAMETERS,
					[  FullScreenParameterSet , TargetParameterSet , AlignParameterSet , StartTransitionParameterSet , VideoParameterSet , SizeParameterSet, PositionParameterSet  ]
				);
				
				IocContainer.registerType( ListElementDescriptor, IocContainer.GROUP_FACES, UIComponent );
				IocContainer.registerTypeList( ListElementDescriptor, IocContainer.GROUP_PARAMETERS,
					[ TypeParameterSet , MarginParameterSet, XmlParameterSet ,ListParameterSet , AlignParameterSet , StartTransitionParameterSet , SizeParameterSet, PositionParameterSet ,PaddingParameterSet,ResizeBehaviorParameterSet ]
				);
				IocContainer.registerTypeList( FilterElementDescriptor, IocContainer.GROUP_PARAMETERS,
					[  TargetsParameterSet , FilterParameterSet  ]
				);
				IocContainer.registerTypeList( SoundElementDescriptor, IocContainer.GROUP_PARAMETERS,
					[  SoundParameterSet , SoundOptionParameterSet  ]
				);
    			IocContainer.registerType( RectElementDescriptor, IocContainer.GROUP_FACES, UIComponent);
    			IocContainer.registerType( ButtonElementDescriptor, IocContainer.GROUP_FACES, UIComponent);
    			IocContainer.registerTypeList( ButtonElementDescriptor, IocContainer.GROUP_PARAMETERS,
				[ XMLArrayParameterSet ,AlignParameterSet, SizeParameterSet, PositionParameterSet, StartTransitionParameterSet ]);
				
    			IocContainer.registerType( Select, IocContainer.GROUP_FACES,UIComponent);
 				
    			IocContainer.registerTypeList( RectElementDescriptor, IocContainer.GROUP_PARAMETERS,
					[ TargetParameterSet, BackgroundImageParameterSet ,AlignParameterSet , SelectableParameterSet,DragAndDropParameterSet, BackgroundColorParameterSet, SizeParameterSet, PositionParameterSet ]
				);
				
				IocContainer.registerType( BlockElementDescriptor, IocContainer.GROUP_FACES, UIComponent );
				IocContainer.registerTypeList( BlockElementDescriptor, IocContainer.GROUP_PARAMETERS,
					[ AlphaParameterSet , BackgroundImageParameterSet , AlignParameterSet , BlockListParameterSet,MaskParameterSet , BackgroundColorParameterSet, SizeParameterSet, PositionParameterSet, DragAndDropParameterSet,PaddingParameterSet,ResizeBehaviorParameterSet , StartTransitionParameterSet]
				);
					IocContainer.registerType(  ImgElementDescriptor, IocContainer.GROUP_FACES, UIComponent);
    			IocContainer.registerTypeList( ImgElementDescriptor, IocContainer.GROUP_PARAMETERS,
					[ ColorMatrixParameterSet , StartTransitionParameterSet, BlendModeParameterSet , AlignParameterSet ,SelectableParameterSet,PositionParameterSet, ImgParameterSet , ResizableParameterSet, SizeParameterSet,PaddingParameterSet ]
				);
				// We register the parsers for parameter sets.
    			IocContainer.registerType( SizeParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( BackgroundColorParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( BackgroundImageParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( PositionParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( TraceBehaviorParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( TweenParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( ImgParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( ResizableParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( BlockListParameterSet, IocContainer.GROUP_SERIALIZATION, BlockListParameterSetXMLParser );
    			IocContainer.registerType( DragAndDropParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( TextParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( SelectableParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( MaskParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( AlignParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( AlphaParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( BlendModeParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( ColorMatrixParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( TargetParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( VideoParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( XmlParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( StartTransitionParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( FilterParameterSet, IocContainer.GROUP_SERIALIZATION, FilterParameterSetXMLParser );
    			IocContainer.registerType( TargetsParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser );
    			IocContainer.registerType( SoundParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( FullScreenParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
    			IocContainer.registerType( ListParameterSet, IocContainer.GROUP_SERIALIZATION, FilterParameterSetXMLParser );
    			IocContainer.registerType( MarginParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
				IocContainer.registerType( LoopParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
				IocContainer.registerType( ActionBehaviorParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
				IocContainer.registerType( XMLArrayParameterSet, IocContainer.GROUP_SERIALIZATION, XMLArrayParameterSetXMLParser );
				IocContainer.registerType( TypeParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
				IocContainer.registerType( SoundOptionParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
				IocContainer.registerType( TextOptionParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
				IocContainer.registerType( PaddingParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
				IocContainer.registerType( ResizeBehaviorParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser );
				
				
				var unittests:TestRunner = new TestRunner();
      			stage.addChild(unittests);
     			unittests.start(AllTest, null, TestRunner.SHOW_TRACE);
     			
     			// load XML
     			
				SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddressChange);
    			loadNavigation("xml/navigation.xml");
    		}
    		
    		//=====================
    		// Fonction de navigation
    		//=====================
    		
    		public function loadNavigation(xml:String):void{
    			var url:String = xml+"?var="+Math.random()*10000;
				loadNav.dataFormat = "text";
				loadNav.load(new URLRequest(url));
    		}
    		
			// Execute la fonction du dessous lorsque le load est termine
    		
    		//    |
    		//	  |
    		//    v
    		
    		// Lorsque le XML de navigation a ete charge , demarre le parse du XML
    		
    		public function navigationHandler(e:Event):void{
    			navigation_xml = new XML( e.target.data as String);
    			parseNav(navigation_xml);
    		}
    		
    		// Remplit le dictionnaire avec l arborescence du site
    		
    		public function parseNav(xml:XML):void{
    			var x:XML;
    			var s:String;
    			var s2:String;
    			for each(x in xml.*){ // pour chaque page du xml
    				s=x.@container.length()+"";// Container de la page
    				s2=x.children().length() +"";// sous page de la page
    				
    				// si la page n a pas de container
    				if(s=="0"){
    					page_navigation[String(x.@link)]="stage";// le container de la page devient le stage
    				}
    				// sinon le container est celui specifie dans le XML
    				else{
    					page_navigation[String(x.@link)]=x.@container;
    				}
    				// si la page contient une sous page
    				if(s2 != "0"){
    					parseNav(x);// parse les sous pages
    				}
    			}
    		}
    		
    		//======================
    		// Chargement des pages
    		//=======================
    		
    		
    		// Lors d un changement d adresse 
    		// initialise toutes les variables necessaires
    		
    		private function handleSWFAddressChange (e:Event):void{
    			
    			// Remet tout les compteurs a 0 
    			
    			count=0;
    			xml_files=new Array(); // Liste des fichiers xml a charger
    			xml_list=new Array(); // Liste des xml
    			depth=0; 
    			
				InvisibleElementList.destruction(); // Detruit les blocs non visible 
				var address :String = SWFAddress.getValue();// Recupere l adresse
				var tmp :String = address;
				var link : String =""; 
				
				// stocke la Liste des sous pages 
				
				pages=tmp.substr(tmp.indexOf('/') +1 ,tmp.length).split("/");
				
				// Compte la profondeur de la page en fonction du nombre de /
				
				while ( tmp.indexOf('/') !=-1){
					tmp=tmp.substr(tmp.indexOf('/') +1 ,tmp.length);
					depth ++ ;
				}
				depth -- ;
				
				// ========================================================
			
			
				switch(SWFAddress.getValue()){
					
				// charge la page par defaut
				
				case "/":
					SWFAddress.setTitle(" SWF Address Example: Home ");
					pages.push("home");
					load_xmls("xml/home.xml");
					break;
					
				// Sinon charge la liste des pages
				
				default:
					link="";
					for each (var s:String in pages ){
						link+="/"+s;
						load_xmls("xml"+link+".xml");
					}
					break;
				}
    		}
    		
    		// Fonction stockant la liste des fichiers XML a charger 
    		
    		public function load_xmls(url:String):void{
    			xml_files.push(url); // Ajoute l url dans la liste des fichiers a charger
    			if(xml_files.length -1 == depth){ // si l ensemble des urls a ete fourni
    				load_start();// commence le chargement
    			}
    		}
    		
    		// Fonction de chargement des XML 
    		
    		public function load_start():void{
    			
    			// Lors de la premiere execution de la fonction ... 
    			if(count==-1){
    				
    				// Inverse l ordre des fichiers pour pouvoir les extraire avec un pop() 
    				xml_files.reverse(); 
    				count++;
    			}
    						
    			if( count<= depth){  // Si la totalite des fichiers n ont pas ete charge
    				loadXML(xml_files[count]); // charger le fichier suivant
    				count ++;
    			}
    			
    			else{ // sinon commence a creer la page
    				createPage();
    			}
    		}
    		
    		// Charge un fichier XML
    		
    		public function loadXML(xml:String):void{
    			var url:String = xml+"?var="+Math.random()*10000;
				loadit.dataFormat = "text";
				loadit.load(new URLRequest(url));
    		}
    		
    		// Execute la fonction du dessous lorsque le load est termine
    		
    		//    |
    		//	  |
    		//    v
    		
    		
    		// Fonction execute lorsqu un XML a fini son chargement 
    		
    		public function completeHandler(event:Event):void {
    			
    			// Ajoute le XML dans la liste des XML de la page
    			xml_list.push(new XML( event.target.data as String));
    			
    			//Continue le chargement des XML
    			load_start();
    		}
    		
    		// Cree la page en fonction des XML charge dans xml_list
    		// Change la page en cours 
    		
    		public function createPage():void
    		{
    			var i:int=0;
    			var creationIndex:int; // profondeur de la premiere page a creer ( celle ayant stage comme container )
    			var container:String;// stocke le container necessaire aux sous pages
    			
    			// si une page est deja affiché , commence par detruire les sous pages inutiles 
    			// ( celles se trouvant a une profondeur superieure a la page a charger ) 
    			
    			while(page_list.length > depth){ 
    				save_pages.pop();
    				page_list.pop().destroy();
    			}
    			
    			for(i=0;i<xml_list.length;i++){ 
    				
    				container=page_navigation[String(pages[i])];
    				if(container == " stage ")
    					creationIndex=i;
    			}
    			
    			// Debut de la creation de la page
    			
    			for(i=creationIndex;i<xml_list.length;i++){ // Pour chaque sous page ...
    				
    				container=page_navigation[String(pages[i])]; // Recupere le container necessaire a l affichage
    				
    				// Verifie si la sous page n est pas deja chargé 
    				// Cree la page sinon 
    				// ( afin d eviter de recreer une sous page deja affichée )
    				
    				if(save_pages[i] != xml_files[i]){ // si la pages de profondeur i est differente de celle actuellement affiche

    					if(page_list[i]!=null) // Detruit la sous page de profondeur i
    						page_list[i].destroy();
    					
    					// Cree la sous page dans le bon container
    					
    					if(container =="stage" || container =="")
    						control=XMLParser.parseXML(xml_list[i]);
    					else
    						control=XMLParser.parseXML(xml_list[i],ElementList.getElement(container) as IUIElementContainer);
    						
    					page_list[i]=control;// sauvegarde la sous page au niveau i;
    					save_pages[i]=xml_files[i];// sauvegarde le nom du fichier XML
    				}
    			}
			}

			
			public function onResize(e:Event):void{
				
				trace(stage.stageWidth + " " + e.target.width);
			}
    		
    		
    		

	}
}
