module screens.screen_1.process;

import dpq2;
import dlangui;
import std.typecons: Tuple, tuple;
import std.datetime: Date, Month;

/*************************************************************
 * 
 *************************************************************/
void screen_1(Connection conn){
	import screens.screen_1.layout;

	/**
	 * 
	 **/
	Tuple!(int, "id", Date, "date")[] details;

	Window window_1= Platform.instance.createWindow("Agrochem",
		null,
		WindowFlag.Resizable | WindowFlag.ExpandSize,
		1080, 640);
	with(window_1){
		mainWidget= parseML(SCREEN_1_LAYOUT);
		mainWidget.fontFace("IPAゴシック");
	}

	{

		/*****************************************
		 * widgets
		 *****************************************/
		auto editlineYear= window_1.mainWidget.childById!EditLine("widget_1_00");
		with(editlineYear){
			minWidth(64);
			fontSize(24);
		}
/+
		auto editlineCrop= new EditLineCJK();
		editlineCrop.minWidth(128);
		window_1.mainWidget.addChild(editlineCrop);
+/

		auto comboMonth= window_1.mainWidget.childById!ComboBox("widget_1_01");
		with(comboMonth){
			minWidth(128);
			fontSize(24);
			fontFace("IPAゴシック");
			items(["1"d, "2"d, "3"d, "4"d, "5"d, "6"d, "7"d, "8"d, "9"d, "10"d, "11"d, "12"d]);
		}

		auto buttonSearch= window_1.mainWidget.childById!Button("widget_1_02");

		//import widgets.treecjk: TreeWidgetCJK;
		auto summaryTree= window_1.mainWidget.childById!TreeWidget("widget_1_03");
		with(summaryTree){
			minHeight(512);
			minWidth(512);
			fontFace("IPAゴシック");
		}

		/// Table 'spray_summary'へ登録
		auto addSummary= window_1.mainWidget.childById!Button("widget_1_08");

		/// Table 'spary_summary'から削除
		auto removeSummary= window_1.mainWidget.childById!Button("widget_1_09");

		/// 終了
		auto buttonQuit= window_1.mainWidget.childById!Button("widget_1_07");
		buttonQuit.click= delegate(Widget src) @system{
			window_1.close;
			return true;
		};

		auto contentsTr= window_1.mainWidget.childById!VerticalLayout("tr_contents");

		auto minuteDisplay= window_1.mainWidget.childById!TextWidget("widget_1_20");
		with(minuteDisplay){
			fontFace("IPAゴシック");
			minWidth(256);
		}

		auto shopNameDisplay= window_1.mainWidget.childById!TextWidget("widget_1_21");
		with(shopNameDisplay){
			fontFace("IPAゴシック");
			minWidth(256);
		}

		auto directionDisplay= window_1.mainWidget.childById!TextWidget("widget_1_22");
		with(directionDisplay){
			fontFace("IPAゴシック");
			minWidth(256);
		}

		auto directionTax= window_1.mainWidget.childById!TextWidget("widget_1_23");
		with(directionTax){
			fontFace("IPAゴシック");
			minWidth(256);
		}

		auto directionRefs= window_1.mainWidget.childById!TextWidget("widget_1_24");
		with(directionRefs){
			fontFace("IPAゴシック");
			minWidth(256);
		}

		auto tableDetails= window_1.mainWidget.childById!StringGridWidget("widget_1_04");
		with(tableDetails){
			minWidth(700);
			minHeight(482);
			fontFace("IPAゴシック");
			resize(5, 1);
			/**
			 * 
 * Column | column name | contents
 * 1 | tr_id | 取引番号
 * 2 | tr_date | 取引日
 * 3 | minutes | timestamp hh:mm -> 60*hh+mm
 * 4 | shop_name | 購入店舗又は出荷先
 * 5 | direction | I:収入, O:支出, T:科目振替, S:出荷（IとOの両方が含まれ，場合によっては赤字になる） 
 * 6 | reference | 領収書等の保管先 --'YYYY;transactionより先'

  * 1| tr_id: 取引日
 * 2| summary: 摘要
 * 3| price: 金額
 * 4| title_debit: 借方の勘定科目
 * 5| title_credit: 貸方の勘定科目
 * 6| reference: 領収書等のファイル名[agriculture/logs/YYYY/transaction/...]
 **/
			setColWidth(0, 64);
			setColTitle(0, "摘要"d);
			setColWidth(1, 256);
			setColTitle(1, "金額"d);
			setColWidth(2, 64);
			setColTitle(2, "借方"d);
			setColWidth(3, 128);
			setColTitle(3, "貸方"d);
			setColWidth(4, 128);
			setColTitle(4, "領収書"d);
		}

		auto edtlnTrId= window_1.mainWidget.childById!EditLine("widget_1_10");
		with(edtlnTrId){
			fontFace("IPAゴシック");
			minWidth(64);
		}
		auto edtlnSummary= window_1.mainWidget.childById!EditLine("widget_1_11");
		with(edtlnSummary){
			fontFace("IPAゴシック");
			minWidth(256);
		}
		auto edtlnPrice= window_1.mainWidget.childById!EditLine("widget_1_12");
		with(edtlnPrice){
			fontFace("IPAゴシック");
			minWidth(128);
		}
		auto edtlnTitleDebit= window_1.mainWidget.childById!EditLine("widget_1_13");
		with(edtlnTitleDebit){
			fontFace("IPAゴシック");
			minWidth(230);
		}
		auto edtlnTitleCredit= window_1.mainWidget.childById!EditLine("widget_1_14");
		with(edtlnTitleCredit){
			fontFace("IPAゴシック");
			minWidth(230);
		}

		auto addDetail= window_1.mainWidget.childById!Button("widget_1_15");
		auto removeDetail= window_1.mainWidget.childById!Button("widget_1_16");

		/*****************************************
		 * 検索ボタン
		 *****************************************/
		buttonSearch.click= delegate(Widget src) @system{
			if(editlineYear.text.length > 0){
				import std.datetime: Month;
				const int yearDigit= editlineYear.text.to!int;
				const Month month= cast(Month)(comboMonth.selectedItemIndex +1u);
				searchSummary(conn, summaryTree, yearDigit, month);
				auto idSelected= getDetails(conn, tableDetails, summaryTree.items.selectedItem);
				if(idSelected > 0){
					edtlnTrId.text= idSelected.to!dstring;
					contentsTr.getTrContents(conn, idSelected);
					/+
					shopNameDisplay.text= getShopName(conn, idSelected);
					directionDisplay.text= getDirection(conn, idSelected);+/
				}
			}
			else{}

			return true;
		};

		/**
		 * Tree
		 */
		summaryTree.selectionChange= delegate(TreeItems src, TreeItem theItem, bool isActivated) @system{
			auto idSelected= getDetails(conn, tableDetails, theItem);
			if(idSelected > 0){
				edtlnTrId.text= idSelected.to!dstring;
				contentsTr.getTrContents(conn, idSelected);
				/+
				shopNameDisplay.text= getShopName(conn, idSelected);
				directionDisplay.text= getDirection(conn, idSelected);+/
			}
		};

		addSummary.click= delegate(Widget src) @system{
			import screens.screen_2.process;

			mixin(SCREEN_2);
			//screen_2(conn);
			return true;
		};

		/**
		 * details
		 */

		addDetail.click= delegate(Widget src) @system{
			import std.algorithm: all, map, fill;
			import std.conv: text;
			import std.string: isNumeric;
			import std.array: staticArray;

			QueryParams cmd;
			with(cmd){
				sqlCommand= `INSERT INTO account_voucher
(tr_id, summary, price, title_debit, title_credit) VALUES
($1::INTEGER, $2::TEXT, $3::INTEGER, $4::TEXT, $5::TEXT);`;
				args.length= 5;
			}

			const string[5] strArgs= [edtlnTrId.text, edtlnSummary.text,
					edtlnPrice.text, edtlnTitleDebit.text,
					edtlnTitleCredit.text].map!(a => a.text).staticArray!5;

			if(strArgs[].all!(a => a.length > 0)){
				if([strArgs[0], strArgs[2]].all!(a => a.isNumeric)){
					cmd.args[].fill(strArgs[].map!(a => toValue(a)));
					conn.execParams(cmd);

					edtlnSummary.text= ""d;
					edtlnPrice.text= ""d;
					edtlnTitleDebit.text= ""d;

					getDetails(conn, tableDetails, summaryTree.items.selectedItem);
				}
				else{}
			}
			else{}

			return true;
		};

/+
		addDetail.click= delegate(Widget src) @system{
			import screens.screen_3.process;

			screen_3(conn);
			return true;
		};
+/
	}
	window_1.show;
}

