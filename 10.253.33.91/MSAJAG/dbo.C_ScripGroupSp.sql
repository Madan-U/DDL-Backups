-- Object: PROCEDURE dbo.C_ScripGroupSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






/* */
CREATE PROCEDURE  C_ScripGroupSp
@Exchange varchar(3),
@Segment varchar(20),
@Scrip_Cd varchar(12),
@Series Varchar(3),
@EffDate  Varchar(11)

As

select distinct group_code  from groupmst where scrip_cd = @Scrip_Cd and series like @Series + '%'
and exchange = @Exchange and segment = @Segment and active = 1
and effdate = (select max(effdate) from groupmst   where scrip_cd = @Scrip_Cd and series like @Series + '%'
	         and exchange = @Exchange and segment = @Segment
	        and effdate <= @EffDate + ' 23:59:59' and active = 1)

GO
