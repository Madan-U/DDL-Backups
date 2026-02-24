-- Object: PROCEDURE dbo.PROC_ALL_SETTMASTFLAG
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

CREATE PROCEDURE [dbo].[PROC_ALL_SETTMASTFLAG] (@RUNDATE VARCHAR(11),@REPORT VARCHAR(10))        
        
AS  --- EXEC PROC_ALL_REPORT_STATUS 'SEP 12 2022'        
    select  sett_type,party_code,scrip_cd ,pos=sum(case when Sell_buy=1 Then Tradeqty else Tradeqty*-1 end)
 from MSAJAG..settlement with (Nolock) where sauda_date >=cast(getdate() as date)
 and Settflag in (2,3)
 group by sett_type,party_code,scrip_cd
 Having sum(case when Sell_buy=1 Then Tradeqty else Tradeqty*-1 end) <>0

GO
