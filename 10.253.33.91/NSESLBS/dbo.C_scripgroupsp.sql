-- Object: PROCEDURE dbo.C_scripgroupsp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Procedure  C_scripgroupsp
@exchange Varchar(3),
@segment Varchar(20),
@scrip_cd Varchar(12),
@series Varchar(3),
@effdate  Varchar(11)

As

Select Distinct Group_code  From Groupmst Where Scrip_cd = @scrip_cd And Series Like @series + '%'
And Exchange = @exchange And Segment = @segment And Active = 1
And Effdate = (select Max(effdate) From Groupmst   Where Scrip_cd = @scrip_cd And Series Like @series + '%'
	         And Exchange = @exchange And Segment = @segment
	        And Effdate <= @effdate + ' 23:59:59' And Active = 1)

GO
