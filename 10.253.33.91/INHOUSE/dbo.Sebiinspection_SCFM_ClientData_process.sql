-- Object: PROCEDURE dbo.Sebiinspection_SCFM_ClientData_process
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------


--exec Sebiinspection_SCFM_ClientData_process '2015-04-01 00:00:00.000','2015-04-01 23:59:59.000'
 CREATE Procedure [dbo].[Sebiinspection_SCFM_ClientData_process]
 (
 @sdtcur as datetime,
 @ToDate as datetime 
 )
 as
 set nocount on 
 set transaction isolation level read uncommitted
 
 /*BSECM*/
 select CLTCODE,            
  VBal=sum(case when drcr='D' then -VAMT else VAMT end),                   
  UCV=sum(Case when edt > @Todate and Drcr='C' then Vamt else 0 end),                  
  UDV=sum(Case when edt > @Todate and Drcr='D' then Vamt else 0 end)            
  into #BSECM            
  from AngelBSECM.account_ab.dbo.ledger a with (nolock)                   
  where vDT>=@sdtcur and eDT <= @ToDate       
  and cltcode between 'a' and 'zzzz9999'           
  group by cltcode                
             
  
  select x.CLTCODE,x.VDT,UCV=y.relamt,y.reldt,UDV=0   into #BSECMe    from 
  (select * from 
  AngelBSECM.account_ab.dbo.ledger a with (nolock)                   
  where vDT>= @sdtcur and edt  <= @ToDate and cltcode between 'a' and 'zzzz9999')x inner join 
  (
  select * from 
  AngelBSECM.account_ab.dbo.ledger1 a with (nolock)                   
  where dddt >=@sdtcur 
  )y on x.vno=y.vno and x.VDT=y.dddt and x.BALAMT=y.relamt
   and (y.reldt>x.VDT or y.reldt='1900-01-01 00:00:00.000')
               
               
 /*NSECM*/            
  select CLTCODE,            
  VBal=sum(case when drcr='D' then -VAMT else VAMT end),                   
  UCV=sum(Case when edt > @Todate and Drcr='C' then Vamt else 0 end),                  
  UDV=sum(Case when edt > @Todate and Drcr='D' then Vamt else 0 end)            
  into #NSECM            
  from AngelNseCM.account.dbo.ledger a with (nolock)                   
  where vDT>=@sdtcur and eDT <= @ToDate and cltcode between 'a' and 'zzzz9999'                 
  group by cltcode                
             
  
  select x.CLTCODE,x.VDT,UCV=y.relamt,y.reldt,UDV=0   into #NSECMe    from 
  (select * from 
  AngelNseCM.account.dbo.ledger a with (nolock)                   
  where vDT>= @sdtcur and edt  <= @ToDate and cltcode between 'a' and 'zzzz9999')x inner join 
  (
  select * from 
  AngelNseCM.account.dbo.ledger1 a with (nolock)                   
  where dddt >=@sdtcur 
  )y on x.vno=y.vno and x.VDT=y.dddt and x.BALAMT=y.relamt
   and (y.reldt>x.VDT or y.reldt='1900-01-01 00:00:00.000')
              
             
  /*NSEFO*/             
  select CLTCODE,            
  VBal=sum(case when drcr='D' then -VAMT else VAMT end),                   
  UCV=sum(Case when edt > @Todate and Drcr='C' then Vamt else 0 end),                  
  UDV=sum(Case when edt > @Todate and Drcr='D' then Vamt else 0 end)            
  into #NSEFO            
  from angelfo.accountfo.dbo.ledger a with (nolock)                   
  where vDT>=@sdtcur and eDT <= @ToDate  and cltcode between 'a' and 'zzzz9999'                
  group by cltcode                
               
  select x.CLTCODE,x.VDT,UCV=y.relamt,y.reldt,UDV=0   into #NSEFOe    from 
  (select * from 
  angelfo.accountfo.dbo.ledger a with (nolock)                   
  where vDT>= @sdtcur and edt  <= @ToDate and cltcode between 'a' and 'zzzz9999')x inner join 
  (
  select * from 
  angelfo.accountfo.dbo.ledger1 a with (nolock)                   
  where dddt >=@sdtcur 
  )y on x.vno=y.vno and x.VDT=y.dddt and x.BALAMT=y.relamt
   and (y.reldt>x.VDT or y.reldt='1900-01-01 00:00:00.000')            
       
 /*NSX*/ 
  select CLTCODE,            
  VBal=sum(case when drcr='D' then -VAMT else VAMT end),                   
  UCV=sum(Case when edt > @Todate and Drcr='C' then Vamt else 0 end),                  
  UDV=sum(Case when edt > @Todate and Drcr='D' then Vamt else 0 end)            
  into #NSX            
  from angelfo.accountcurfo.dbo.ledger a with (nolock)                   
  where vDT>=@sdtcur and eDT <= @ToDate  and cltcode between 'a' and 'zzzz9999'                
  group by cltcode                
             
  select x.CLTCODE,x.VDT,UCV=y.relamt,y.reldt,UDV=0   into #NSXe    from 
  (select * from 
  angelfo.accountcurfo.dbo.ledger a with (nolock)                   
  where vDT>= @sdtcur and edt  <= @ToDate and cltcode between 'a' and 'zzzz9999')x inner join 
  (
  select * from 
  angelfo.accountcurfo.dbo.ledger1 a with (nolock)                   
  where dddt >=@sdtcur 
  )y on x.vno=y.vno and x.VDT=y.dddt and x.BALAMT=y.relamt
   and (y.reldt>x.VDT or y.reldt='1900-01-01 00:00:00.000')            
             
  /*MCD*/           
  select CLTCODE,      
  VBal=sum(case when drcr='D' then -VAMT else VAMT end),                   
  UCV=sum(Case when edt > @Todate and Drcr='C' then Vamt else 0 end),                  
  UDV=sum(Case when edt > @Todate and Drcr='D' then Vamt else 0 end)            
  into #MCD            
  from angelcommodity.accountmcdxcds.dbo.ledger a with (nolock)                   
  where vDT>=@sdtcur and eDT <= @ToDate    and cltcode between 'a' and 'zzzz9999'              
  group by cltcode                
             
  select x.CLTCODE,x.VDT,UCV=y.relamt,y.reldt,UDV=0   into #MCDe    from 
  (select * from 
  angelcommodity.accountmcdxcds.dbo.ledger a with (nolock)                   
  where vDT>= @sdtcur and edt  <= @ToDate and cltcode between 'a' and 'zzzz9999')x inner join 
  (
  select * from 
  angelcommodity.accountmcdxcds.dbo.ledger1 a with (nolock)                   
  where dddt >=@sdtcur 
  )y on x.vno=y.vno and x.VDT=y.dddt and x.BALAMT=y.relamt
   and (y.reldt>x.VDT or y.reldt='1900-01-01 00:00:00.000')  
  
	
	select top 0 * into #Sebiinspection_SCFM_ClientData from Sebiinspection_SCFM_ClientData with (nolock)
	
	--Balance Fetching
	insert into #Sebiinspection_SCFM_ClientData
	select @ToDate,'BSECM',cltcode,VBal,0,0,0,0 from #BSECM where cltcode not in (select party_code from #Sebiinspection_SCFM_ClientData) 
	
	insert into #Sebiinspection_SCFM_ClientData
	select @ToDate,'NSECM',cltcode,VBal,0,0,0,0 from #NSECM where cltcode not in (select party_code from #Sebiinspection_SCFM_ClientData) 

	insert into #Sebiinspection_SCFM_ClientData
	select @ToDate,'NSEFO',cltcode,VBal,0,0,0,0 from #NSEFO where cltcode not in (select party_code from #Sebiinspection_SCFM_ClientData) 

	insert into #Sebiinspection_SCFM_ClientData
	select @ToDate,'NSX',cltcode,VBal,0,0,0,0 from #NSX where cltcode not in (select party_code from #Sebiinspection_SCFM_ClientData) 

	insert into #Sebiinspection_SCFM_ClientData
	select @ToDate,'MCD',cltcode,VBal,0,0,0,0 from #MCD where cltcode not in (select party_code from #Sebiinspection_SCFM_ClientData) 
	
	
	--Unsettled credit and debit balance
	update a set Unrecocredit=b.UCV,Unrecobal=b.UCV*-1 from  #Sebiinspection_SCFM_ClientData a, #BSECMe b where a.segment='BSECM' 
	and a.party_Code=b.cltcode            
	
	update a set Unrecocredit=b.UCV,Unrecobal=b.UCV*-1 from  #Sebiinspection_SCFM_ClientData a, #NSECMe b where a.segment='NSECM' 
	and a.party_Code=b.cltcode            
	
	update a set Unrecocredit=b.UCV,Unrecobal=b.UCV*-1 from  #Sebiinspection_SCFM_ClientData a, #NSEFOe b where a.segment='NSEFO' 
	and a.party_Code=b.cltcode            
	
	update a set Unrecocredit=b.UCV,Unrecobal=b.UCV*-1 from  #Sebiinspection_SCFM_ClientData a, #NSXe b where a.segment='NSX' 
	and a.party_Code=b.cltcode            
	
	update a set Unrecocredit=b.UCV,Unrecobal=b.UCV*-1 from  #Sebiinspection_SCFM_ClientData a, #MCD b where a.segment='MCD' 
	and a.party_Code=b.cltcode            
			
	
	--Delete already processed data of that date
	if exists(select top 1 * from Sebiinspection_SCFM_ClientData with (nolock) where processdate=@ToDate)  
	begin 
		delete from Sebiinspection_SCFM_ClientData where processdate=@ToDate	
	end	
	
	--delete from #Sebiinspection_SCFM_ClientData where isnumeric(left(party_code,1))=1
	
	--Inserting computed data		
	insert into Sebiinspection_SCFM_ClientData
	select * from #Sebiinspection_SCFM_ClientData

 set nocount off

GO
