-- Object: PROCEDURE dbo.USP_ANGEL_CLIENTMASTER
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Procedure USP_ANGEL_CLIENTMASTER(@date varchar(11),@access_to varchar(20),@access_code varchar(20))  
as  
/*  
Author  :  Renil R Pillai [E10398]  
User  :  Sachin Rahate  
User Dept :  Surviellance  
Created Date:  March 17 2010    
*/  

select @date=convert(varchar(11),Convert(datetime,@date,103),106)  
  
--select distinct cl_code into #partycode from client_brok_details(nolock) where convert(varchar(11),Active_Date,106)=@date  
--  
--select cl_code,Exchange=EXCHANGE+SEGMENT,Active_Date into #segmentdetails from client_brok_details(nolock) where   
--cl_code in (select cl_code from #partycode)  
--  
--SELECT cl_code,BSECAPITAL,NSECAPITAL,NSEFUTURES,MCXFUTURES,NCXFUTURES,NSXFUTURES,MCDFUTURES  into #seg1 FROM   
--(SELECT cl_code,Exchange,Active_Date  FROM  #segmentdetails(nolock))sa   
--PIVOT  
--(max(Active_Date  )FOR Exchange IN(BSECAPITAL,NSECAPITAL,NSEFUTURES,MCXFUTURES,NCXFUTURES,NSXFUTURES,MCDFUTURES) ) AS pvt  
--  
--  
--  
--select cl_code,  
--BSECAPITAL=case  
--when Convert(datetime,Convert(varchar(11),BSECAPITAL,106),103)=Convert(datetime,@date,103) then 'NEW'  
--when Convert(datetime,Convert(varchar(11),BSECAPITAL,106),103)=Convert(datetime,@date,103) then 'Yes'  
--else 'NO' end,  
--NSECAPITAL=case  
--when Convert(datetime,Convert(varchar(11),NSECAPITAL,106),103)=Convert(datetime,@date,103) then 'NEW'  
--when Convert(datetime,Convert(varchar(11),NSECAPITAL,106),103)=Convert(datetime,@date,103) then 'Yes'  
--else 'NO' end,  
--NSEFUTURES=case  
--when Convert(datetime,Convert(varchar(11),NSEFUTURES,106),103)=Convert(datetime,@date,103) then 'NEW'  
--when Convert(datetime,Convert(varchar(11),NSEFUTURES,106),103)=Convert(datetime,@date,103) then 'Yes'  
--else 'NO' end,  
--MCXFUTURES=case  
--when Convert(datetime,Convert(varchar(11),MCXFUTURES,106),103)=Convert(datetime,@date,103) then 'NEW'  
--when Convert(datetime,Convert(varchar(11),MCXFUTURES,106),103)=Convert(datetime,@date,103) then 'Yes'  
--else 'NO' end,  
--NCXFUTURES=case  
--when Convert(datetime,Convert(varchar(11),NCXFUTURES,106),103)=Convert(datetime,@date,103) then 'NEW'  
--when Convert(datetime,Convert(varchar(11),NCXFUTURES,106),103)=Convert(datetime,@date,103) then 'Yes'  
--else 'NO' end,  
--NSXFUTURES=case  
--when Convert(datetime,Convert(varchar(11),NSXFUTURES,106),103)=Convert(datetime,@date,103) then 'NEW'  
--when Convert(datetime,Convert(varchar(11),NSXFUTURES,106),103)=Convert(datetime,@date,103) then 'Yes'  
--else 'NO' end,  
--MCDFUTURES=case  
--when Convert(datetime,Convert(varchar(11),MCDFUTURES,106),103)=Convert(datetime,@date,103) then 'NEW'  
--when Convert(datetime,Convert(varchar(11),MCDFUTURES,106),103)=Convert(datetime,@date,103) then 'Yes'  
--else 'NO' end into #finalsegment  
-- from #seg1  
--  
--select [Party Code]=PARTY_CODE,[Party Name]=Short_Name,[Branch Code]=BRANCH_CD,  
--[Sub Broker Code]=SUB_BROKER,TRADER,IMP_STATUS = 'NEW',  
--BSECAPITAL,NSECAPITAL,NSEFUTURES,MCXFUTURES,NCXFUTURES--,NSXFUTURES,MCDFUTURES  
-- from #finalsegment a inner join client_details(nolock) b on a.cl_code=b.party_code  


select a.*,b.reg_no into #tye from intranet.[CTCL1.1].dbo.OfflinecltMapdet_temp as a                     
join dbo.SubBrokers as b                    
on a.sbbroker=b.sub_broker /*and a.branchcode not in (select brcode from blockedbr)*/
  

select [Party Code]=partcode,[Party Name]=partyname,[Branch Code]=branchcode,  
[Sub Broker Code]=sbbroker,IMP_STATUS = 'NEW',  
BSECAPITAL=bse,NSECAPITAL=nse,NSEFUTURES=fo,MCXFUTURES=mcx,NCXFUTURES=ncdx,[kyc code]=ctcl_odinid
--,NSXFUTURES,MCDFUTURES  
 from #tye

select * from #tye

GO
