-- Object: PROCEDURE dbo.usp_angel_STREG
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--sp_helptext usp_angel_STREG       
        
--sp_helptext usp_angel_STREG2            
            
--exec usp_angel_STREG2 '2009-03-01','2009-03-28'          
--exec usp_angel_STREG '2008-09-01','2008-09-30'             
CREATE proc [dbo].[usp_angel_STREG]                            
( @fvdt as datetime,@tvdt as datetime)                             
                            
as                            
set nocount on                          
                
                
--declare @fvdt as datetime,@tvdt as datetime                
--set @fvdt = '2008-09-01'                
--set @tvdt = '2008-09-01'       
--left(convert(varchar,vdt,121),11)  --convert(varchar(11),convert(datetime,vdt),103)           
                       
select * into #t from ledger nolock where  cltcode='400002' and left(convert(varchar,vdt,121),11)>=@fvdt and left(convert(varchar,vdt,121),11)<=@tvdt                            
                
                    
select drcr= case                     
when drcr = 'D' then 'C'                     
when drcr = 'C' then 'D' end, vno,left(convert(varchar,vdt,121),11) vdt,vtyp into #l1 from #t                    
                    
select left(vdt,11) as [Date],vno,cltcode,acname, segment='ACDL',vamt,space(10) as [Expense Code],space(100) as [Expense Code Name],space(20) as [Expense Amount], space(20) as [400002],space(20) as [410002],space(20) as [420002],space(20) as [Total],space(20) as [Rate],space(30) as [PAN No.],space(50) as [Service Tax No.],space(500) as [Address],narration as [Narration],DRCR,vtyp  into #file1 from                    
(                    
select * from #t                  
union                   
select x.* from                    
(                    
select l.*            
from ledger l (nolock), #t t             
where l.vtyp = t.vtyp and l.vno = t.vno and left(convert(varchar,l.vdt,121),11)>=@fvdt and left(convert(varchar,l.vdt,121),11)<=@tvdt and isnumeric(l.cltcode) = 1 and (l.cltcode not like '4%' or l.cltcode not like '5%')                     
) x    
inner join                    
(select * from #l1)y                    
on left(convert(varchar,x.vdt,121),11) = y.vdt and x.drcr = y.drcr and x.vno = y.vno                    
) x where cltcode not like '26%'                    
                            
  update #file1 set vamt = 0 where vamt = ''              
update #file1 set [Expense Amount] = 0 where [Expense Amount] = ''                
  update #file1 set [400002] = 0 where [400002] = ''              
update #file1 set [410002] = 0 where [410002] = ''             
update #file1 set [420002] = 0 where [420002] = ''       
      
--select * from #file1                
                            
update #file1 set [Expense Code]=b.cltcode,[Expense Amount]=b.vamt from                            
(select cltcode,vno,vamt,vtyp from ledger  where cltcode like '5%' and vno in ( select vno from #t))b, #file1 a      
 where a.vno=b.vno  and a.vtyp=b.vtyp         
      
update #file1 set [Expense Code Name]=b.acname from                            
(select cltcode,vno,vamt,acname from ledger  where cltcode like '5%' and vno in ( select vno from #t))b, #file1 a      
 where a.vno=b.vno         
                    
----------------    cltcode like '5%' and                        
update #file1 set [Service Tax No.]=v.st_no, [PAN No.]= v.pan_no, [Address]=v.add1+' '+v.add2+' '+v.add3+' '+v.city+' '+v.pin+' '+v.state  from                            
(select cltcode,vno from ledger  where  vno in ( select vno from #t))b, #file1 a, [172.19.2.98].account123.dbo.vendormaster v      
 where a.vno=b.vno and v.segment= 'NSECM' and convert(varchar,v.cltcode)=b.cltcode      
-----------------      
                            
update #file1 set [400002]=b.vamt from                            
(select cltcode,vno,vamt from ledger  where cltcode ='400002' and vno in ( select vno from #t))b,#file1 a       where a.vno=b.vno                              
                            
                            
update #file1 set [410002]=b.vamt from                         
(select cltcode,vno,vamt from ledger  where cltcode ='410002' and vno in ( select vno from #t))b,#file1 a                      
 where a.vno=b.vno                              
                            
                            
update #file1 set [420002]=b.vamt from                            
(select cltcode,vno,vamt from ledger  where cltcode ='420002' and vno in ( select vno from #t))b,#file1 a        where a.vno=b.vno              
        
update #File1 set [Total] = convert(money,[400002])+convert(money,[410002])+convert(money,[420002])                            
          
update #File1 set [Rate] = case when convert(money,[Expense Amount]) <> 0 then convert(money,[Total])/convert(money,[Expense Amount])*100           
else 0 end --from                  
--(select cltcode,vno,vamt from ledger  where cltcode ='420002' and vno in ( select vno from #t))b,#file1 a        where a.vno=b.vno            
            
select * from #file1 where cltcode <> '400002'                
                
                
                
set nocount off

GO
