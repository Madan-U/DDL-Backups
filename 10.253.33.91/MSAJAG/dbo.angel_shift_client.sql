-- Object: PROCEDURE dbo.angel_shift_client
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure angel_shift_client      
as      
      
      
select * into #Shift from intranet.testdb.dbo.shift      
      
--select * from #shift where old_kyc_code in (select cl_code from client5 where inactivefrom < getdate())      
--delete from #shift where old_kyc_code in (select cl_code from client5 where inactivefrom < getdate())      
      
      
select c1.* into #client1 from       
client1 c1,       
client2 c2       
where c1.cl_Code=c2.cl_code and c2.party_code in      
(select old_kyc_code from #shift)      
      
      
      
select c2.* into #client2      
from       
client1 c1, client2 c2       
where c1.cl_Code=c2.cl_code and c2.party_code in      
(select old_kyc_code from #shift)      
      
      
select c3.* into #client3      
from client3 c3      
where c3.party_code in (select old_kyc_code from #shift)      
      
      
      
select c4.* into #client4      
from client4 c4      
where c4.party_code in      
(select old_kyc_code from #shift)      
      
      
select mc.* into #multicltid       
from multicltid mc      
where mc.party_code in      
(select old_kyc_code from #shift)      
      
      
select c5.* into #client5      
from       
client5 c5,      
client2 c2       
where c5.cl_Code=c2.cl_code and c2.party_code in      
(select old_kyc_code from #shift)      
      
      
select c6.* into #client6      
from       
client6 c6      
where c6.party_code in      
(select old_kyc_code from #shift)      
  
  
select c7.* into #client7  
from         
clientbrok_scheme c7  
where c7.party_code in        
(select old_kyc_code from #shift) and (getdate() >= from_DAte and getdate() <= to_date)  
  
select c8.* into #client8  
from clienttaxes c8  
where c8.party_code in        
(select old_kyc_code from #shift) and (getdate() >= fromDAte and getdate() <= todate)  
      
      
select cm.* into #clientmast      
from       
clientmaster cm      
where cm.party_code in      
(select old_kyc_code from #shift)      
      
      
--select * from #client5      
select * into #client5b from #client5      
      
--update #client5 set inactivefrom=convert(varchar(11),getdate())      
---------------------------      
update client5 set inactivefrom=convert(varchar(11),getdate())+' 23:59:59'       
where cl_code in (select old_kyc_code from #shift)      
      
      
      
update #client5b set cl_Code = b.new_kyc_code from      
(select cs.*,c2.cl_code from #shift cs, #client2 c2 where cs.old_kyc_code=c2.party_code)b       
where #client5b.cl_Code=b.cl_code      
      
update #client5b set activefrom=convert(varchar(11),getdate()+1)+' 00:00:00'      
      
      
update #client1 set cl_Code = b.new_kyc_code,branch_cd = b.branch,sub_BRoker=b.sub_Broker,family=b.new_kyc_code from      
(select cs.*,c1.cl_code from #shift cs, #client1 c1 where cs.old_kyc_code=c1.cl_code)b       
where #client1.cl_Code=b.cl_code      
      
      
update #client2 set cl_Code = b.new_kyc_code , party_code = b.new_kyc_code from      
(select cs.*,c1.cl_code from #shift cs, #client2 c1 where cs.old_kyc_code=c1.cl_code)b       
where #client2.cl_Code=b.cl_code      
      
      
update #client3 set cl_Code = b.new_kyc_code , party_code = b.new_kyc_code from      
(select cs.*,c1.cl_code from #shift cs, #client3 c1 where cs.old_kyc_code=c1.cl_code)b       
where #client3.cl_Code=b.cl_code      
      
      
update #client4 set cl_Code = b.new_kyc_code , party_code = b.new_kyc_code from      
(select cs.*,c1.cl_code from #shift cs, #client4 c1 where cs.old_kyc_code=c1.cl_code)b       
where #client4.cl_Code=b.cl_code      
      
update #multicltid set party_code = b.new_kyc_code from      
(select cs.*,c1.party_code from #shift cs, #multicltid c1 where cs.old_kyc_code=c1.party_code)b       
where #multicltid.party_Code=b.party_code      
      
update multicltid set def=0 where party_code in (select old_kyc_code from #shift)      
update client4 set defdp=0 where party_code in (select old_kyc_code from #shift)      
      
insert into client5 select * from #client5b       
insert into client1 select * from #client1      
insert into client2 select * from #client2      
insert into client3 select * from #client3      
insert into client4 select * from #client4      
insert into multicltid select * from #multicltid      
      
  
update #client7 set party_Code = b.new_kyc_code,from_date=(getdate()+1)+' 00:00:00' from #shift b where #client7.party_code=b.old_kyc_code  
update clientbrok_scheme set to_date=convert(varchar(11),getdate())+' 23:59:59' where party_code in (select old_kyc_code from #shift)   
and (getdate() >= from_DAte and getdate() <= to_date)      
insert into clientbrok_scheme (Party_Code,Table_No,Scheme_Type,Scrip_Cd,Trade_Type,Brokscheme,From_Date,To_Date)   
select Party_Code,Table_No,Scheme_Type,Scrip_Cd,Trade_Type,Brokscheme,From_Date,To_Date from #client7  
  
update #client8 set party_Code = b.new_kyc_code,fromdate=(getdate()+1)+' 00:00:00' from #shift b where #client8.party_code=b.old_kyc_code  
update clienttaxes set todate=convert(varchar(11),getdate())+' 23:59:59' where party_code in (select old_kyc_code from #shift)   
and (getdate() >= fromDAte and getdate() <= todate)    
insert into clienttaxes select * from #client8  
  
  
-- Updated by Deepak    
update DpBackOffice.AcerCross.dbo.Client_Master     
set cm_blsavingcd = New_Kyc_code     
from #Shift s, DpBackOffice.AcerCross.dbo.Client_Master cm     
where Old_Kyc_code=cm.cm_blsavingcd    
      
update client1 set trader = b.short_name from branches b      
where client1.branch_Cd=b.branch_cd      
and client1.cl_code in      
(select new_kyc_code from #shift)      
      
select * into #acmast from account.dbo.acmast where cltcode in (select old_kyc_code from #shift)      
update #acmast set cltcode = b.new_kyc_code from #shift b where #acmast.cltcode=b.old_kyc_code       
update #acmast set Branchcode = b.branch from #shift b where #acmast.cltcode=b.new_kyc_code       
insert into account.dbo.acmast select * from #acmast      
------------------- THE END

GO
