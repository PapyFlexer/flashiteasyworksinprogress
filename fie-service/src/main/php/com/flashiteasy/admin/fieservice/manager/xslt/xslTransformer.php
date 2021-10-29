<?php
/*
 * Created on 2 nov. 10 by FIE crew
 *
 * this code is part of FlashIteasy, flash content integrator
 */

class xslTransformer extends BaseManager
{
	
	function unhtmlentities( $string )
	{
		$trans_tbl = get_html_translation_table( HTML_ENTITIES );
		$trans_tbl = array_flip( $trans_tbl );
		return strtr( $string, $trans_tbl );
	}
	
		
	function transform( $xml_file , $xsl_script )
	{
	
		$xslDoc = new DOMDocument();
		$xslDoc->substituteEntities = true;
		$xslDoc->load($xsl_script);
				
		$xmlDoc = new DOMDocument();
		$xmlDoc->loadXML($xml_file);
				
		$proc = new XSLTProcessor();
		$proc->importStylesheet( $xslDoc );
		return $this->unhtmlentities($proc->transformToXML( $xmlDoc ));
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
			
			$directory=$this->current_path()."/";
			$xmlDoc = new DOMDocument();
			$xmlDoc->load($directory . $pageFile);
			
			$proc = new XSLTProcessor();
			$proc->importStylesheet( $xslDoc );
			//echo $this->unhtmlentities($proc->transformToXML( $xmlDoc ));
			return $this->unhtmlentities($proc->transformToXML( $xmlDoc ));
		}
		else
		{
			// TODO : generate errorcodes
			//
		}
	}

}
	
?>
