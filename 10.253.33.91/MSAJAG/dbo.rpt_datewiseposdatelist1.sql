-- Object: PROCEDURE dbo.rpt_datewiseposdatelist1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_datewiseposdatelist1    Script Date: 04/27/2001 4:32:38 PM ******/

/*gives us the dates for selected settno and type*/

CREATE PROCEDURE rpt_datewiseposdatelist1
@settype varchar(3),
@settno varchar(7)
AS
select distinct left(convert(varchar,sauda_date,109),11) 
from settlement 
where sett_type like ltrim(@settype)+'%'
and sett_no like ltrim(@settno)+'%'
order by left(convert(varchar,sauda_date,109),11)

GO
