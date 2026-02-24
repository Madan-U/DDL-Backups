-- Object: PROCEDURE dbo.fotrdinsertsett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fotrdinsertsett    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.fotrdinsertsett    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.fotrdinsertsett    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.fotrdinsertsett    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE proc fotrdinsertsett 
	(@contractno varchar(14),
	 @party_code varchar(10),
	 @symbol varchar(12),
	 @insttype varchar(6),
	 @expirydate varchar(11),
	 @strikeprice money,
	 @optiontype varchar(2),
	 @settno  varchar(10),
  	 @setttype  varchar(3),
  	 @clrate money)as

 /*Used in NSE FO */ 
 /*Control Name :FoImportTrade Module Name :CmdContract_Click()*/
 /*table Used : write  only :fosettlement . View Used : foconfirmview*/
 /*Function:This is used to insert records in fosettlement*/
 /*Written By :Ranjeet Choudhary */ 

insert into fosettlement
select @contractno,'0', Trade_no, party_code,
inst_type,symbol,sec_name,expirydate,strike_price,option_type,user_id ,pro_cli,o_c_flag,c_u_flag,tradeqty,
0,markettype,0, order_no,Price,
activitytime,Table_No,Line_No,Val_perc, Normal ,Day_puc, day_sales,
Sett_purch, Sett_sales, Sell_buy,settflag, Brokapplied,NetRate,
Amount, Ins_chrg,turn_tax,other_chrg,sebi_tax, Broker_chrg,Service_tax,
Trade_amount , 1 , @settno,
0 ,0 ,0, @setttype,@clrate
from foconfirmview
where party_code =@party_code
      and  symbol =@symbol
      and  Inst_type =@insttype
      and  left(convert(varchar,expirydate,105),11)=@expirydate
      and strike_price=@strikeprice
      and option_type=@optiontype

GO
