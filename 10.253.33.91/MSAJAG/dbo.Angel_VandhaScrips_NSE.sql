-- Object: PROCEDURE dbo.Angel_VandhaScrips_NSE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE Proc [dbo].[Angel_VandhaScrips_NSE]  
(  
@fdate as varchar(11),  
@partyCode as varchar(11),  
@Type as varchar(2),  
@ScripRet as varchar(25),
@trdType as varchar(25)  
)  
as  
  
set @fdate = convert(varchar(11),convert(datetime,@fdate,103))  
  
select * into #Bill from cmbillvalan(nolock)   
where sauda_Date >= @fdate  
and sauda_Date <= @fdate+' 23:59:59'  
and Party_Code = @partyCode  
  
--select Distinct Scrip_cd from #bill  
  
-----Intraday  
If @Type = 'I'  
	If(@trdType='B')
		Select Sett_no,Contractno,Party_Code,Scrip_Cd,convert(varchar,Sauda_date,103) as Sauda_date,
		PQtyTrd,PAmtTrd,Branch_Cd from
		#Bill where PQtyTrd <> 0 and SQtyTrd <> 0 and scrip_cd = @ScripRet    
	Else if(@trdType='S')
		Select Sett_no,Contractno,Party_Code,Scrip_Cd,convert(varchar,Sauda_date,103) as Sauda_date,
		SQtyTrd,SAmtTrd,Branch_Cd from
		#Bill where PQtyTrd <> 0 and SQtyTrd <> 0 and scrip_cd = @ScripRet   

-----Delivery  
If @Type = 'D'  
	If(@trdType='B')
		Select Sett_no,Contractno,Party_Code,Scrip_Cd,convert(varchar,Sauda_date,103),
		PQtyDel,PAmtDel,Branch_Cd from
		#Bill where (PQtyDel > 0 or SQtyDel <> 0) and scrip_cd = @ScripRet 
	Else If(@trdType='S')
		Select Sett_no,Contractno,Party_Code,Scrip_Cd,convert(varchar,Sauda_date,103),
		SQtyDel,SAmtDel,Branch_Cd from
		#Bill where (PQtyDel > 0 or SQtyDel <> 0) and scrip_cd = @ScripRet 
drop table #Bill

GO
