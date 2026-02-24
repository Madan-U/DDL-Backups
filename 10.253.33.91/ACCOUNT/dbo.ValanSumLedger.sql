-- Object: PROCEDURE dbo.ValanSumLedger
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ValanSumLedger    Script Date: 01/04/1980 1:40:44 AM ******/



/****** Object:  Stored Procedure dbo.ValanSumLedger    Script Date: 11/28/2001 12:23:53 PM ******/

/****** Object:  Stored Procedure dbo.ValanSumLedger    Script Date: 29-Sep-01 8:12:08 PM ******/

/****** Object:  Stored Procedure dbo.ValanSumLedger    Script Date: 8/8/01 1:37:34 PM ******/

/****** Object:  Stored Procedure dbo.ValanSumLedger    Script Date: 8/7/01 6:03:54 PM ******/

/****** Object:  Stored Procedure dbo.ValanSumLedger    Script Date: 7/8/01 3:22:52 PM ******/

/****** Object:  Stored Procedure dbo.ValanSumLedger    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.ValanSumLedger    Script Date: 20-Mar-01 11:43:37 PM ******/

CREATE PROCEDURE ValanSumLedger  
@settnotype varchar(12)
AS
select isnull(sum(vamt),0), drcr
 from ledger l , ledger3 l3 
where l.cltcode not in('99990' ,'61310', '99985' ,'99988','100')and
 l3.narr like @settnotype  and
 l3.refno = substring(l.refno, 1, 7) 
group by drcr
 order by drcr

GO
