-- Object: PROCEDURE dbo.BillValan
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BillValan    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.BillValan    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BillValan    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BillValan    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.BillValan    Script Date: 12/27/00 8:59:06 PM ******/

CREATE Proc BillValan ( @sett_no varchar(7), @Sett_type varchar(2)) as
if ( select count(BillNo) from settlement where sett_no = @sett_no and sett_Type = @Sett_Type ) > 0 
insert into accbill select party_code,billno,
sell_buy = ( case when amount > 0 then 1
             else 2 end),
sett_no,sett_type,start_date,end_date,sec_payin,sec_payout,ABS(Amount) from billtovalan 
where sett_no= @sett_no and sett_Type = @sett_type
else
insert into accbill select party_code,billno,
sell_buy = ( case when amount > 0 then 1
             else 2 end),
sett_no,sett_type,start_date,end_date,sec_payin,sec_payout,ABS(Amount) from billtovalanHis
where sett_no= @sett_no and sett_Type = @sett_type

GO
