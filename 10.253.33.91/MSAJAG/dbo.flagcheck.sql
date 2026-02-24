-- Object: PROCEDURE dbo.flagcheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

Create Procedure flagcheck ( @Sett_no varchar(10),@Sett_type Varchar(3),@scrip_cd varchar(10),@party_code varchar(10) )

as

select party_code,scrip_cd,billflag,settflag,tmark,sell_buy,qty=sum(tradeqty),brok=sum(nbrokapp*tradeqty),flag='Trade' from settlement 
where sett_no = @sett_no and sett_type = @sett_type and scrip_cd like @scrip_cd and party_code like @party_code
group by party_code,scrip_cd,billflag,settflag,tmark,sell_buy
order by party_code,scrip_cd,billflag,settflag,tmark,sell_buy

GO
