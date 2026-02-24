-- Object: PROCEDURE dbo.EXCESS_PAYIN_DATA
-- Server: 10.253.33.91 | DB: scratchpad
--------------------------------------------------

CREATE PROCEDURE [dbo].[EXCESS_PAYIN_DATA]  
--Created this SP under ORE-4513
(  
@sett_no VARCHAR(10)  
)  
AS   
BEGIN   
  
Select party_code,scrip_cd,series,certno,sum(qty ) as pay_in_qty,Sett_no,sett_type  into #del1  from ANGELDEMAT.MSAJAG.DBO.deltrans where sett_no =@sett_no and drcr ='C'  and filler2=1
Group by party_code,scrip_cd,series,certno ,Sett_no,sett_type

Select party_code,scrip_cd,series,i_isin,sum(qty ) as pay_in_qty,Sett_no,sett_type  into #obl1  from ANGELDEMAT.MSAJAG.DBO.deliveryclt where sett_no =@sett_no   and inout='I'
Group by party_code,scrip_cd,series,i_isin,Sett_no,sett_type

Select *,Excess_qty= OBL_Qty- recd_qty into #Excess from (
Select Isnull(O.Party_code,d.Party_Code) as party_code,isnull(O.scrip_cd,d.scrip_cd)as scrip_cd,isnull(O.series,d.series) as series,isnull(certno,i_isin) as isin
,isnull(O.Sett_no,D.Sett_No) as sett_no ,isnull(O.Sett_Type,d.Sett_type) as sett_type
,isnull(o.pay_in_qty,0) as OBL_Qty,Isnull(d.pay_in_qty,0) as recd_qty
from #obl1 O
full outer join
#del1 d on O.Party_code=d.Party_Code and O.scrip_cd=d.scrip_cd and O.series=d.series  ) A where OBL_Qty <> recd_qty and party_code <>'NSE'
and OBL_Qty< recd_qty

select party_code,Scrip_cd,Series,ISIN,Sett_no,Sett_type,OBL_Qty,Recd_qty,Excess_qty from #excess


END

GO
