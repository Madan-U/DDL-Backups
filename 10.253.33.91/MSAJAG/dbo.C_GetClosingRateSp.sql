-- Object: PROCEDURE dbo.C_GetClosingRateSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






/* Used In the Collateral calculation control*/

CREATE PROCEDURE C_GetClosingRateSp
@Exchange varchar(3),
@Segment varchar(20),
@Scrip_cd varchar(12),
@Series varchar(3),
@Effdate varchar(11)
 
AS

select isnull(Cl_Rate,0) Cl_Rate From C_valuation where Scrip_Cd = @Scrip_cd  and series like @Series + '%'
and exchange = @Exchange and Segment = @Segment and
Sysdate = (Select max(sysdate) from c_valuation where sysdate <= @Effdate + '  23:59:59' and 
	   Scrip_Cd = @Scrip_cd  and series like  @Series + '%'
	   and exchange = @Exchange and Segment = @Segment)

GO
