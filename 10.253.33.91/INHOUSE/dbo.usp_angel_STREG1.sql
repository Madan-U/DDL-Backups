-- Object: PROCEDURE dbo.usp_angel_STREG1
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE proc [dbo].[usp_angel_STREG1]                                                      
(@fvdt as datetime,@tvdt as datetime, @code as varchar(10))             
as                                                      
                          
set nocount on                                                      
            
declare @code1 as varchar(10), @code2 as varchar(10)                          
            
set @code1 = '4100' + right(@code, 2)                          
set @code2= '4200' + right(@code, 2)                              
                                                 
--------account.dbo.ledger Copy            
select * into #t from account.dbo.ledger  where  cltcode=@code and left(convert(varchar,vdt,121),11)>=@fvdt and left(convert(varchar,vdt,121),11)<=@tvdt                                          
                                              
select drcr= case                                               
when drcr = 'D' then 'C'                                               
when drcr = 'C' then 'D' end, vno,left(convert(varchar,vdt,121),11) vdt,vtyp into #l1 from #t                        
            
--declare  @code1 as varchar(10), @code2 as varchar(10)                          
set @code1 = '4100' + right(@code, 2)                          
set @code2= '4200' + right(@code, 2)                              
                                              
select convert(varchar(11),vdt,103) as [Date],VNO,cltcode,acname, segment='ACDL',vamt,space(10) as [Expense Code],space(100) as [Expense Code Name],space(20) as [Expense Amount], space(20) as [ST],space(20) as [EC],              
space(20) as [SHEC],space(20) as [Total], space(100) as [Trade Name],              
space(20) as [Rate],space(30) as [PAN No.],space(50) as [Service Tax No.],space(500) as [Address1],space(500) as [Address2],space(500) as [Address3],space(500) as [City],space(500) as [Pin],space(500) as [State],      
narration as [Narration],DRCR,vtyp  into #file1 from                                              
(                                              
select * from #t                                            
union                                             
select x.* from                                              
(                                              
select l.*                                      
from account.dbo.ledger l , #t t                                       
where l.vtyp = t.vtyp  and l.vtyp <> '18' and l.vno = t.vno and left(convert(varchar,l.vdt,121),11)>=@fvdt               
and left(convert(varchar,l.vdt,121),11)<=@tvdt and isnumeric(l.cltcode) = 1 and               
(l.cltcode not like '4%' or l.cltcode not like '5%')                                             
) x                              
inner join                                              
(select * from #l1)y                                              
on left(convert(varchar,x.vdt,121),11) = y.vdt and x.drcr = y.drcr and x.vno = y.vno             
) x where cltcode not like '26%'            
                                                      
update #file1 set vamt = 0 where vamt = ''                                        
update #file1 set [Expense Amount] = 0 where [Expense Amount] = ''                                          
update #file1 set [ST] = 0 where [ST] = ''                                        
update #file1 set [EC] = 0 where [EC] = ''                                       
update #file1 set [SHEC] = 0 where [SHEC] = ''             
                                                      
update #file1 set [Expense Code]=b.cltcode,[Expense Amount]=b.vamt from                                                      
(select cltcode,vno,vamt,vtyp from account.dbo.ledger  where cltcode like '5%' and vno in (select vno from #t))b, #file1 a       where a.vno=b.vno  and a.vtyp=b.vtyp                                   
----------------------------------------------------------------            
--select distinct x.vNo,x.cltcode,x.vamt,x.acname,x.vtyp into #temp2 from            
--(   
--select cltcode,Vno,vamt,acname,vtyp from account.dbo.ledger x (nolock) where cltcode like '5%' and exists          --(select * from #t y where x.vno = y.vno)            
--)x            
--inner join            
--(select * from #file1)y            
--on x.vno = y.vno  and x.vtyp=y.vtyp            
--              
--update #file1 set [Expense Code] = x.cltcode, [Expense Amount]=x.vamt             
--from #file1 x,#temp2 y             
--where x.Vno = y.Vno  and x.vtyp=y.vtyp                  
----------------------------------------------------------------                                
update #file1 set [Expense Code Name]=b.acname from                 
(select cltcode,vno,vamt,acname,vtyp from account.dbo.ledger  where cltcode like '5%' and vno in ( select vno from #t))b,           
#file1 a                
 where a.vno=b.vno  and a.vtyp=b.vtyp                      
-------------------------------------            
--select distinct x.vNo,x.cltcode,x.vamt,x.acname into #temp1 from            
--(            
--select cltcode,Vno,vamt,acname from account.dbo.ledger x (nolock) where cltcode like '5%' and exists            
--(select * from #t y where x.vno = y.vno)            
--)x            
--inner join            
--(select * from #file1)y            
--on x.vno = y.vno           
--              
--update #file1 set [Expense Code Name] = x.acname from #file1 x,#temp1 y             
--where x.Vno = y.Vno            
--                                              
----------------cltcode like '5%' and            
            
select distinct x.vNo,x.cltcode,z.st_No,z.pan_No,            
Address1=z.add1, Address2=z.add2, Address3=z.add3, city=z.city, pin=z.pin, state=z.state,            
TradeName=case when z.Trade_Name is null then '' else z.Trade_Name end into #temp from            
(            
select cltcode,Vno from account.dbo.ledger x  where exists            
(select * from #t y where x.vno = y.vno)            
)x            
inner join            
(select * from #file1)y            
on x.vno = y.vno            
inner join            
(select * from Intranet.Angelvms.dbo.vendormaster  where segment = 'NSECM')z            
on x.cltcode = z.cltcode             
            
select y.pan_no,y.st_No,      
y.Address1, y.Address2,y.Address3,y.city,y.pin,y.state,            
y.TradeName,x.cltcode,x.vno into #xx from            
(select * from #file1)x            
left outer join       
#temp y on x.Vno = y.Vno and x.cltcode = y.cltcode            
            
update #file1 set [Pan No.] = y.Pan_No,Address1 = y.Address1,Address2=y.Address2,      
Address3=y.Address3,City=y.City,Pin=y.Pin,State=y.state,[service Tax No.] = y.st_No,            
[trade Name] = y.tradename       
from #file1 x,#temp y      
where x.Vno = y.Vno and x.cltcode = y.cltcode            
            
-----------------                                                                          
update #file1 set [ST]=b.vamt from                                                      
(select cltcode,vno,vamt from account.dbo.ledger  where cltcode =@code and vno in ( select vno from #t))b,#file1 a                 
where a.vno=b.vno                                                       
                                                      
update #file1 set [EC]=b.vamt from                                                   
(select cltcode,vno,vamt from account.dbo.ledger  where cltcode =@code1 and vno in ( select vno from #t))b,#file1 a                          
where a.vno=b.vno                                                                                                  
                                                      
update #file1 set [SHEC]=b.vamt from                                                      
(select cltcode,vno,vamt from account.dbo.ledger  where cltcode =@code2 and vno in ( select vno from #t))b,#file1 a                      
where a.vno=b.vno                                        
                                  
update #File1 set [Total] = convert(money,[ST])+convert(money,[EC])+convert(money,[SHEC])            
                                        
update #File1 set [Rate] = case             
when convert(money,[Expense Amount]) <> 0 then             
convert(money,[Total])/convert(money,[Expense Amount])*100 else 0 end             
                                      
select * from #file1 where cltcode <> @code                                            
                                          
set nocount off

GO
