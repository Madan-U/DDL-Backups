-- Object: PROCEDURE dbo.rpt_datewiseposdatelist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_datewiseposdatelist    Script Date: 04/27/2001 4:32:38 PM ******/

CREATE PROCEDURE rpt_datewiseposdatelist

@settype varchar(3),
@settno varchar(7)

AS

select distinct left(convert(varchar,sauda_date,109),11) 
from settlement 
where sett_type like ltrim(@settype)+'%'
and sett_no like ltrim(@settno)+'%'
union 
select distinct left(convert(varchar,sauda_date,109),11) 
from history
where sett_type like   ltrim(@settype)  + '%'
and sett_no  like  ltrim(@settno)+'%'
union 
select distinct left(convert(varchar,sauda_date,109),11) 
from history
where sett_type like   'L'
and sett_no  like  ( SELECT MIN(SETT_NO) FROM SETT_MST WHERE SETT_NO > ltrim(@settno)+'%' AND SETT_TYPE = 'N')
union 
select distinct left(convert(varchar,sauda_date,109),11) 
from SETTLEMENT
where sett_type like   'L'
and sett_no  like  ( SELECT MIN(SETT_NO) FROM SETT_MST WHERE SETT_NO > ltrim(@settno)+'%' AND SETT_TYPE = 'N')
order by left(convert(varchar,sauda_date,109),11)

GO
