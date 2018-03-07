package openfl._internal.renderer.cairo;


import lime.graphics.cairo.Cairo;
import lime.math.Matrix3;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.geom.Matrix;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:allow(openfl.display.Stage)


class CairoRenderer extends AbstractRenderer {
	
	
	private var cairo:Cairo;
	private var displayMatrix:Matrix;
	private var tempMatrix:Matrix;
	private var tempMatrix3:Matrix3;
	
	
	public function new (stage:Stage, cairo:Cairo) {
		
		super (stage);
		
		#if lime_cairo
		this.cairo = cairo;
		
		if (stage != null) {
			
			setDisplayMatrix (stage.__displayMatrix);
			
		} else {
			
			setDisplayMatrix (new Matrix ());
			
		}
		
		tempMatrix = new Matrix ();
		tempMatrix3 = new Matrix3 ();
		
		renderSession = new RenderSession ();
		renderSession.clearRenderDirty = true;
		renderSession.cairo = cairo;
		//renderSession.roundPixels = true;
		renderSession.renderer = this;
		renderSession.renderType = CAIRO;
		renderSession.maskManager = new CairoMaskManager (renderSession);
		renderSession.blendModeManager = new CairoBlendModeManager (renderSession);
		#end
		
	}
	
	
	public override function clear ():Void {
		
		if (cairo == null) return;
		
		cairo.identityMatrix ();
		
		if (stage.__clearBeforeRender) {
			
			cairo.setSourceRGB (stage.__colorSplit[0], stage.__colorSplit[1], stage.__colorSplit[2]);
			cairo.paint ();
			
		}
		
	}
	
	
	public function getMatrix (transform:Matrix, defaultRenderTarget:Bool):Matrix3 {
		
		tempMatrix.copyFrom (transform);
		
		if (defaultRenderTarget) {
			
			tempMatrix.concat (displayMatrix);
			
		}
		
		tempMatrix3.a = tempMatrix.a;
		tempMatrix3.b = tempMatrix.b;
		tempMatrix3.c = tempMatrix.c;
		tempMatrix3.d = tempMatrix.d;
		
		if (renderSession.roundPixels) {
			
			tempMatrix3.tx = Math.round (tempMatrix.tx);
			tempMatrix3.ty = Math.round (tempMatrix.ty);
			
		} else {
			
			tempMatrix3.tx = tempMatrix.tx;
			tempMatrix3.ty = tempMatrix.ty;
			
		}
		
		return tempMatrix3;
		
	}
	
	
	public override function render ():Void {
		
		if (cairo == null) return;
		
		renderSession.allowSmoothing = (stage.quality != LOW);
		
		stage.__renderCairo (renderSession);
		
	}
	
	
	public override function renderStage3D ():Void {
		
		if (cairo == null) return;
		
		for (stage3D in stage.stage3Ds) {
			
			stage3D.__renderCairo (stage, renderSession);
			
		}
		
	}
	
	
	public override function resize (width:Int, height:Int):Void {
		
		super.resize (width, height);
		
		if (stage != null) {
			
			setDisplayMatrix (stage.__displayMatrix);
			
		}
		
	}
	
	
	public function setDisplayMatrix (matrix:Matrix):Void {
		
		displayMatrix = matrix;
		
	}
	
	
}