-- Object: PROCEDURE dbo.rpt_TEMPmtomfill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_TEMPmtomfill    Script Date: 04/27/2001 4:32:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_TEMPmtomfill    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_TEMPmtomfill    Script Date: 20-Mar-01 11:39:03 PM ******/


/* 
Procedure written by bhushan ghorpade on 18 oct 2000
checked on 9 nov 2000
Returns normal Settlement Data for MtoM Report
Deletes data from trade4432 if Older than Todays Date
*/
CREATE PROCEDURE rpt_TEMPmtomfill
@partycode varchar(6),
@shortname varchar(21)
AS
/*  If trade4432 contains old records they are deleted  */
if ( select count(*) from trade4432 where convert(varchar,sauda_date,103) < convert(varchar,getdate(),103) ) > 0
  begin
 delete from trade4432 
  end
/*  If settlement contains todays date then delete trade4432 
if ( select count(*) from settlement where convert(varchar,sauda_date,103) = convert(varchar,getdate(),103) ) > 0
  begin
 delete from trade4432 
  end
 */
/*  If settlement contains todays records then select from settlement  */
if ( select Count(*) from settlement where sauda_date like left(convert(varchar,getdate(),109),11)+'%' ) > 0 
  begin
 select s.sett_no ,s.sett_type ,c1.cl_code, c2.party_code, c1.short_name,s.scrip_cd, s.series, Qty = sum(s.tradeqty), Amt = sum(s.tradeqty * s.N_NetRate), s.sell_buy 
 from settlement s,client1 c1,client2 c2 
 where c1.cl_code=c2.cl_code 
 and s.party_code = c2.party_code 
 and s.billno = '0' and s.sett_type='N'
 and  s.party_code like ltrim(@partycode) + '%'  and c1.short_name like ltrim(@shortname) + '%'
 group by  c1.short_name,c2.party_code,c1.cl_code,s.sett_no,s.sett_type,s.scrip_cd ,s.series,s.sell_buy 
 order by  c1.short_name,c2.party_code,c1.cl_code,s.sett_no,s.sett_type,s.scrip_cd ,s.series,s.sell_buy 
  end
else
/*  If settlement does not contain todays records then get the online records  */
  begin
 select m.sett_no, m.sett_type,c1.cl_code , t.party_code, c1.short_name, t.Scrip_Cd, t.series, Qty = sum(t.tradeqty), Amt= sum(t.tradeqty * t.marketrate), t.sell_buy
 from trade4432 t, sett_mst m, client1 c1, client2 c2 
 where t.sauda_date between m.start_date and m.end_date 
 and m.series = t.series
 and c1.cl_code = c2.cl_code 
 and t.party_code = c2.party_code 
 and t.party_code like ltrim(@partycode) + '%' and c1.short_name like ltrim(@shortname) + '%'
 and m.sett_type = 'N'
 group by c1.short_name,t.party_code,c1.cl_code, m.sett_no, m.sett_type, t.Scrip_Cd, t.series,t.sell_buy
  union all
 select s.sett_no ,s.sett_type ,c1.cl_code , c2.party_code, c1.short_name,s.scrip_cd, s.series, Qty = sum(s.tradeqty), Amt = sum(s.tradeqty * s.N_NetRate), s.sell_buy 
 from settlement s,client1 c1,client2 c2 
 where c1.cl_code=c2.cl_code 
 and s.party_code = c2.party_code 
 and s.billno = '0' and s.sett_type='N' 
 and  s.party_code like ltrim(@partycode) + '%' and c1.short_name like ltrim(@shortname) + '%'
 group by c1.short_name,c2.party_code,c1.cl_code,s.sett_no,s.sett_type,s.scrip_cd ,s.series,s.sell_buy 
 order by c1.short_name,t.party_code,c1.cl_code, m.sett_no, m.sett_type, t.Scrip_Cd, t.series,t.sell_buy
  end

GO
