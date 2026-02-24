-- Object: PROCEDURE dbo.Usp_Rpt_Ledger_Fund_Archival
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--[10.253.33.239].accountncdx.dbo.ledger  
--[10.253.33.240].accountncdx.dbo.ledger  

CREATE Procedure [dbo].[Usp_Rpt_Ledger_Fund_Archival]  
 --- Usp_Rpt_Ledger_Fund 'S194675','2022-2023'
(  

 @Party_Code Varchar(100),  
 @FinYear Varchar(200)  

)  
as  
begin   
/*  

EXEC Usp_Rpt_Ledger_Fund @Party_Code='S194675',@FinYear='2021-2022'  
EXEC Usp_Rpt_Ledger_Fund @Party_Code='S194675',@FinYear='2021-2022'  
EXEC Usp_Rpt_Ledger_Fund_Archival @Party_Code='Y9901',@FinYear='2019-2020'  

*/  
--Declare @Date varchar(100)='2020-2022',  

Declare @FromDate Datetime,@ToDate Datetime  
select @FromDate=LEFT(@FinYear, 4) + '-04-01 00:00:00' ,@ToDate=RIGHT(@FinYear, 4) + '-03-31 23:59:59'   


  Print @fromdate
  print @todate
  
select * into #led2 from (  
select exchange='NSECM',vdt,edt,vtyp,cltcode,drcr,narration,Vamt =(case when drcr='C' then vamt else vamt*-1 end) 
from [10.253.33.239].account.dbo.ledger  
where cltcode =@Party_Code and vdt >=@FromDate and vdt <=@ToDate and vtyp in ('2','3','17','16')-- '15','18'  

--union all  ---NO table in archival server

--select  'MFBSE' EXCHANGE,VDT ,EDT ,'', CLTCODE,Case when DRAMOUNT=0.0000 Then 'D' ELSE 'C' END drcr,NARRATION , Case when DRAMOUNT=0.0000 Then CRAMOUNT*-1 ELSE DRAMOUNT END drcr   
--from [10.253.33.239].bbo_fa.dbo.MFSS_LEDGER_BSE   
--where cltcode =@Party_Code and vdt >=@FromDate and vdt <=@ToDate and vtype in ('2','3','17','16')  

UNION All   

select exchange='BSECM',vdt,edt,vtyp,cltcode,drcr,narration,Vamt =(case when drcr='C' then vamt else vamt*-1 end)  
from [10.253.33.239].account_ab.dbo.ledger  
where cltcode =@Party_Code and vdt >=@FromDate and vdt <=@ToDate and vtyp in ('2','3','17','16')  
  
union all  

select exchange='MTF',vdt,edt,vtyp,cltcode,drcr,narration,Vamt =(case when drcr='C' then vamt else vamt*-1 end)  
from [10.253.33.239].mtftrade.dbo.ledger  
where cltcode =@Party_Code and  vdt >=@FromDate and vdt <=@ToDate and vtyp in ('2','3','17','16')  

union all  

select exchange='NSEFO',vdt,edt,vtyp,cltcode,drcr,narration,Vamt =(case when drcr='C' then vamt else vamt*-1 end)  
from [10.253.33.239].accountfo.dbo.ledger  
where cltcode =@Party_Code and vdt >=@FromDate and vdt <=@ToDate and vtyp in ('2','3','17','16')  

union all  

select exchange='NSX',vdt,edt,vtyp,cltcode,drcr,narration,Vamt =(case when drcr='C' then vamt else vamt*-1 end) 
from [10.253.33.239].accountcurfo.dbo.ledger  
where cltcode =@Party_Code and vdt >=@FromDate and vdt <=@ToDate and vtyp in ('2','3','17','16')  

union all  

select exchange='MCX',vdt,edt,vtyp,cltcode,drcr,narration,Vamt =(case when drcr='C' then vamt else vamt*-1 end)  
from [10.253.33.240].accountmcdx.dbo.ledger  
where cltcode =@Party_Code and vdt >=@FromDate and vdt <=@ToDate and vtyp in ('2','3','17','16')  

union all  

select exchange='NCDX',vdt,edt,vtyp,cltcode,drcr,narration,Vamt =(case when drcr='C' then vamt else vamt*-1 end)  
from [10.253.33.240].accountncdx.dbo.ledger  
where cltcode =@Party_Code and vdt >=@FromDate and vdt <=@ToDate and vtyp in ('2','3','17','16')  
  
) v  

select   
exchange ,vdt ,edt ,cltcode ,drcr ,narration ,Vamt  
 from #led2  
order by vdt  

 END

GO
