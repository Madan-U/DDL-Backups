-- Object: PROCEDURE dbo.Angel_BrsAutoRecon
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



--exec Angel_BrsAutoRecon convert(varchar(12),getdate(),107),1  
  
CREATE proc Angel_BrsAutoRecon(@Segment int)    
as    
    
--set @relDate = convert(datetime,@relDate,107)    
    
select Vno,vtyp,lno,bookType,Reldt,RefNo into #x from [196.1.115.235].brs.dbo.ledger1 where     
/*dddt>='apr 01 2008' and dddt<='mar 31 2009' and */    
reldt <> '1900-01-01' and B_Seg_Code = @Segment    
    
    
update ledger1 set RefNo =  #x.RefNo, RelDt = #x.Reldt from    
#x where  #x.Vno  = ledger1.vno and #x.vtyp = ledger1.vtyp and #x.bookType = ledger1.bookType    
and #x.lno = ledger1.lno and ledger1.reldt='jan 01 1900'

GO
