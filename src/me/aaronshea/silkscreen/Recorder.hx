package me.aaronshea.silkscreen;

import flash.Boot;
import flash.display.StageQuality;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display.NativeWindowInitOptions;
import flash.display.NativeWindow;
import flash.display.Loader;
import flash.display.Bitmap;
import flash.display.NativeWindow;
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Matrix;
import flash.system.LoaderContext;
import flash.system.LoaderContext;
import flash.system.System;
import flash.net.FileReference;
import flash.net.FileFilter;
import flash.utils.ByteArray;
import flash.filesystem.File;

import format.swf.Data.SWFHeader;

import format.swf.Reader;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Input;


/**
 * @author Aaron M. Shea
 */
class Recorder
{	
	private var window:NativeWindow;
	private var swfLoader:Loader;
	
	private var fileToLoad:FileReference;
	private var header:SWFHeader;
	
	private var framerateOut:Int;
	private var saveFile:String;
	
	// Where we draw the frame data
	private var currentFrame:BitmapData;
	private var transformMatrix:Matrix;
	private var currentFrameCount:Int = 1;
	
	// FFMpeg process to write to
	private var ffmpeg:FFMpegProcess;

	public function new(width:Int, height:Int, targetFramerate:Int, saveTo:String) 
	{	
		this.framerateOut = targetFramerate;
		this.saveFile = saveTo;
		this.currentFrame = new BitmapData(width, height, true);
		this.transformMatrix = new Matrix();
		this.swfLoader = new Loader();
		this.swfLoader.contentLoaderInfo.addEventListener(Event.INIT, this.onSWFLoaded);
	}
	
	public function createWindow()
	{
		var options:NativeWindowInitOptions = new NativeWindowInitOptions();
		options.maximizable = false;
		options.minimizable = false;
		
		// More window setup
		window = new NativeWindow(options);
		window.title = "Encoding...";
		
		this.window.stage.align = StageAlign.TOP_LEFT;
		this.window.stage.scaleMode = StageScaleMode.NO_SCALE;
	}
	
	public function loadSWFFile()
	{
		fileToLoad = new FileReference(); 
		var textTypeFilter:FileFilter = new FileFilter("SWF Animations (*.swf)", "*.swf");
		fileToLoad.addEventListener(Event.SELECT, this.onFileSelected);
		fileToLoad.browse([textTypeFilter]);
	}
	
	private function onFileSelected(evt:Event)
	{
		fileToLoad.load();
		fileToLoad.addEventListener(Event.COMPLETE, this.fileLoaded); 
	}
	
	private function fileLoaded(evt:Event)
	{
		// Allow code to be executed and imported into the child window
		var context:LoaderContext = new LoaderContext();
		context.allowCodeImport = true;
		context.allowLoadBytesCodeExecution = true;
		
		// Read the header of the SWF we loaded
		var input = new BytesInput(Bytes.ofData(this.fileToLoad.data));
		this.header = new Reader(input).readHeader();
		
		this.ffmpeg = new FFMpegProcess(this.currentFrame.width, this.currentFrame.height, this.framerateOut, this.saveFile);
		this.ffmpeg.startProcess();
		
		// Window props from SWF
		this.window.width = this.header.width;
		this.window.height = this.header.height;
		this.window.stage.stageWidth = this.header.width;
		this.window.stage.stageHeight = this.header.height;
		this.window.stage.frameRate = this.framerateOut;
		this.window.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		// Matrix scaling
		var scaleX = this.currentFrame.width / header.width;
		var scaleY = this.currentFrame.height / header.height;
		this.transformMatrix.scale(scaleX, scaleY);
		
		this.swfLoader.loadBytes(this.fileToLoad.data, context);
		this.window.stage.addChild(this.swfLoader);
		
		window.x = (window.stage.fullScreenWidth - window.width) / 2;
		window.y = 0;
		
		window.activate();
	}
	
	private function onSWFLoaded(evt:Event)
	{
		this.swfLoader.contentLoaderInfo.removeEventListener(Event.INIT, this.onSWFLoaded);
		
		this.swfLoader.addEventListener(Event.ENTER_FRAME, enterFrameCapture);
		this.swfLoader.addEventListener(Event.RENDER, renderFrameCapture);
	}
	
	private function enterFrameCapture(evt:Event)
	{
		this.window.stage.invalidate();
		currentFrameCount++;
	}
	
	private function renderFrameCapture(evt:Event)
	{
		// Have we reached the end of our swf?
		if (this.currentFrameCount >= header.nframes)
		{
			System.pause();
			this.ffmpeg.closeProcess();
			this.swfLoader.unloadAndStop();
			
			this.swfLoader.removeEventListener(Event.ENTER_FRAME, enterFrameCapture);
			this.swfLoader.removeEventListener(Event.RENDER, renderFrameCapture);
			window.close();
			return;
		}
		
		// Prep the stage for rendering
		window.stage.align = StageAlign.TOP_LEFT;
		window.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		this.currentFrame.lock();
		
		System.pause();
		
		// Transparent drawing!
		this.currentFrame.fillRect(this.currentFrame.rect, 0x00000000);
		this.currentFrame.drawWithQuality(this.window.stage, this.transformMatrix, null, null, null, false, StageQuality.HIGH);
		
		// Throw the bytes over into FFMpeg
		this.ffmpeg.stdIn.writeBytes(this.currentFrame.getPixels(this.currentFrame.rect));
		
		this.currentFrame.unlock();
		
		System.resume();
	}
	
}