/**
 * 散布内容の詳細を取得しStringGridWidgetへ表示
 ****/
int getDetails(Connection conn, StringGridWidget grid, TreeItem branch) @system{
	import std.conv: dtext, to;

	int result;
	if(branch){
		QueryParams cmdDetail;
		result= branch.id.to!(typeof(result));
		/**
		 * buffer clean-up
		 */
		foreach(int idxRow; 0u..grid.rows){
			foreach(int idxCol; 0u..4u) grid.setCellText(idxCol, idxRow, ""d);
		}

		with(cmdDetail){
			sqlCommand= `SELECT summary,
					price,
					title_debit,
					title_credit
				FROM account_voucher
				WHERE tr_id = $1::INTEGER`;
			args.length= 1;
			args[0]= toValue(cast(long)result);
		}
		auto ans= conn.execParams(cmdDetail);

		int idxRow;
		grid.resize(4, cast(int)(ans.length));
		foreach(scope row; ans.rangify){
			grid.setCellText(0, idxRow, dtext(row["summary"].as!string));
			grid.setCellText(1, idxRow, dtext(row["price"].as!int));
			grid.setCellText(2, idxRow, dtext(row["title_debit"].as!string));
			grid.setCellText(3, idxRow, dtext(row["title_credit"].as!string));
			++idxRow;
		}
	}
	else{
		result= -1;
	}
	return result;
}

