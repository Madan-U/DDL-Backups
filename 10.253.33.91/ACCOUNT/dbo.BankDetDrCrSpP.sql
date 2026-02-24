-- Object: PROCEDURE dbo.BankDetDrCrSpP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BankDetDrCrSpP    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.BankDetDrCrSpP    Script Date: 11/28/2001 12:23:40 PM ******/

/****** Object:  Stored Procedure dbo.BankDetDrCrSpP    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.BankDetDrCrSpP    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.BankDetDrCrSpP    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.BankDetDrCrSpP    Script Date: 7/8/01 3:22:47 PM ******/

/****** Object:  Stored Procedure dbo.BankDetDrCrSpP    Script Date: 2/17/01 3:34:13 PM ******/


/****** Object:  Stored Procedure dbo.BankDetDrCrSpP    Script Date: 20-Mar-01 11:43:32 PM ******/

/*this sp is used in bank detail printing to get total debit and credit*/
/*variable acname,enddate*/
CREATE PROCEDURE BankDetDrCrSpP 
@cltcode varchar(10),
@enddate varchar(11)
AS
  SELECT DISTINCT DEBIT=(SELECT SUM(L.VAMT)
 FROM LEDGER L WHERE L.DRCR='D' AND
 L.CLTCODE=@cltcode),     CREDIT=(SELECT SUM(L.VAMT) 
FROM LEDGER L WHERE L.DRCR='C' AND L.CLTCODE=@cltcode)
 FROM  ledger WHERE convert(varchar,vdt,101) <= @enddate and CLTCODE=@cltcode

GO
