-- Object: PROCEDURE dbo.Angel_VandhaScripSearch_NSE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
CREATE Proc Angel_VandhaScripSearch_NSE  
(  
@fdate as varchar(11),  
@partyCode as varchar(11),  
@Type as varchar(2),  
@ScripRet as varchar(25)  
)  
as  
  
set @fdate = convert(varchar(11),convert(datetime,@fdate,103))  
  
select * into #Bill from cmbillvalan(nolock)   
where sauda_Date >= @fdate  
and sauda_Date <= @fdate+' 23:59:59'  
and Party_Code = @partyCode  
  
select * into #Settlement from settlement(nolock)   
where sauda_Date >= @fdate  
and sauda_Date <= @fdate+' 23:59:59'  
and Party_Code = @partyCode  
  
--select Distinct Scrip_cd from #bill  
  
-----Intraday  
If @Type = 'I'  
begin  
 if(@ScripRet is not Null AND @ScripRet <> '' )  
 begin  
  
        select * from #Bill where PQtyTrd <> 0 and SQtyTrd <> 0 and scrip_cd = @ScripRet  
  
  select * from #Settlement(nolock) where sauda_date >= @fdate  
  and sauda_date <= @fdate+' 23:59:59' and Party_Code = @partyCode and scrip_cd = @ScripRet  
   
 end  
 else  
  select Distinct Scrip_Name,Scrip_cd from #Bill where PQtyTrd <> 0 and SQtyTrd <> 0  
End  
  
-----Delivery  
If @Type = 'D'  
Begin  
if(@ScripRet is not Null AND @ScripRet <> '' )  
  begin  
   select * from #Bill where (PQtyDel > 0 or SQtyDel <> 0) and scrip_cd = @ScripRet  
   select * from #Settlement(nolock) where sauda_date >= @fdate  
   and sauda_date <= @fdate+' 23:59:59' and Party_Code = @partyCode and scrip_cd = @ScripRet  
  end   
 else  
  select Distinct Scrip_Name,Scrip_cd from #Bill where (PQtyDel > 0 or SQtyDel <> 0)  
End  
  
drop table #Bill  
drop table #Settlement

GO