/**
 *
 **/
import std.string: isNumeric;
Tuple!(int, "id", Date, "date")[] searchSummary(Connection conn, TreeWidget tree,
		const int year, const Month month) @system{
	import std.conv: text, dtext;

	typeof(return) result;
	const Date dateSt= Date(year, month, 1);

	/*************************************
	 * Initialization
	 *************************************/
	tree.clearAllItems;

	/**
	 * table 'list_of_trs'
	 *
	 *
	 **/
	QueryParams cmdDateList;
	with(cmdDateList){
		args.length= 2;
		sqlCommand= `SELECT tr_id, tr_date, minutes, shop_name, direction, reference
			FROM list_of_trs
			WHERE tr_date >= to_date($1::text, 'YYYY-MM-DD')
				AND tr_date <= to_date($2::text, 'YYYY-MM-DD');`;

		args[0]= toValue(dateSt.toISOExtString);
		args[1]= toValue(dateSt.endOfMonth.toISOExtString);
	}

	/**
	 * id_spray, spray_date, crop_name, spray_type, amount_num, amount_unit
	 **/
	auto ans= conn.execParams(cmdDateList);

/**
 * year-month -> day -> transaction
 ***/

	{
		import dpq2.conv.time: binaryValueAs;
		import std.array: Appender, appender;
		import std.format: formattedWrite;
		TreeItem foo;
		Appender!string bufID;
		bufID.reserve(3);
		Appender!dstring bufLabel;

		foreach(scope row; ans.rangify){
			bufID= appender!string;
			bufLabel= appender!dstring;
			result ~= tuple!("id", "date")(row["tr_id"].as!int,
				row["tr_date"].binaryValueAs!Date);
			bufID.formattedWrite!"%d"(result[$-1].id);
			bufLabel.formattedWrite!"%s, %s"(result[$-1].date.toISOExtString,
				row["shop_name"].as!string);
			foo= tree.items.newChild(bufID.data, bufLabel.data, null);
		}
		tree.items.selectItem(foo);
	}
	return result;
}

/**************************************************************
 * list_of_trsおよびtax_trの中の指定されたidに対応する行の内容を取得
 **************************************************************/
