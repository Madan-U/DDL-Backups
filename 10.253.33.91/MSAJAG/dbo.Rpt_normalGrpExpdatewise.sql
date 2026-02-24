-- Object: PROCEDURE dbo.Rpt_normalGrpExpdatewise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.Rpt_normalGrpExpdatewise    Script Date: 04/27/2001 4:32:47 PM ******/
CREATE  PROCEDURE  Rpt_normalGrpExpdatewise


@fdate   varchar(25),
@tdate varchar(25),
@settype varchar(3),
@settno varchar(7),
@code varchar(10)

as

delete from RptGrpExpdatewise 
insert into RptGrpExpdatewise 
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt,sauda_date from tempsettsumExpdatewise 
where sauda_date  >= @fdate 
and sauda_date <= @tdate +  ' 23:59:59'  and 
sett_type like (case when  ltrim(@settype)='%' then '%' else ltrim(@settype) end   ) and 
sett_no like (case when  ltrim(@settno)='%' then '%' else ltrim(@settno) end   ) 
and party_code like ltrim(@code)+'%'

GO
