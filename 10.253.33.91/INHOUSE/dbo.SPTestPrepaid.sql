-- Object: PROCEDURE dbo.SPTestPrepaid
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE proc SPTestPrepaid                                 
( @fvdt as datetime,@tvdt as datetime, @code as varchar(10))                                       
                                      
as                                      
          
set nocount on                                    
          
--declare  @code1 as varchar(10), @code2 as varchar(10)          
--set @code1 = '4100' + right(@code, 2)          
--set @code2= '4200' + right(@code, 2)                        
--declare @fvdt as datetime,@tvdt as datetime,@code as varchar(10)                          
--set @fvdt = '2008-04-01'                          
--set @tvdt = '2009-03-31'      
--set @code ='250001'               
--left(convert(varchar,vdt,121),11)  --convert(varchar(11),convert(datetime,vdt),103)                     
                                 
select * into #t from account.dbo.ledger  where  cltcode=@code and left(convert(varchar,vdt,121),11)>=@fvdt and left(convert(varchar,vdt,121),11)<=@tvdt                                      
                          
                              
select drcr= case                               
when drcr = 'D' then 'C'                               
when drcr = 'C' then 'D' end, vno,left(convert(varchar,vdt,121),11) vdt,vtyp into #l1 from #t                              
select convert(varchar(11),vdt,103) as [Date],VNO,cltcode,acname, segment='NCDX',vamt,narration as [Narration],DRCR,vtyp  into #file1 from                              
(                              
select * from #t                            
union                             
select x.* from                              
(                              
select l.*                      
from account.dbo.ledger l , #t t                       
where l.vtyp = t.vtyp and l.vtyp <> '18' and l.vno = t.vno and left(convert(varchar,l.vdt,121),11)>=@fvdt and left(convert(varchar,l.vdt,121),11)<=@tvdt and isnumeric(l.cltcode) = 1 and (l.cltcode not like '4%' or l.cltcode not like '2%' and l.cltcode  like '5%')                     
              
) x              
inner join                              
(select * from #l1)y                              
on left(convert(varchar,x.vdt,121),11) = y.vdt and x.drcr = y.drcr and x.vno = y.vno                              
) x where cltcode not like '27%'  and cltcode not like '26%' --and cltcode  like '5%'            
            
    
select * into #P from account.dbo.ledger  where  cltcode=@code and left(convert(varchar,vdt,121),11)>=@fvdt and left(convert(varchar,vdt,121),11)<=@tvdt         
    
    
select l.vtyp,l.vno,l.acname,l.drcr,l.vamt,l.cltcode  into #prepaid1                   
from account.dbo.ledger l , #p p                       
where l.vtyp = p.vtyp and l.vtyp <> '18' and l.vno = p.vno and left(convert(varchar,l.vdt,121),11)>=@fvdt and left(convert(varchar,l.vdt,121),11)<=@tvdt and isnumeric(l.cltcode) = 1 and (l.cltcode not like '4%' and l.cltcode not like '2%')    
    
    
select t.vdt,t.VTYP,t.vno,t.cltcode,t.acname,t.drcr,t.vamt,t.narration,p.cltcode,p.acname,p.drcr,p.vamt    
from #t t left join #prepaid1 p    
on t.vtyp=p.vtyp and t.vno=p.vno    
    
    
--exec SPTestPrepaid '2008-04-02','2009-03-31','04000009'

GO
