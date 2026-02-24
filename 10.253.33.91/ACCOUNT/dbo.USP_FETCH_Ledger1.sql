-- Object: PROCEDURE dbo.USP_FETCH_Ledger1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE Proc USP_FETCH_Ledger1(@fdate as varchar(11),@tdate as varchar(11),@segment as varchar(25),@Code as varchar(20))                                    
as        
        
/*declare @segment as varchar(25)                                    
declare @fdate as varchar(25)                                    
declare @tdate as varchar(25)          
declare @Code as varchar(10)          
*/       
declare @str as varchar(5000)                    
declare @condition as varchar(1000)                                                  
set @fdate = convert(varchar(11),convert(datetime,@fdate,103))              
set @tdate = convert(varchar(11),convert(datetime,@tdate,103))           
        
/*        
set @fdate = 'May 01 2009'                                    
set @tdate = 'May 31 2009'                                    
set @segment = 'NSE'          
set @Code = 'ALL'         
*/        
If @Code = 'ALL'          
Begin          
 SET @condition =                      
 CASE                       
 WHEN @segment = 'AFAPL' THEN 'left(cltcode,3) in (''310'',''380'',''270'')'                      
 WHEN @segment = 'NBFC' THEN 'left(cltcode,3) in (''310'',''380'',''270'')' ELSE 'left(cltcode,3) = ''270'''  END           
End           
Else          
Begin          
 SET @condition = 'left(cltcode,3) = '''+@Code+''''          
End           
        
create table #Temp          
(          
 SrNo int identity(1,1) not null,          
 VNo varchar(20)          
)        
        
set @str = 'insert into #Temp select distinct vno from ledger x (nolock)  where vdt > = '''+@fdate+'''   
and vdt < = '''+@tdate+'''+'' 23:59:59''                    
and  vtyp = ''8'' and exists                     
(Select vno from ledger b where x.vno = b.vno and '+@condition+'                     
and vtyp = ''8'' and vdt > = '''+@fdate+''' and vdt < = '''+@tdate+'''+'' 23:59:59'' )'          
exec(@str)          
        
delete from  mis.upload.dbo.Ledger_txt      
  
insert into mis.upload.dbo.Ledger_txt                              
select 'SrNo'+'|'+'vtyp'+'|'+'vno'+'|'+'vdt'+'|'+'cltcode'+'|'+'LONGNAME'+'|'+'drcr'+'|'+'vamt'+'|'+'narration'+'|'+'Branch Code'     
        
set @str = 'insert into mis.upload.dbo.Ledger_txt select ltrim(rtrim(Convert(Varchar,b.srno)))+''|''+  
ltrim(rtrim(Convert(Varchar,vtyp)))+''|''+ltrim(rtrim(Convert(Varchar,x.vno)))+''|''+  
ltrim(rtrim(Convert(Varchar(12),vdt,107)))+''|''+ltrim(rtrim(X.cltcode))+''|''+  
ltrim(rtrim(LONGNAME))+''|''+ltrim(rtrim(x.drcr))+''|''+ltrim(rtrim(convert(varchar,vamt)))+''|''+  
ltrim(rtrim(narration))+''|''+ltrim(rtrim(isnull(costname,'''')))  from            
(Select * from ledger x (nolock)  where vdt > = '''+@fdate+''' and vdt < = '''+@tdate+'''+'' 23:59:59''         and  vtyp = ''8'' and exists                     
(Select vno from ledger b (nolock) where x.vno = b.vno and '+@condition+'                     
and vtyp = ''8'' and vdt > = '''+@fdate+''' and vdt < = '''+@tdate+'''+'' 23:59:59'' ))x                    
left outer join                    
(select * from ACMAST (nolock))y                    
on x.cltcode=y.CLTCODE                    
left outer join                    
(select * from ledger2  (nolock))z                    
on x.vno = z.vno and x.lno = z.lno and x.cltcode = z.cltcode and x.vtyp = z.vtype                    
left outer join (select * from costmast (nolock))a on z.costcode = a.costcode          
left outer join (select * from #Temp)b on x.vno = b.vno'        
--print @str  
exec(@str)

GO
