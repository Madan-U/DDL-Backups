-- Object: PROCEDURE dbo.BankInsAccNse
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BankInsAccNse    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BankInsAccNse    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BankInsAccNse    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BankInsAccNse    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.BankInsAccNse    Script Date: 12/27/00 8:58:43 PM ******/

CREATE PROC BankInsAccNse (@Sett_no varchar(7),@sett_type varchar(2)) As
select distinct '906','10001736',CertNo,qty,MARKETTYPE,s.sett_no,date,cltdpno='00000000',dpid='00000000' from certinfo c, sett_mst s
where c.targetparty <> '1' and certno like 'IN%' and targetparty like '0%'
AND S.SETT_NO = C.SETT_NO AND S.SETT_TYPE = C.SETT_tYPE 
AND C.SETT_NO = @sETT_nO AND C.SETT_TYPE = @SETT_TYPE
order by CertNo,s.sett_no,qty

GO
