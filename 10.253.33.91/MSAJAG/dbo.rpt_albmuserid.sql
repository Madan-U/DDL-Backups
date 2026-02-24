-- Object: PROCEDURE dbo.rpt_albmuserid
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmuserid    Script Date: 04/27/2001 4:32:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmuserid    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmuserid    Script Date: 20-Mar-01 11:38:53 PM ******/



/* report : useridwise turnover
    file: detailuserid.asp
    displays scripwise sell buy totals of a scrip and useri
*/

CREATE PROCEDURE rpt_albmuserid

@userid int ,
@settno varchar(7)

AS



select user_id,scrip_cd,amt=SUM(TRADEQTY*RATE), qty=sum(tradeqty), sell_buy from albmwuserid
where user_id=@userid and sett_no=@settno
group by user_id,scrip_cd, sell_buy
order by user_id,scrip_cd, sell_buy

GO
