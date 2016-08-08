package me.aaronshea.silkscreen;

import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;

import flash.text.Font;
import flash.text.TextFormatAlign;
import flash.text.TextFormat;

import flash.filesystem.File;

import fl.controls.Button;
import fl.controls.NumericStepper;
import fl.controls.Label;

/**
 * @author Aaron M. Shea
 */
class MainWindow
{
	
	public var encodeButton:Button;
	public var saveFileButton:Button;
	
	public var framerateStepper:NumericStepper;
	public var widthStepper:NumericStepper;
	public var heightStepper:NumericStepper;
	
	public var saveLocation:File;
	
	public function new(parentStage:Stage, width:Float, height:Float) 
	{
		// Label text format
		var labelFormat:TextFormat = new TextFormat();
		labelFormat.align = TextFormatAlign.CENTER;
		labelFormat.font = "Arial";
		
		// Framerate selector
		var frameLabel = new Label();
		frameLabel.setStyle("textFormat", labelFormat);
		frameLabel.text = "Output Framerate";
		frameLabel.x = (width - frameLabel.width) / 2;
		frameLabel.y = 80;
		parentStage.addChild(frameLabel);
		
		this.framerateStepper = new NumericStepper();
		this.framerateStepper.minimum = 24;
		this.framerateStepper.maximum = 120;
		this.framerateStepper.value = 24;
		this.framerateStepper.x = (width - this.framerateStepper.width) / 2;
		this.framerateStepper.y = 100;
		parentStage.addChild(this.framerateStepper);
		
		// Width Selector
		var widthLabel = new Label();
		widthLabel.text = "Output Width";
		widthLabel.setStyle("textFormat", labelFormat);
		widthLabel.x = (width - widthLabel.width) / 2;
		widthLabel.y = 130;
		parentStage.addChild(widthLabel);
		
		this.widthStepper = new NumericStepper();
		this.widthStepper.minimum = 0;
		this.widthStepper.maximum = 9999;
		this.widthStepper.value = 1920;
		this.widthStepper.x = (width - this.widthStepper.width) / 2;
		this.widthStepper.y = 150;
		parentStage.addChild(this.widthStepper);

		// Height Selector
		var heightLabel = new Label();
		heightLabel.text = "Output Height";
		heightLabel.setStyle("textFormat", labelFormat);
		heightLabel.x = (width - heightLabel.width) / 2;
		heightLabel.y = 180;
		parentStage.addChild(heightLabel);
		
		this.heightStepper = new NumericStepper();
		this.heightStepper.minimum = 0;
		this.heightStepper.maximum = 9999;
		this.heightStepper.value = 1080;
		this.heightStepper.x = (width - this.heightStepper.width) / 2;
		this.heightStepper.y = 200;
		parentStage.addChild(this.heightStepper);
		
		// Save Location button
		this.saveFileButton = new Button();
		this.saveFileButton.label = "Choose Save File";
		this.saveFileButton.x = (width - this.saveFileButton.width) / 2;
		this.saveFileButton.y = 250;
		parentStage.addChild(this.saveFileButton);
		this.saveFileButton.addEventListener(MouseEvent.MOUSE_DOWN, this.selectSave);
		
		// Encode button
		this.encodeButton = new Button();
		this.encodeButton.width = 200;
		this.encodeButton.label = "Select and Start Encoding";
		this.encodeButton.x = (width - this.encodeButton.width) / 2;
		this.encodeButton.y = 295;
		parentStage.addChild(this.encodeButton);
		
		this.encodeButton.enabled = false;
	}
	
	private function selectSave(evt:MouseEvent)
	{
		// Browse for a file to save to
		saveLocation = File.desktopDirectory.resolvePath("output.mov");
		saveLocation.browseForSave("Save Video As...");
		saveLocation.addEventListener(Event.SELECT, this.setSaveLocation);
	}
	
	private function setSaveLocation(evt:Event)
	{
		if (this.saveLocation.extension != "mov")
		{
			// Force mov file extension at the end
			this.saveLocation.nativePath = this.saveLocation.nativePath + ".mov";
		}
		this.encodeButton.enabled = true;
	}
	
}