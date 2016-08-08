package me.aaronshea.silkscreen;

import flash.Lib;
import flash.display.Sprite;
import flash.display.StageScaleMode;

import me.aaronshea.silkscreen.Recorder;
import me.aaronshea.silkscreen.MainWindow;

import flash.events.Event;
import flash.events.MouseEvent;

/**
 * @author Aaron M. Shea
 */
class Main extends Sprite 
{
	private var mainInterface:MainWindow;

	static function main() 
	{
		Lib.current.addChild(new Main());
	}

	public function new() 
	{
		super();

		// Know when this has been added to the stage so we can build the UI
		this.addEventListener(Event.ADDED_TO_STAGE, this.added);
	}
	
	public function added(evt:Event)
	{
		this.mainInterface = new MainWindow(this.stage, 600, 400);
		this.stage.scaleMode = StageScaleMode.NO_SCALE;
	
		// When should we start the encoding?	
		this.mainInterface.encodeButton.addEventListener(MouseEvent.MOUSE_DOWN, this.startEncode);
	}
	
	public function startEncode(evt:MouseEvent)
	{
		// Kick off a recording!
		var recorder = new Recorder(Std.int(this.mainInterface.widthStepper.value),
		Std.int(this.mainInterface.heightStepper.value),
		Std.int(this.mainInterface.framerateStepper.value),
		this.mainInterface.saveLocation.nativePath);

		recorder.createWindow();
		recorder.loadSWFFile();
	}
}