module screens.screen_2.layout;

import screens.screen_2.layout;

enum string SCREEN_2_LAYOUT= q{
	VerticalLayout{
		GroupBox{
			id: transaction_info
			text: "Transaction"
			TableLayout{
				colCount: 2
				TextWidget{text: "日付"; fontFace: "IPAゴシック"}
				EditLine{id: widget_2_00; fontFace: "IPAゴシック"}
				TextWidget{text: "時刻"; fontFace: "IPAゴシック"}
				EditLine{id: widget_2_01; fontFace: "IPAゴシック"}
				TextWidget{text: "店名"; fontFace: "IPAゴシック"}
				EditLine{id: widget_2_02; fontFace: "IPAゴシック"}
				TextWidget{text: "方向"; fontFace: "IPAゴシック"}
				ComboBox{id: widget_2_03; fontFace: "IPAゴシック"}
				TextWidget{text: "領収書"; fontFace: "IPAゴシック"}
				EditLine{id: widget_2_04; fontFace: "IPAゴシック"}
			}
		}
		GroupBox{
			id: tax_info
			text: "Tax"
			TableLayout{
				colCount: 3
				TextWidget{text: "税名"; fontFace: "IPAゴシック"}
				TextWidget{text: "I/O"; fontFace: "IPAゴシック"}
				TextWidget{text: "税額"; fontFace: "IPAゴシック"}
				EditLine{id: widget_2_10; fontFace: "IPAゴシック"}
				ComboBox{id: widget_2_11; fontFace: "IPAゴシック"}
				EditLine{id: widget_2_12; fontFace: "IPAゴシック"}
			}
		}
		HorizontalLayout{
			Button{id: widget_2_05; fontFace: "IPAゴシック"; text: "登録"}
			Button{id: widget_2_06; fontFace: "IPAゴシック"; text: "Cancel"}
		}
	}
};
