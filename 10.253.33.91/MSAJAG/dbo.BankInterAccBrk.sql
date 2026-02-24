-- Object: PROCEDURE dbo.BankInterAccBrk
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BankInterAccBrk    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BankInterAccBrk    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BankInterAccBrk    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BankInterAccBrk    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.BankInterAccBrk    Script Date: 12/27/00 8:59:05 PM ******/


/****** Object:  Stored Procedure dbo.BankInterAccBrk    Script Date: 12/29/2000 9:47:05 AM ******/
CREATE PROC BankInterAccBrk As
select '904',O.CltAccNo,isin,Qty=qty*1000,S.MARKETTYPE,S.sett_no,date,
cltdpno = IsNull(CltDpNo,''),BankDpId = isnull(BankId,''),scrip_cd,s.sett_type from DematIntimateBrk c,SETT_MST S,Owner O
where isin like 'IN%' AND S.SETT_NO = C.SETT_NO and c.foliono = 'Inter'
AND S.SETT_TYPE = C.SETT_TYPE and cltdpno <> ''
union all
select '904',O.CltAccNo,isin,Qty=qty*1000,S.MARKETTYPE,S.sett_no,date,
cltdpno = IsNull(CltDpNo,''),BankDpId = isnull(BankId,''),scrip_cd,s.sett_type from DematIntimateBrk c,SETT_MST S,Owner O
where isin like 'IN%' AND S.SETT_NO = C.SETT_NO and c.foliono = 'Trans'
AND S.SETT_TYPE = C.SETT_TYPE  and cltdpno <> ''
order by scrip_cd,s.sett_no,s.sett_type,Cltdpno

GO
