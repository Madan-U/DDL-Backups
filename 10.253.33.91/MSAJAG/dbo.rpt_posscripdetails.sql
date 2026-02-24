-- Object: PROCEDURE dbo.rpt_posscripdetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_posscripdetails    Script Date: 05/20/2002 5:24:32 PM ******/
/****** Object:  Stored Procedure dbo.rpt_posscripdetails    Script Date: 12/26/2001 1:23:39 PM ******/

/* 
report : position report 
file : scriptrans.asp
*/
/* shows details of  of a scrip for a settlement with albm effect */


CREATE PROCEDURE rpt_posscripdetails

@settno varchar(7),
@settype varchar(3),
@party varchar(10),
@scrip varchar(12),
@series varchar(3)

AS


select sett_no,sett_type,party_code,Scrip_Cd,series,pqty,pamt,sqty,samt,N_NetRate = NetRate,Sell_buy,
Sauda_date,User_id from postempsettsumexpdtl
where sett_no = @settno and sett_type = @settype and party_code = @party
and Scrip_Cd = @scrip and series = @series
union all
select sett_no,sett_type,party_code,Scrip_Cd,series,pqty,pamt,sqty,samt,N_NetRate=Rate,Sell_buy,
Sauda_date,User_id from posoppalbmexpdtl
where sett_no = @settno  and sett_type = @settype and party_code = @party
and Scrip_Cd = @scrip and series = @series
union all
select sett_no,sett_type,party_code,Scrip_Cd,series,pqty,pamt,sqty,samt,N_NetRate=NetRate,Sell_buy,
Sauda_date,User_id from posPlusOneAlbmExpdtl 
where sett_no = @settno and sett_type = @settype and party_code = @party
and Scrip_Cd = @scrip and series = @series
order by sauda_date

GO
