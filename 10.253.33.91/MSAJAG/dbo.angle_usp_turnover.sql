-- Object: PROCEDURE dbo.angle_usp_turnover
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc [dbo].[angle_usp_turnover]    
 @branch as varchar(20),    
 @segment as varchar(20),    
 @fdate as varchar(20),    
 @sdate as varchar(20)    
    
as    
 set nocount on     
   
select  * into  #bran from intranet.bsedb_ab.dbo.mis_to where sauda_date between @fdate and @sdate    
and branch_cd = @branch and company  = @segment and turnover >= 100000      
    
select Party_code,Details=convert(varchar,Sauda_date,103)+' '+Scrip_Name+' '+    
' Buy Qty: '+convert(varchar,sum(PQtyTrd+PqtyDel))+    
' Sell Qty: '+convert(varchar,sum(SQtyTrd+SqtyDel))+    
' Buy Value: '+convert(varchar,sum(PAmtTrd+pamtdel))+    
' Sell Value: '+convert(varchar,sum(SAmtTrd+Samtdel))    
into #partydetail     
from  AngelNseCM.msajag.dbo.cmbillvalan where Branch_cd = @branch and     
Sauda_date between @fdate and @sdate     
and party_code collate Latin1_General_CI_AS in (Select party_code from #bran)    
Group by Party_code,Sauda_date,Scrip_cd,Scrip_Name      
    
select Distinct a.Party_code,b.long_name,a.Turnover,    
Address1=b.l_address1,Address2=b.l_address2+b.l_address3,Address3=b.l_city,PIN=b.l_zip,    
Pan_No=b.pan_gir_no,Bank_Ac_No = b.Bank_Name + ',' +  b.AC_Type + ',' + b.AC_Num,    
Share_details = space(200),b.DpId1,b.CltDpId1,DMAT_AC = ' ',b.sebi_regn_no,Payment_Mode=' ',REMARKS = ' '    
into #detail    
from #bran a left outer join intranet.risk.dbo.client_details  b     
on a.party_code collate SQL_Latin1_General_CP1_CI_AS = b.cl_code     
    
    
select party_Code,long_name,Address1,Address2,Address3,PIN,PAN_no,Bank_Ac_no,Share_details=space(200),DPid1,CLTdpid1,    
Dmat_Ac,sebi_Regn_no,Payment_mode,remarks     
into #detail1    
from #detail     
group by     
party_Code,long_name,Address1,Address2,Address3,PIN,PAN_no,Bank_Ac_no,DPid1,CLTdpid1,    
Dmat_Ac,sebi_Regn_no,Payment_mode,remarks     
  
update #detail1 set share_Details = b.details from #partydetail b where     
#detail1.party_Code collate SQL_Latin1_General_CP1_CI_AS = b.party_Code     
  
update #detail1 set bank_ac_no = ' ' where left(bank_ac_no,7) = 'UNKNOWN'  
    
select * from #detail1    
  
set nocount off

GO
