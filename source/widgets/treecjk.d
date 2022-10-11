module widgets.treecjk;

import dlangui;
class TreeWidgetCJK: TreeWidget{
	this(){
		fontCJK= FontManager.instance.getFont(24, FontWeight.Normal, false, FontFamily.MonoSpace, "IPAゴシック");
	}

	override FontRef font() const @property{
		return cast(FontRef)fontCJK;
	}

private:
	FontRef fontCJK;
}
