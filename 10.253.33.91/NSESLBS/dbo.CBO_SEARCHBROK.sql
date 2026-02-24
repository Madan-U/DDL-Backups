-- Object: PROCEDURE dbo.CBO_SEARCHBROK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_SEARCHBROK
AS
select distinct(upper(brok))as Brok from broktablevalues order by 1

GO
