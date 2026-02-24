-- Object: PROCEDURE dbo.BankTransAcc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BankTransAcc    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BankTransAcc    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BankTransAcc    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BankTransAcc    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.BankTransAcc    Script Date: 12/27/00 8:59:05 PM ******/

CREATE PROC BankTransAcc As
select '904',O.CltAccNo,isin,Qty=qty*1000,S.MARKETTYPE,S.sett_no,date,
cltdpno = IsNull(CltDpNo,''),BankDpId = isnull(BankId,'') from DematIntimate c,SETT_MST S,Owner O
where isin like 'IN%' AND S.SETT_NO = C.SETT_NO and c.foliono = 'Trans'
AND S.SETT_TYPE = C.SETT_TYPE  and cltdpno <> ''
order by scrip_cd,cltdpno

GO
