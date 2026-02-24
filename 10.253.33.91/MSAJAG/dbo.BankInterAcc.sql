-- Object: PROCEDURE dbo.BankInterAcc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BankInterAcc    Script Date: 5/5/01 2:51:55 PM ******/
/****** Object:  Stored Procedure dbo.BankInterAcc    Script Date: 3/21/01 12:50:00 PM ******/
/****** Object:  Stored Procedure dbo.BankInterAcc    Script Date: 20-Mar-01 11:38:43 PM ******/
/****** Object:  Stored Procedure dbo.BankInterAcc    Script Date: 2/5/01 12:06:07 PM ******/
/****** Object:  Stored Procedure dbo.BankInterAcc    Script Date: 12/27/00 8:59:05 PM ******/
CREATE PROC BankInterAcc  As
select '904',O.CltAccNo,isin,Qty=qty*1000,S.MARKETTYPE,S.sett_no,date,
cltdpno = IsNull(CltDpNo,''),BankDpId = isnull(BankId,''),scrip_cd,s.sett_type from DematIntimate c,SETT_MST S,Owner O
where isin like 'IN%' AND S.SETT_NO = C.SETT_NO 
AND S.SETT_TYPE = C.SETT_TYPE and cltdpno <> ''

GO
