/**
 * 出荷時の料金精算をaccount_voucherへ登録
 *
 *   "売掛金".debit= sale-(fees+fare+insurance)+insentive;
 *   "製品売上高".credit= sale
 *   "販売手数料".debit= fees
 *   "荷造運賃".debit= fare
 *   "共済掛金".debit= insurance
 *   "一般助成収入".credit= insentive
 *
 *   sale= 単価×個数
 *   fees= 農協手数料+市場手数料
 **/
