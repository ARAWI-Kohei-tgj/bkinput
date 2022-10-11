module screens.screen_2.process; 
/*
import screens.screen_2.layout;
import dpq2;

void screen_2(Connection conn){
	import dlangui;
*/
enum string SCREEN_2= q{
	Window window_2= Platform.instance.createWindow("Agrochem",
		null,
		WindowFlag.Resizable | WindowFlag.ExpandSize,
		640, 256);
	with(window_2){
		import screens.screen_2.layout;
		mainWidget= parseML(SCREEN_2_LAYOUT);
	}

	/***********************************************************
	 * transaction info
	 ***********************************************************/
	auto elDate= window_2.mainWidget.childById!EditLine("widget_2_00");
	with(elDate){
		minWidth(256);
	}
	auto elMinute= window_2.mainWidget.childById!EditLine("widget_2_01");
	with(elMinute){
		minWidth(256);
	}
	auto elShopName= window_2.mainWidget.childById!EditLine("widget_2_02");
	with(elShopName){
		minWidth(256);
	}
	auto cbDirection= window_2.mainWidget.childById!ComboBox("widget_2_03");
	with(cbDirection){
		items([""d, "I"d, "O"d, "T"d, "S"d]);
		minWidth(256);
	}
	auto elReference= window_2.mainWidget.childById!EditLine("widget_2_04");
	with(elReference){
		minWidth(256);
	}

	/***********************************************************
	 * tax info
	 ***********************************************************/
	auto elTaxName= window_2.mainWidget.childById!EditLine("widget_2_10");
	with(elTaxName){
		minWidth(256);
	}
	auto cbTaxDirection= window_2.mainWidget.childById!ComboBox("widget_2_11");
	auto elTaxPrice= window_2.mainWidget.childById!ComboBox("widget_2_12");
	with(elTaxPrice){
		minWidth(256);
	}

	cbTaxDirection.items([""d, "I"d, "O"d]);

	/**
	 *
	 **/

	auto buttonReg= window_2.mainWidget.childById!Button("widget_2_05");
	auto buttonCancel= window_2.mainWidget.childById!Button("widget_2_06");

	window_2.show;

	buttonReg.click= delegate(Widget src) @system{
		import postgresql;
		import std.conv: to, text;
		if(elDate.text.length > 0
				&& elShopName.text.length > 0
				&& cbDirection.selectedItem.length > 0){
			QueryParams cmdReg;
			QueryParams cmdTax;

			with(cmdReg){
				sqlCommand= `INSERT INTO account_voucher
(tr_date, minutes, shop_name, direction, reference) VALUES
($1::DATE, $2::SMALLINT, $3::TEXT, $4::CHAR, $5::TEXT[]);`;
				args.length= 5;

				args[0]= toValue(elDate.text);
				args[1]= toValue(elMinute.text);
				args[2]= toValue(elShopName.text);
				args[3]= toValue(cbDirection.selectedItem);
				args[4]= toValue(elReference.text);
			}
			conn.execParams(cmdReg);

			if(elTaxName.text.length > 0
					&& elTaxPrice.text.length > 0
					&& cbTaxDirection.selectedItem.length > 0){
				with(cmdTax){
					sqlCommand= `INSERT INTO tax_tr
(tr_id, tax_name, price, direction) VALUES
($1::INTEGER, $2::TEXT, $3::INTEGER, $4::CAHR);`;
					args.length= 4;
					args[0]= conn.getSeqLastValue("list_of_trs_tr_id_seq").toValue;
					args[1]= toValue(elTaxName.text);
					args[2]= toValue(elTaxPrice.text.to!int);
					args[3]= toValue(cbTaxDirection.selectedItem);
				}
				conn.execParams(cmdTax);
			}
			else{}

			getDetails(conn, tableDetails, summaryTree.items.selectedItem);	// external
			window_2.close;
		}
		else{}
		return true;
	};

	buttonCancel.click= delegate(Widget src) @system{
		window_2.close;
		return true;
	};
};
