-- Object: PROCEDURE dbo.BankDetDrCrSpP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BankDetDrCrSpP    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BankDetDrCrSpP    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BankDetDrCrSpP    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BankDetDrCrSpP    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.BankDetDrCrSpP    Script Date: 12/27/00 8:58:43 PM ******/

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
