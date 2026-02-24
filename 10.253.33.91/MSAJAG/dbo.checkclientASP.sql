-- Object: PROCEDURE dbo.checkclientASP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.checkclientASP    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.checkclientASP    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.checkclientASP    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.checkclientASP    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.checkclientASP    Script Date: 12/27/00 8:58:47 PM ******/

CREATE procedure checkclientASP (  @settno varchar(10)) as 
select distinct party_code,
Diffqty = isnull((select sum(tradeqty) from settlement where sell_buy =2 and sett_no like t1.sett_no and party_code like t1.party_code  AND settlement.party_code=t1.party_code and settlement.scrip_cd=t1.scrip_cd),0)
  - 
       isnull((select sum(tradeqty) from settlement where sell_buy =1 and sett_no like t1.sett_no  and party_code like t1.party_code AND settlement.party_code=t1.party_code and settlement.scrip_cd=t1.scrip_cd),0) 
From settlement t1 where t1.sett_no = @settno
group by party_code,scrip_cd,series,sett_no
union all
select distinct party_code,
Diffqty = isnull((select sum(tradeqty) from history where sell_buy =2 and sett_no like t1.sett_no and party_code like t1.party_code  AND history.party_code=t1.party_code and history.scrip_cd=t1.scrip_cd),0)
  - 
       isnull((select sum(tradeqty) from history where sell_buy =1 and sett_no like t1.sett_no  and party_code like t1.party_code AND history.party_code=t1.party_code and history.scrip_cd=t1.scrip_cd),0) 
From history t1 where t1.sett_no = @settno 
group by party_code,scrip_cd,series,sett_no

GO
