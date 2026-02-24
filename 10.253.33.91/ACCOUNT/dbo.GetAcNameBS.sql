-- Object: PROCEDURE dbo.GetAcNameBS
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.GetAcNameBS    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.GetAcNameBS    Script Date: 11/28/2001 12:23:43 PM ******/

/****** Object:  Stored Procedure dbo.GetAcNameBS    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.GetAcNameBS    Script Date: 09/21/2001 2:39:21 AM ******/


/****** Object:  Stored Procedure dbo.GetAcNameBS    Script Date: 7/1/01 2:19:42 PM ******/

/****** Object:  Stored Procedure dbo.GetAcNameBS    Script Date: 06/28/2001 5:44:43 PM ******/

/****** Object:  Stored Procedure dbo.GetAcNameBS    Script Date: 20-Mar-01 11:43:33 PM ******/

/*
control name  : BankSlipPrintCtl
Use : To get all acname and cltcode  from acmast in order to print slip receipt
Written by : Kalpana
Date : 15/02/2001
*/
CREATE PROCEDURE GetAcNameBS
AS
select cltcode, acname from acmast where accat = '2' order by acname ,cltcode

GO
