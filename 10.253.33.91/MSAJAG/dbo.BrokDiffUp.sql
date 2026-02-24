-- Object: PROCEDURE dbo.BrokDiffUp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BrokDiffUp    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.BrokDiffUp    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.BrokDiffUp    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.BrokDiffUp    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.BrokDiffUp    Script Date: 12/27/00 8:59:06 PM ******/

CREATE Proc BrokDiffUp (@Sett_no Varchar(7), @Sett_type varchar(2), @cat varchar(3), @MinBrok int) as
insert into BrokDiff
select sett_no = @sett_no , sett_Type = @sett_type ,s.party_code,billno = 0,s.contractno,sauda_date = substring(convert(varchar,s.sauda_date,109),1,11),
Sec_PayIn = ( select sec_payin from sett_mst where sett_no = @sett_No and sett_Type = @sett_type ),
Sec_PayOut = ( select sec_payin from sett_mst where sett_no = @sett_no and sett_Type =@sett_type ),
brokerage = sum(s.brokapplied*s.tradeqty),diff = @minbrok - sum(s.brokapplied*s.tradeqty) ,minbrok = @minbrok ,printed = '0' , 
End_Date = ( select End_Date from sett_mst where sett_no = @sett_no and sett_Type =@sett_type ) from settlement s, client1 c1, client2 c2
where s.sauda_date >= ( select start_date from sett_mst where sett_no = @sett_no and sett_type = @sett_type )
and s.sauda_date <= ( select end_date from sett_mst where sett_no = @sett_no and sett_type = @sett_Type )
and s.party_code not in (30,40,55999,50099) and c1.cl_code = c2.cl_code and c2.party_code = s.party_code
and c2.tran_cat = @cat and s.tradeqty > 0  and s.sett_type = @sett_type
group by substring(convert(varchar,s.sauda_date,109),1,11),s.party_code,s.contractno 
having sum(s.tradeqty*s.brokapplied) < @minbrok
/*
select s.sett_no,s.sett_Type,s.party_code,s.BillNo,s.contractno,sauda_date = substring(convert(varchar,s.sauda_date,109),1,11), Sec_PayIn,Sec_PayOut, brokerage = sum(s.brokapplied*s.tradeqty),diff = @MinBrok - sum(s.brokapplied*s.tradeqty) , @MinBrok ,0 
from settlement s, client2 c2, sett_mst sm
where sm.sett_no = s.sett_no and sm.sett_type = s.sett_type and
s.sett_no like @sett_no and s.sett_type = @sett_type and s.tradeqty > 0 
and s.party_code not in (30,40) and s.party_code = c2.party_code and c2.tran_cat = @Cat
group by s.sett_no,s.sett_Type,s.party_code,s.billno,s.contractno,substring(convert(varchar,s.sauda_date,109),1,11),sec_payin,sec_payout
having @minBrok - sum(s.brokapplied*s.tradeqty) > 0 
*/

GO
