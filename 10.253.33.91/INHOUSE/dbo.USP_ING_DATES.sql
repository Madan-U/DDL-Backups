-- Object: PROCEDURE dbo.USP_ING_DATES
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE proc USP_ING_DATES --'05/05/2001','C'  
(  
@date varchar(11),  
@type varchar(5)  
)  
as  
SET NOCOUNT ON   
  
select  convert(varchar(11),funds_payout,103) as Payout_date,convert(varchar(11),sec_payout,103) as Sec_delvDate  
from msajag.dbo.sett_mst(nolock) where convert(varchar(11),start_date,103)=@date and sett_type=@type

GO
