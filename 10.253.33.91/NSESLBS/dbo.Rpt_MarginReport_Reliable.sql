-- Object: PROCEDURE dbo.Rpt_MarginReport_Reliable
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE  Procedure Rpt_MarginReport_Reliable 
(	
	@MarginDate Varchar(11),
	@FromParty Varchar(10),
	@ToParty Varchar(10)
) 

AS

set transaction isolation level read uncommitted

select
	Party_Code,
	Short_Name,
	Margindate,
	Billamount,
	Ledgeramount,
	Cash_Coll,
	Noncash_Coll,
	Initialmargin,	
	Mtmmargin,
	RMSExcessAmount,
	ShortFallMargin,
	ShortFallMarginAdjustedNSE,
	ShortFallMarginAdjustedBSE,
	ShortFallMarginAdjustedPOA 

from
	FoClientmarginReliable (nolock)
where
	Left(MarginDate,11) = @MarginDate
	and Party_Code Between @FromParty And @ToParty
Order By
	Party_Code

GO
