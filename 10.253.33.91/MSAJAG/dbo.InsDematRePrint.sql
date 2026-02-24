-- Object: PROCEDURE dbo.InsDematRePrint
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc InsDematRePrint (@SlipNo Numeric(18,0)) As
insert into dematintimate 
select sett_no,sett_type,party_code, isin,bankid,qty = Sum(qty),scrip_cd,
series, cltdpno,short_name,date=getdate(),TrType,trader,SlipNo from InsDematInti
where SlipNo = @SlipNo
group by sett_no,sett_type,party_code, isin,scrip_cd, series, cltdpno , Short_Name, bankid,TrType,trader,SlipNo

GO
