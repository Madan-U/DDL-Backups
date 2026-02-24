-- Object: PROCEDURE dbo.InsDemat
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.InsDemat    Script Date: 05/08/2002 12:35:04 PM ******/

/****** Object:  Stored Procedure dbo.InsDemat    Script Date: 01/14/2002 20:32:44 ******/






/****** Object:  Stored Procedure dbo.InsDemat    Script Date: 5/5/01 2:52:03 PM ******/
/****** Object:  Stored Procedure dbo.InsDemat    Script Date: 3/21/01 12:50:09 PM ******/
/****** Object:  Stored Procedure dbo.InsDemat    Script Date: 20-Mar-01 11:38:51 PM ******/
/****** Object:  Stored Procedure dbo.InsDemat    Script Date: 2/5/01 12:06:14 PM ******/
/****** Object:  Stored Procedure dbo.InsDemat    Script Date: 12/27/00 8:59:07 PM ******/
CREATE Proc InsDemat (@sett_no Varchar(7),@sett_type varchar(2),@Party varchar(10),@Trader Varchar(15),@Scrip Varchar(12),@RefNo int,@Slipno numeric(18,0),@TDate Varchar(11)) As
insert into dematintimate 
select sett_no,sett_type,party_code, isin,bankid,qty = Sum(qty),scrip_cd,
series, cltdpno,short_name,date=@TDate,TrType,trader,@SlipNo from InsDematInti
where SETT_NO = @Sett_no AND SETT_TYPE = @Sett_type and
trader like @Trader +'%' and party_code like @Party+'%' and scrip_cd like @Scrip+'%'  and SlipNo = 0 and RefNo = @RefNo
group by sett_no,sett_type,party_code, isin,scrip_cd, series, cltdpno , Short_Name, bankid,TrType,trader

GO
