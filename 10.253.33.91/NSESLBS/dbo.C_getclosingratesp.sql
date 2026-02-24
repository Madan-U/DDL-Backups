-- Object: PROCEDURE dbo.C_getclosingratesp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Procedure C_getclosingratesp
@exchange Varchar(3),
@segment Varchar(20),
@scrip_cd Varchar(12),
@series Varchar(3),
@effdate Varchar(11)
 
As

Select Isnull(cl_rate,0) Cl_rate From C_valuation Where Scrip_cd = @scrip_cd  And Series Like @series + '%'
And Exchange = @exchange And Segment = @segment And
Sysdate = (select Max(sysdate) From C_valuation Where Sysdate <= @effdate + '  23:59:59' And 
	   Scrip_cd = @scrip_cd  And Series Like  @series + '%'
	   And Exchange = @exchange And Segment = @segment)

GO
