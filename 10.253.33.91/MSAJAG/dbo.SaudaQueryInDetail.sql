-- Object: PROCEDURE dbo.SaudaQueryInDetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/* If Flag = 0 then 
query should be sorted according to Date , scrip_cd , Party_code 
else 
query should be sorted according to Date , Party_code , scrip_cd 
drop PROCEDURE SaudaQueryInDetail
 */
CREATE PROCEDURE SaudaQueryInDetail
@vfrmParty_Code varchar(20),
@vtoParty_Code varchar(20),
@dfromdate varchar(11),
@dtodate varchar(11),
@vfrmSrcp varchar(12),
@vtoSrcp varchar(12),
@vfrmSettNo varchar(7),
@vToSettNo varchar(7),
@vSett_Type varchar(3),
@Flag int 
as 
Begin
if @flag = 0 
   Begin
	SELECT convert(varchar(12),sauda_date,111) as tradedt, 
        CONVERT(VARCHAR,s.Sauda_date,103) as sauda_date ,s.sett_no, s.Scrip_Cd , s.Sett_type, s1.short_name as scrip_name ,
	MARKETrate = round((s.MarketRate),2),
	Ptradeqty =(case s.sell_buy when 1 then s.tradeqty else 0 end ),
	Stradeqty =(case s.sell_buy when 2 then s.tradeqty else 0 end ),
	PAMT = (case s.sell_buy when 1 then round((s.n_NetRate * s.tradeqty),2) else 0 end ),
	SAMT = (case s.sell_buy when 2 then round((s.N_NetRate * s.tradeqty),2) else 0 end ),
	s.Sell_buy, 
	Brokapplied = round((s.NBrokApp),2),netrate = round((s.N_NetRate),2), s.trade_no , s.order_no , tm = convert(char(10),s.sauda_date , 108)
	,s.Party_code , c1.Short_name , s.Service_tax, s.Branch_Id , s.user_id
	FROM SETTLEMENT s , scrip2 s2 , client1 c1 , client2 c2 , scrip1 s1
	WHERE s.SAUDA_DATE >= @dfromdate  AND s.SAUDA_DATE <= @dtodate  + ' 23:59:59'
	AND s.PARTY_CODE >= @vfrmParty_code  and s.party_code <= @vtoparty_code and s.tradeqty >0  and 
	s.scrip_cd = s2.scrip_cd AND S.SERIES = s2.series and s1.co_code = s2.co_code and s1.series = s2.series 
	and c2.party_code = s.party_code and c1.cl_code = c2.cl_code

	and sett_type like ( case when @vsett_type = 'all' then '%' else @vsett_type end )
	and sett_no >= @vfrmSettNo and sett_no <= @vtosettNO

	and s.scrip_cd >= @vfrmSrcp and s.scrip_cd <= @vtoSrcp
	Union all  

	SELECT convert(varchar(12),sauda_date,111) as tradedt, 
	CONVERT(VARCHAR,h.Sauda_date,103) as sauda_date ,h.sett_no, h.Scrip_Cd , h.Sett_type, s1.short_name as scrip_name ,
	MARKETrate = round((h.MarketRate),2), 
	Ptradeqty =(case h.sell_buy when 1 then h.tradeqty else 0 end ),
	Stradeqty =(case h.sell_buy when 2 then h.tradeqty else 0 end ),
	PAMT = (case h.sell_buy when 1 then round((h.n_NetRate * h.tradeqty),2) else 0 end ),
	SAMT = (case h.sell_buy when 2 then round((h.n_NetRate * h.tradeqty),2) else 0 end ),
	h.Sell_buy, 
	Brokapplied = round((h.NBrokApp),2),netrate = round((h.n_netRate),2), h.trade_no , h.order_no , tm = convert(char(10),h.sauda_date , 108)
	,h.Party_code , c1.Short_name , h.Service_tax, h.Branch_Id , h.user_id
	FROM History h , scrip2 s2 , client1 c1 , client2 c2 , scrip1 s1
	WHERE h.SAUDA_DATE >= @dfromdate AND h.SAUDA_DATE <= @dtodate + ' 23:59:59'
	AND h.PARTY_CODE >= @vfrmParty_code and h.party_code <= @vtoparty_code and h.tradeqty >0  and 
	h.scrip_cd = s2.scrip_cd AND h.SERIES = s2.series and s1.co_code = s2.co_code and s1.series = s2.series 
	and c2.party_code = h.party_code and c1.cl_code = c2.cl_code

	and sett_type like ( case when @vsett_type = 'all' then '%' else @vsett_type end )
	and sett_no >= @vfrmSettNo and sett_no <= @vtosettNO

	and h.scrip_cd >= @vfrmSrcp and h.scrip_cd <= @vtoSrcp
	order by tradedt, s1.short_name,  s.scrip_cd ,s.party_code,tm
   end 
