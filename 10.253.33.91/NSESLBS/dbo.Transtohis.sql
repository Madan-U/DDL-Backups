-- Object: PROCEDURE dbo.Transtohis
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.transtohis    Script Date: 01/15/2005 1:20:12 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.transtohis    Script Date: 12/16/2003 2:31:29 Pm ******/  
  
  
  
/****** Object:  Stored Procedure Dbo.transtohis    Script Date: 05/08/2002 12:35:25 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.transtohis    Script Date: 01/14/2002 20:33:25 ******/  
  
/****** Object:  Stored Procedure Dbo.transtohis    Script Date: 12/26/2001 1:23:59 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.transtohis    Script Date: 3/17/01 9:56:12 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.transtohis    Script Date: 3/21/01 12:50:33 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.transtohis    Script Date: 20-mar-01 11:39:11 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.transtohis    Script Date: 2/5/01 12:06:30 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.transtohis    Script Date: 12/27/00 8:59:17 Pm ******/  
/****** Object:  Stored Procedure Dbo.transtohis    Script Date: 1/12/01 9:25:14 Pm ******/  
Create Proc Transtohis (@settno Varchar(7),@sett_type Varchar(2)) As  
Begin  
Insert Into History Select Contractno,billno,trade_no,party_code,scrip_cd,user_id,tradeqty,auctionpart,markettype,series,order_no,marketrate,sauda_date,table_no,line_no,val_perc,normal,day_puc,day_sales,sett_purch,sett_sales,sell_buy,settflag,brokapplied,
netrate,amount,ins_chrg,turn_tax,other_chrg,sebi_tax,broker_chrg,service_tax,trade_amount,billflag,sett_no,nbrokapp,nsertax,n_netrate,sett_type,partipantcode,status,pro_cli,cpid,instrument,booktype,branch_id,tmark,scheme,dummy1,dummy2  
From Settlement Where Billno <> '0' And Sett_no = @settno And Sett_type = @sett_type  
 /*modified By Sheetal  23/10/2000  To Remove The Duplicate Insertion Of Records*/  
/*execute Insproc @settno,@sett_type  */      
/*execute Delproc @settno,@sett_type*/  
Delete From Settlement Where Billno <> '0' And Sett_no = @settno And Sett_type = @sett_type  
Execute Insproc @settno,@sett_type  
Execute Delproc @settno,@sett_type  
End

GO
