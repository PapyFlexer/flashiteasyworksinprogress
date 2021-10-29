<?php

/*
 * Created on 1 juin 2010
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */

class ContentManager extends FileManager {

	public $xml = "";

	public function readXml( FileDataTO & $transfer )
	{
		$xmlUrl = $transfer->files[0];
		if (isset( $xmlUrl))
		{
			$dom = new DOMDocument();
			$xml = $dom->load( $xmlUrl );
			if (isset( $xml ))
			{
				$transfer->success = true;
				$transfer->code = 0;
				$transfer->content = $dom->saveXML();
			}
			else
			{
				$transfer->success = false;
				$transfe->code = 1;
				$transfer->message = 'The requested XML is invalid';
			}
		}
		else
		{
			$transfer->success = false;
			$transfe->code = 2;
			$transfer->message = 'Could not read XML';
		}
		return $transfer;
	}

	public function getFolderTree(FileDataTO & $transfer) {
		$directory = $transfer->directory;
		$path = $this->current_path() . "/" . $directory;
		if(!is_dir($path))
		{
			$this->makeDirectory($directory,0755);
		}
		//début de scan et d'écriture du fichier
		$this->xml .= "<?xml version='1.0' encoding='UTF-8' ?>\n";
		$this->xml .= "<root>\n";

		$this->recursivescandir($path, $path);
		$this->xml .= "</root>";

		$transfer->content = $this->xml;
		$transfer->code = 0;
		return $transfer;

	}

	public function save_content($content, $file, $mode) {
		$content = stripslashes($content);
		if ($handle = fopen($this->current_path() . "/" . $file, $mode)) {
			fwrite($handle, $content);
			return true;
		} else {
			return false;
		}
	}

	public function saveContent(FileDataTO & $transfer, $mode) {
		$content = $transfer->content;
		$file = $transfer->files[0];
		$content = stripslashes($content);
		if ($handle = fopen($this->current_path() . "/" . $file, $mode)) {
			fwrite($handle, $content);
			return true;
		} else {
			return false;
		}
	}

	public function deletePage(FileDataTO & $transfer) {
		$directory = $transfer->directory;
		$file = $transfer->files[0];
		$errorArray = array ();
		$deleteArray = array ();
		if (is_dir($this->current_path() . "/" . $directory . "/" . $file)) {
			$this->removeFile($directory, array (
				$file
			));
		}
		$this->removeFile($directory, array (
			$file . ".xml"
		), $errorArray, $deleteArray);
		$transfer->deletedFiles = $deleteArray;
		$transfer->errorFiles = $errorArray;
		return $transfer;
	}

	public function pastePage(FileDataTO & $transfer) {
		$directory = $transfer[0]->directory;
		$file = $transfer[0]->files[0];
	}

	public function createFile(FileDataTO & $transfer) {
		$file = $transfer->files[0];
		$content = $transfer->content;
		$transfer->success = $this->makeFile($file, $content);
		return $transfer;
	}

	public function createNewPage(FileDataTO & $transfer) {
		$directory = $transfer->directory;
		$file = $transfer->files[0];
		$content = '<page></page>';
		if ($this->makeDirectory($directory)) {
			if ($this->makeFile($directory . "/" . $file, $content)) {
				$transfer->code = 0;
			} else {
				$transfer->code = 2;
			}
		} else {
			$transfer->code = 1;
		}

		return $transfer;
	}

}
?>
