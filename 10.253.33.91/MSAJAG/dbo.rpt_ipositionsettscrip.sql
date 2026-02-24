-- Object: PROCEDURE dbo.rpt_ipositionsettscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_ipositionsettscrip    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ipositionsettscrip    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ipositionsettscrip    Script Date: 20-Mar-01 11:38:59 PM ******/
/* institutional trading*/

/* report : position report 
   file : demat/scriptrans.asp
   displays detailed saudas of a particular scrip of a particular party and particular settlement
*/
CREATE PROCEDURE rpt_ipositionsettscrip 
@settno varchar(7),
@settype varchar(3),
@partycode varchar(6),
@scripcd varchar(12),
@series varchar(3)

AS

select sett_no,sett_type,party_code,Scrip_Cd,series,tradeqty,N_NetRate,Sell_buy,
Sauda_date,User_id,amount 
from isettlement 
where sett_no = @settno and sett_type = @settype and party_code = @partycode
and Scrip_Cd = @scripcd and series =@series
union all
select sett_no,sett_type,party_code,Scrip_Cd,series,tradeqty,N_NetRate,Sell_buy,
Sauda_date,User_id,amount 
from ihistory 
where sett_no = @settno and sett_type = @settype and party_code = @partycode
and Scrip_Cd = @scripcd and series =@series
order by sett_no,sett_type,party_code,Scrip_Cd,series,Sauda_date,Sell_buy,tradeqty,N_NetRate,User_id

GO
