-- Object: PROCEDURE dbo.rpt_SameALBM
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_SameALBM    Script Date: 04/27/2001 4:32:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_SameALBM    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_SameALBM    Script Date: 20-Mar-01 11:39:02 PM ******/

/****** Object:  Stored Procedure dbo.rpt_SameALBM    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_SameALBM    Script Date: 12/27/00 8:58:57 PM ******/

/****** Object:  Stored Procedure dbo.rpt_SameALBM    Script Date: 10/23/2000 11:04:47 AM ******/
/* 
Procedure written by bhushan ghorpade on 18 oct 2000
Returns normal Settlement Data for MtoM Report
Deletes data from trade4432 if Older than Todays Date
*/
CREATE PROCEDURE rpt_SameALBM
@partycode varchar(6),
@settno varchar(8)
AS
/*
if (  select count(t.party_code) from trade4432 t, sett_mst m 
 where t.sauda_date between m.start_date and m.end_date and m.series = t.series 
 and t.MarketType = 3
 and m.sett_no = @settno and m.sett_type = 'L' and t.party_code like ltrim(@partycode) + '%'   ) > 0
*/
if (select count(*) from settlement where convert(varchar,sauda_date,103) = convert(varchar,getdate(),103)) = 0
  begin
 select m.sett_no, m.sett_type, t.party_code, c1.short_name, t.Scrip_Cd, t.series, Qty = sum(t.tradeqty), Amt= sum(t.tradeqty * c.Cl_Rate), t.sell_buy
 from trade4432 t, sett_mst m, client1 c1, client2 c2 ,closing c
 where t.sauda_date between m.start_date and m.end_date 
 and m.series = t.series and  t.MarketType = 3
 and c1.cl_code = c2.cl_code 
 and t.party_code = c2.party_code 
 and c.scrip_cd = t.scrip_cd and c.series ='EQ' and c.market = 'NORMAL'
 and t.party_code like ltrim(@partycode) + '%' 
 and m.sett_type = 'L' and m.sett_no like  ltrim(@settno) + '%' 
 group by t.party_code,c1.short_name,m.sett_no, m.sett_type, t.Scrip_Cd, t.series,t.sell_buy
union all 
 select s.sett_no ,s.sett_type , c2.party_code, c1.short_name,s.scrip_cd, s.series, Qty = sum(s.tradeqty), Amt = sum(s.tradeqty * a.Rate), s.sell_buy 
 from settlement s,client1 c1,client2 c2 ,albmrate a
 where c1.cl_code=c2.cl_code 
 and s.party_code = c2.party_code
 and a.sett_no = s.sett_no and a.sett_type = s.sett_type and a.scrip_cd = s.scrip_cd and a.series =s.series 
 and s.sett_type='L' and s.sett_no like ltrim(@settno) + '%'  
 and  s.party_code like ltrim(@partycode) + '%'  
 group by c1.short_name,c2.party_code,s.sett_no,s.sett_type,s.scrip_cd ,s.series,s.sell_buy 
 order by  t.party_code,c1.short_name,m.sett_no, m.sett_type, t.Scrip_Cd, t.series,t.sell_buy
  end
else 
  begin
 
 select s.sett_no ,s.sett_type , c2.party_code, c1.short_name,s.scrip_cd, s.series, Qty = sum(s.tradeqty), Amt = sum(s.tradeqty * a.Rate), s.sell_buy 
 from settlement s,client1 c1,client2 c2 ,albmrate a
 where c1.cl_code=c2.cl_code 
 and s.party_code = c2.party_code
 and a.sett_no = s.sett_no and a.sett_type = s.sett_type and a.scrip_cd = s.scrip_cd and a.series =s.series 
 and s.sett_type='L' and s.sett_no like ltrim(@settno) + '%'  
 and  s.party_code like ltrim(@partycode) + '%'  
 group by c1.short_name,c2.party_code,s.sett_no,s.sett_type,s.scrip_cd ,s.series,s.sell_buy 
 order by c2.party_code,c1.short_name,s.sett_no,s.sett_type,s.scrip_cd ,s.series,s.sell_buy 
  end

GO
