-- Object: PROCEDURE dbo.GetSlipNo
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.GetSlipNo    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.GetSlipNo    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.GetSlipNo    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.GetSlipNo    Script Date: 09/21/2001 2:39:21 AM ******/

/****** Object:  Stored Procedure dbo.GetSlipNo    Script Date: 09/20/2001 6:05:56 AM ******/


/****** Object:  Stored Procedure dbo.GetSlipNo    Script Date: 7/1/01 2:19:43 PM ******/

/****** Object:  Stored Procedure dbo.GetSlipNo    Script Date: 06/28/2001 5:44:43 PM ******/

/****** Object:  Stored Procedure dbo.GetSlipNo    Script Date: 20-Mar-01 11:43:33 PM ******/

/*
control name  : BankSlipPrintCtl
Use : To get all slip Numbers  from slipreceipt in order to print slip receipt
Written by : Kalpana
Date : 15/02/2001
*/
CREATE PROCEDURE  GetSlipNo
@cltcode varchar(10),
@flag integer
AS
/*
select distinct convert(integer,slipno) slipno from slipreceipt order by slipno 
*/

if @flag = 1
begin
	select distinct slipno from ledger l, slipreceipt s
	where s.vtyp = l.vtyp and s.vno = l.vno
	and l.vtyp in (2,19) and l.cltcode =@cltcode
	order by slipno
end
else
begin
	select distinct convert(varchar,sdate,103)  slipdate from ledger l, slipreceipt s
	where s.vtyp = l.vtyp and s.vno = l.vno
	and l.vtyp in (2,19) and l.cltcode =@cltcode
	order by convert(varchar,sdate,103)
end

GO
