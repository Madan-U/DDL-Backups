-- Object: PROCEDURE dbo.InsDematBrk
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.InsDematBrk    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.InsDematBrk    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.InsDematBrk    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.InsDematBrk    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.InsDematBrk    Script Date: 12/27/00 8:59:08 PM ******/


CREATE Proc InsDematBrk (@sett_no Varchar(7),@sett_type varchar(2),@Party varchar(10),@Scrip Varchar(12)) As
delete from dematintimateBrk 
insert into dematintimateBrk select sett_no,sett_type,party_code, isin,bankid,qty = Sum(qty),scrip_cd, series, cltdpno,short_name,date=getdate(),foliono,'' from PrintBankBrkSlip
where SETT_NO = @Sett_no AND SETT_TYPE = @Sett_type and
party_code like @Party+'%' and scrip_cd like @Scrip
group by sett_no,sett_type,party_code, isin,scrip_cd, series, cltdpno , Short_Name, bankid,foliono
order by scrip_cd

GO
