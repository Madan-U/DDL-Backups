-- Object: PROCEDURE dbo.rpt_fomodcollateral1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomodcollateral1    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodcollateral1    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodcollateral1    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodcollateral1    Script Date: 5/5/2001 1:24:14 PM ******/
CREATE PROCEDURE rpt_fomodcollateral1

@code varchar(10),
@sdate varchar(12)

AS


select distinct party_code , left(convert(varchar,sauda_date,109),11) from fosettlement
where party_code like ltrim(@code)+'%' 
and left(convert(varchar,sauda_date,109),11) = @sdate
order by party_code, left(convert(varchar,sauda_date,109),11)

GO
