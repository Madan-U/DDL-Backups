-- Object: PROCEDURE dbo.BankInsAccClt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BankInsAccClt    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BankInsAccClt    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BankInsAccClt    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BankInsAccClt    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.BankInsAccClt    Script Date: 12/27/00 8:58:43 PM ******/

CREATE PROC BankInsAccClt (@Sett_no varchar(7),@sett_type varchar(2)) As
select '904','10001736',certno,qty,S.MARKETTYPE,S.sett_no,date,
cltdpno = IsNull(CltDpNo,''),BankDpId = isnull(BankId,'') from certinfo c,SETT_MST S,Client2 c2
where c.targetparty <> '1' and certno like 'IN%' AND S.SETT_NO = C.SETT_NO 
AND S.SETT_TYPE = C.SETT_TYPE and c2.party_code = c.party_code and 
targetparty not like '0%' and C.SETT_NO = @sETT_no AND C.SETT_TYPE = @SETT_TYPE
order by Certno,S.sett_no,qty

GO
