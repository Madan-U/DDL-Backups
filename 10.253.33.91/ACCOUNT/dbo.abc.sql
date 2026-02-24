-- Object: PROCEDURE dbo.abc
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.abc    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE abc AS
SELECT DISTINCT "<option value=" +SUBSTRING(convert(varchar,sauda_date,109),1,11)+">" + SUBSTRING(convert(varchar,sauda_date,109),1,11)+"</option>"  FROM settlement 
union all
SELECT DISTINCT "<option value=" +SUBSTRING(convert(varchar,sauda_date,109),1,11)+">" + SUBSTRING(convert(varchar,sauda_date,109),1,11)+"</option>"  FROM history
order by "<option value=" +SUBSTRING(convert(varchar,sauda_date,109),1,11)+">" + SUBSTRING(convert(varchar,sauda_date,109),1,11)+"</option>"

GO
