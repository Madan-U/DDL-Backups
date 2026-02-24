-- Object: PROCEDURE dbo.Angel_chg_slab_trd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create procedure Angel_chg_slab_trd(@sbcode as varchar(10),@tslab as varchar(10))  
as  
  
set nocount off  
set transaction isolation level read uncommitted  
  
select c2.party_code into #file1 from client1 c1, client2 c2 where c1.cl_Code=c2.cl_code and c1.sub_Broker=@sbcode  
  
select Party_Code,Table_No,Scheme_Type,Scrip_Cd,Trade_Type,Brokscheme,From_Date,To_Date  
into #file2 from clientbrok_scheme where party_code   
in (select party_Code from #file1) and to_date >= getdate()  
and table_no <> @tslab and scheme_type='TRD'  
  
update #file2 set from_date = convert(varchar(11),getdate()),   
table_no = @tslab  
  
select top 0 * into #file3 from #file2  
  
insert into #file3  
select party_code,@tslab,'TRD','ALL','NRM',brok_scheme, convert(varchar(11),getdate()),'Dec 31 2049 23:59:00'  
from client2 where party_code in (select party_Code from #file1) and party_code not in (select party_Code from #file2)  
and table_no <> @tslab  
  
insert into #file3  
select c2.party_code,table_no,'TRD','ALL','NRM',brok_scheme,activefrom,convert(varchar(11),getdate()-1)  
from client2 c2,  
(select party_code,activefrom from client5 c5, client2 c2 where c2.cl_code=c5.cl_Code   
and c2.party_code in (select * from #file1)) c3   
where c2.party_code in (select party_Code from #file1) and c2.party_code not in (select party_Code from #file2)  
and c3.party_code=c2.party_code and table_no <> @tslab  
  
  
update clientbrok_scheme set to_date = convert(varchar(11),getdate()-1)+' 23:59:00:00'  
where party_code in (select party_Code from #file1) and to_date >= getdate()  
and table_no <> @tslab and scheme_type='TRD'  
  
  
insert into #file2 select * from #file3  
  
insert into clientbrok_scheme select * from #file2  
update client2 set table_no=@tslab where party_code in (Select party_code from #file1)  
  
set nocount on

GO
