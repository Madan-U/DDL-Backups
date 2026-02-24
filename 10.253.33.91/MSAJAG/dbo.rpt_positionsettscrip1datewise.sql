-- Object: PROCEDURE dbo.rpt_positionsettscrip1datewise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_positionsettscrip1datewise    Script Date: 04/27/2001 4:32:48 PM ******/
/* report : position
   file : scriptrans.asp
   displays detailed saudas of a particular scrip of a particular party and particular settlement
*/
CREATE PROCEDURE rpt_positionsettscrip1datewise
@fdate varchar(30),
@tdate varchar(30),
@partycode varchar(6),
@scripcd varchar(12),
@series varchar(3),
@settno varchar(7),
@settype varchar(3)

AS
select sett_no,sett_type,party_code,Scrip_Cd,series,tradeqty,N_NetRate,Sell_buy,
Sauda_date,User_id,amount 
from settlement 
where sauda_date >= @fdate and sauda_date  <= @tdate + ' 23:59:59' and party_code = @partycode
and Scrip_Cd = @scripcd and series =@series and sett_no=@settno and sett_type=@settype
union all
select sett_no,sett_type,party_code,Scrip_Cd,series,tradeqty,N_NetRate,Sell_buy,
Sauda_date,User_id,amount 
from history 
where sauda_date  >= @fdate and sauda_date  <= @tdate +  ' 23:59:59' and party_code = @partycode
and Scrip_Cd = @scripcd and series =@series and sett_no=@settno and sett_type=@settype

GO
