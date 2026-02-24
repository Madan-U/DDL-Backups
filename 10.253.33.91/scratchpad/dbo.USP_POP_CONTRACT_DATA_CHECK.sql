-- Object: PROCEDURE dbo.USP_POP_CONTRACT_DATA_CHECK
-- Server: 10.253.33.91 | DB: scratchpad
--------------------------------------------------

    
CREATE PROCEDURE USP_POP_CONTRACT_DATA_CHECK ( @SAUDA_DATE VARCHAR(30) )    
AS    
BEGIN    
Select Sauda_date,exchange,segment,Sett_type,party_code_cnt=count(distinct party_code),tr_cnt=count(1)  Into #CCDCOUNT    
from MSAJAG.DBO.Common_contract_data (Nolock)    
where sauda_date >=@SAUDA_DATE and sauda_date <=CAST(@SAUDA_DATE + ' 23:59:59' AS DATETIME)  Group by Sauda_date,exchange,segment,Sett_type    
    
 Select Convert(varchar(11),Sauda_date,120)Sauda_date,Sett_type,party_code_cnt=count(distinct party_code),tr_cnt=count(1)  Into #NSECOUNT    
from MSAJAG.DBO.Settlement (Nolock)    
where sauda_date >=@SAUDA_DATE and sauda_date <=CAST(@SAUDA_DATE + ' 23:59:59' AS DATETIME) and marketrate <> 0 and auctionpart not like 'A%'    
Group by Convert(varchar(11),Sauda_date,120),Sett_type    
    
 Select Convert(varchar(11),Sauda_date,120)Sauda_date,Sett_type,party_code_cnt=count(distinct party_code),tr_cnt=count(1)  Into #BSECOUNT    
from angelbsecm.bsedb_ab.DBO.Settlement with(Nolock)    
where sauda_date >=@SAUDA_DATE and sauda_date <=CAST(@SAUDA_DATE + ' 23:59:59' AS DATETIME)   Group by Convert(varchar(11),Sauda_date,120),Sett_type    
     
 Select Convert(varchar(11),Sauda_date,120)Sauda_date,Sett_type='',party_code_cnt=count(distinct party_code),tr_cnt=count(1)  Into #NSEFOCOUNT    
from angelfo.nsefo.dbo.fosettlement with(Nolock)    
where sauda_date >=@SAUDA_DATE and sauda_date <=CAST(@SAUDA_DATE + ' 23:59:59' AS DATETIME)   and auctionpart<>'CA'  Group by Convert(varchar(11),Sauda_date,120)    
    
 Select Convert(varchar(11),Sauda_date,120)Sauda_date,Sett_type='',party_code_cnt=count(distinct party_code),tr_cnt=count(1)  Into #BSEFOCOUNT    
from angelcommodity.bsefo.dbo.bfosettlement with(Nolock)    
where sauda_date >=@SAUDA_DATE and sauda_date <=CAST(@SAUDA_DATE + ' 23:59:59' AS DATETIME)  and auctionpart<>'CA'  Group by Convert(varchar(11),Sauda_date,120)    
    
Alter table #CCDCOUNT    
Add Trade_Party_count int    
    
Update #CCDCOUNT Set  Trade_Party_count=#NSECOUNT.party_code_cnt    
from #NSECOUNT Where #NSECOUNT.Sett_type=#CCDCOUNT.Sett_type    
    
Update #CCDCOUNT Set  Trade_Party_count=#BSECOUNT.party_code_cnt    
from #BSECOUNT Where #BSECOUNT.Sett_type=#CCDCOUNT.Sett_type    
    
Update #CCDCOUNT Set  Trade_Party_count=#NSEFOCOUNT.party_code_cnt    
from #NSEFOCOUNT Where   exchange ='NSE' and Segment ='FUTURES' and #CCDCOUNT.sauda_date =@SAUDA_DATE
    
Update #CCDCOUNT Set  Trade_Party_count=#BSEFOCOUNT.party_code_cnt    
from #BSEFOCOUNT Where   exchange ='BSE' and Segment ='FUTURES' and #CCDCOUNT.sauda_date =@SAUDA_DATE
    
Select *, Diff =party_code_cnt - Trade_Party_count  from #CCDCOUNT    
    
   END

GO
