<?php
/*
 * Created on 2 nov. 10 by FIE crew
 *
 * this code is part of FlashIteasy, flash content integrator
 */

class xslTransformer
{
	
	function unhtmlentities( $string )
	{
		$trans_tbl = get_html_translation_table( HTML_ENTITIES );
		$trans_tbl = array_flip( $trans_tbl );
		return strtr( $string, $trans_tbl );
	}
	
	
	function pagesIndexation( $pagesArray )
	{
		if ( isset( $pagesArray ) )
		{
			foreach ($pagesArray as $pagefile)
			{
				$xslDoc = new DOMDocument();
				$xslDoc->substituteEntities = true;
				$xslDoc->load("transform.xsl");
				
				$xmlDoc = new DOMDocument();
				$xmlDoc->load("../xml/" . $pagefile);
				
				$proc = new XSLTProcessor();
				$proc->importStylesheet( $xslDoc );
				echo $this->unhtmlentities($proc->transformToXML( $xmlDoc ));
			}
		}
		else
		{
			// TODO : generate errorcodes
			//
		}
	}

	function singlePageIndexation( $pageFile )
	{
		if ( isset( $pageFile ) )
		{
			$xslDoc = new DOMDocument();
			$xslDoc->substituteEntities = true;
			$xslDoc->load("../xsl/transform.xsl");
			
			$xmlDoc = new DOMDocument();
			$xmlDoc->load($_SERVER['DOCUMENT_ROOT'] . "/fie-app/bin-debug/xml/" . $pageFile . ".xml");
			
			$proc = new XSLTProcessor();
			$proc->importStylesheet( $xslDoc );
			echo $this->unhtmlentities($proc->transformToXML( $xmlDoc ));
		
		}
		else
		{
			// TODO : generate errorcodes
			//
		}
	}

}
	
?>