void getTrContents(VerticalLayout layout, Connection conn, in int id) @system{
		import std.array: appender;
		import std.format: formattedWrite;
		import std.conv: dtext;

		QueryParams cmdTr, cmdTax, cmdRefFile;
		with(cmdTr){
			sqlCommand= `SELECT tr_date, minutes, shop_name, direction, reference
FROM list_of_trs
WHERE tr_id= $1::INTEGER;`;
			args.length= 1;
			args[0]= toValue(id);
		}

		with(cmdTax){
			sqlCommand= `SELECT tax_name, price, direction
FROM tax_tr
WHERE tr_id = $1::INTEGER;`;
			args.length= 1;
			args[0]= toValue(id);
		}

		auto ansTr= conn.execParams(cmdTr);
		auto ansTax= conn.execParams(cmdTax);

		{	// minutes
			auto temp= layout.childById!TextWidget("widget_1_20");
			if(ansTr[0]["minutes"].isNull){
				temp.text("-"d);
			}
			else{
				auto buf= appender!dstring;
				auto minutesPacked= ansTr[0]["minutes"].as!short;
				buf.formattedWrite!"%02d:%02d"d(minutesPacked/60, minutesPacked%60);
				temp.text(buf.data);
			}
		}

		// shop name
		{
			auto temp= layout.childById!TextWidget("widget_1_21");
			temp.text(ansTr[0]["shop_name"].as!string.dtext);
		}

		// type of transaction
		{
			auto temp= layout.childById!TextWidget("widget_1_22");
			temp.text(ansTr[0]["direction"].as!string.dtext);
		}

		// evidence files
		{
			import std.array: appender;
			import std.range: dropBackOne;
			auto temp= layout.childById!TextWidget("widget_1_24");
			if(ansTr[0]["reference"].isNull){
				temp.text("-"d);
			}
			else{
				typeof(appender!dstring()) buf;
				dstring dstr;
				const string[] refs= ansTr[0]["reference"].as!(string[]);
				temp.maxLines(cast(int)(refs.length));
				foreach(row; refs){
					buf= appender!dstring;

					buf.formattedWrite!"%s\n"d(row);
					dstr ~= buf.data;
				}
				temp.text(buf.data.dropBackOne);
			}
		}

		// tax
		{
			import std.array: appender;
			import std.range: dropBackOne;
			auto temp= layout.childById!TextWidget("widget_1_23");
			if(ansTax.length == 0){
				temp.text("-"d);
			}
			else{
				dstring dstr;
				temp.maxLines(cast(int)(ansTax.length));

				typeof(appender!dstring()) buf;
				foreach(row; ansTax.rangify){
					buf= appender!dstring;

					buf.formattedWrite!"%s: %s %s\n"d(
						row["direction"].as!string,
						row["tax_name"].as!string,
						row["price"].as!int);
					dstr ~= buf.data;
				}
				temp.text(dstr.dropBackOne);
			}
		}
}

/**
 * 店名を取得
 ***/
dstring getShopName(Connection conn, in int id) @system{
	import std.conv: dtext;
	QueryParams cmd;
	with(cmd){
		sqlCommand= `SELECT shop_name FROM list_of_trs WHERE tr_id = $1::INTEGER;`;
		args.length= 1;
		args[0]= toValue(cast(long)id);
	}
	auto ans= conn.execParams(cmd);
	return dtext(ans[0][0].as!string);
}

/**
 * 取引の方向を取得
 **/
dstring getDirection(Connection conn, in int id) @system{
	import std.algorithm: canFind;
	import std.conv: dtext;
	import std.range: front;

	QueryParams cmd;
	dstring result;
	with(cmd){
		sqlCommand= `SELECT direction FROM list_of_trs WHERE tr_id = $1::INTEGER;`;
		args.length= 1;
		args[0]= toValue(cast(long)id);
	}
	auto ans= conn.execParams(cmd);
	result= dtext(ans[0][0].as!string);
	assert(['I', 'O', 'T', 'S'].canFind(result[0]));
	return result;
}

/**
 * 領収書を取得
 ***/
dstring[] getRefFiles(Connection conn, in int id) @system{
	import std.conv: dtext;
	import std.algorithm: map;
	import std.array: array;
	QueryParams cmd;
	with(cmd){
		sqlCommand= `SELECT reference FROM list_of_trs WHERE tr_id = $1::INTEGER;`;
		args.length= 1;
		args[0]= toValue(cast(long)id);
	}
	auto ans= conn.execParams(cmd);
	const string[] temp= ans[0][0].as!(string[]);
	return temp.map!(a => dtext(a)).array;
	//return dtext(ans[0][0].as!string[]);
}