else
     Begin
	SELECT convert(varchar(12),sauda_date,111) as tradedt, CONVERT(VARCHAR,s.Sauda_date,103) as sauda_date ,s.sett_no, s.Scrip_Cd , s.Sett_type, s1.short_name as scrip_name ,
	MARKETrate = round((s.MarketRate),2), 
	Ptradeqty =(case s.sell_buy when 1 then s.tradeqty else 0 end ),
	Stradeqty =(case s.sell_buy when 2 then s.tradeqty else 0 end ),
	PAMT = (case s.sell_buy when 1 then round((s.n_NetRate * s.tradeqty),2) else 0 end),
	SAMT = (case s.sell_buy when 2 then round((s.N_NetRate * s.tradeqty),2) else 0 end),
	s.Sell_buy, 
	Brokapplied = round((s.NBrokApp),2),netrate = round((s.n_NetRate),2), s.trade_no , s.order_no , tm = convert(char(10),s.sauda_date , 108)
	,s.Party_code , c1.Short_name , s.Service_tax, s.Branch_Id , s.user_id
	FROM SETTLEMENT s , scrip2 s2 , client1 c1 , client2 c2 , scrip1 s1
	WHERE s.SAUDA_DATE >= @dfromdate  AND s.SAUDA_DATE <= @dtodate  + ' 23:59:59'
	AND s.PARTY_CODE >= @vfrmParty_code  and s.party_code <= @vtoparty_code and s.tradeqty >0  and 
	s.scrip_cd = s2.scrip_cd AND S.SERIES = s2.series and s1.co_code = s2.co_code and s1.series = s2.series 
	and c2.party_code = s.party_code and c1.cl_code = c2.cl_code

	and sett_type like ( case when @vsett_type = 'all' then '%' else @vsett_type end )
	and sett_no >= @vfrmSettNo and sett_no <= @vtosettNO

	and s.scrip_cd >= @vfrmSrcp and s.scrip_cd <= @vtoSrcp
	Union all  

	SELECT convert(varchar(12),sauda_date,111) as tradedt, CONVERT(VARCHAR,h.Sauda_date,103) as sauda_date ,h.sett_no, h.Scrip_Cd , h.Sett_type, s1.short_name as scrip_name ,
	MARKETrate = round((h.N_NetRate),2), 
	Ptradeqty =(case h.sell_buy when 1 then h.tradeqty else 0 end ),
	Stradeqty =(case h.sell_buy when 2 then h.tradeqty else 0 end ),
	PAMT = (case h.sell_buy when 1 then round((h.n_NetRate * h.tradeqty),2) else 0 end),
	SAMT = (case h.sell_buy when 2 then round((h.n_NetRate * h.tradeqty),2) else 0 end),
	h.Sell_buy, 
	Brokapplied = round((h.NBrokApp),2),netrate = round((h.n_NetRate),2), h.trade_no , h.order_no , tm = convert(char(10),h.sauda_date , 108)
	,h.Party_code , c1.Short_name , h.Service_tax, h.Branch_Id , h.user_id
	FROM History h , scrip2 s2 , client1 c1 , client2 c2 , scrip1 s1
	WHERE h.SAUDA_DATE >= @dfromdate AND h.SAUDA_DATE <= @dtodate + ' 23:59:59'
	AND h.PARTY_CODE >= @vfrmParty_code and h.party_code <= @vtoparty_code and h.tradeqty >0  and 
	h.scrip_cd = s2.scrip_cd AND h.SERIES = s2.series and s1.co_code = s2.co_code and s1.series = s2.series 
	and c2.party_code = h.party_code and c1.cl_code = c2.cl_code

	and sett_type like ( case when @vsett_type = 'all' then '%' else @vsett_type end )
	and sett_no >= @vfrmSettNo and sett_no <= @vtosettNO

	and h.scrip_cd >= @vfrmSrcp and h.scrip_cd <= @vtoSrcp
	order by tradedt, s.party_code, s.SCRIP_CD,tm
   End
end

GO
