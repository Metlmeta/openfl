package openfl.display;

import openfl._internal.Lib;
#if (!lime && openfl_html5)
import openfl._internal.backend.lime_standalone.Application;
import openfl._internal.backend.lime_standalone.Window as LimeWindow;
import openfl._internal.backend.lime_standalone.WindowAttributes;
#else
import openfl._internal.backend.lime.Application;
import openfl._internal.backend.lime.Window as LimeWindow;
import openfl._internal.backend.lime.WindowAttributes;
#end

/**
	The Window class is a Lime Window instance that automatically
	initializes an OpenFL stage for the current window.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.LoaderInfo)
@:access(openfl.display.Stage)
@SuppressWarnings("checkstyle:FieldDocComment")
class Window #if (lime || openfl_html5) extends LimeWindow #end
{
	#if (!lime && !openfl_html5)
	public var application:Application;
	@SuppressWarnings("checkstyle:Dynamic") public var context:Dynamic;
	@SuppressWarnings("checkstyle:Dynamic") public var cursor:Dynamic;
	@SuppressWarnings("checkstyle:Dynamic") public var display:Dynamic;
	public var frameRate:Float;
	public var fullscreen:Bool;
	public var height:Int;
	public var scale:Float;
	public var stage:Stage;
	public var textInputEnabled:Bool;
	public var width:Int;
	#end

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function new(application:Application, attributes:#if (lime || openfl_html5) WindowAttributes #else Dynamic #end)
	{
		#if (lime || openfl_html5)
		super(application, attributes);
		#end

		#if (!flash && !macro)
		#if (commonjs || (!lime && openfl_html5))
		if (Reflect.hasField(attributes, "stage"))
		{
			stage = Reflect.field(attributes, "stage");
			stage.window = this;
			Reflect.deleteField(attributes, "stage");
		}
		else
		#end
		stage = new Stage(this, Reflect.hasField(attributes.context, "background") ? attributes.context.background : 0xFFFFFF);

		if (Reflect.hasField(attributes, "parameters"))
		{
			try
			{
				stage.loaderInfo.parameters = attributes.parameters;
			}
			catch (e:Dynamic) {}
		}

		if (Reflect.hasField(attributes, "resizable") && !attributes.resizable)
		{
			stage.__setLogicalSize(attributes.width, attributes.height);
		}

		#if (lime || openfl_html5)
		application.addModule(stage);
		#end
		#else
		stage = Lib.current.stage;
		#end
	}
}
