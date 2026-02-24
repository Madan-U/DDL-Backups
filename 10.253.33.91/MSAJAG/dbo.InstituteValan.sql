-- Object: PROCEDURE dbo.InstituteValan
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.InstituteValan    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.InstituteValan    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.InstituteValan    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.InstituteValan    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.InstituteValan    Script Date: 12/27/00 8:59:08 PM ******/

/****** Object:  Stored Procedure dbo.InstituteValan    Script Date: 10/18/2000 2:14:23 PM ******/
Create proc InstituteValan (@sett_no varchar(7),@sett_Type varchar(2)) as 
Delete from IAccBill where sett_no = @sett_no and sett_Type = @sett_type
insert into IAccBill
select Party_code,Billno,sell_buy=1,s.Sett_no,s.Sett_type,start_date,end_date,Funds_Payin,Funds_PayOut,Amount=isnull(sum((brokapplied*tradeqty)+service_tax),0) from Isettlement s , Sett_Mst s1
where s.sett_no = @sett_no and s.sett_Type = @sett_type and s1.sett_no = s.sett_no and s1.sett_type = s.sett_type 
and tradeqty > 0 and billno > 0 
group by s.Sett_no,s.Sett_type,Party_code,billno,start_date,end_date,Funds_Payin,Funds_PayOut
union all
select Party_code=63130,0,sell_buy=2,s.Sett_no,s.Sett_type,start_date,end_date,Funds_Payin,Funds_PayOut,Amount=isnull(sum(brokapplied*tradeqty),0) from Isettlement s , Sett_Mst s1
where s.sett_no = @sett_no and s.sett_Type = @sett_type and s1.sett_no = s.sett_no and s1.sett_type = s.sett_type 
and tradeqty > 0 and billno > 0 
group by s.Sett_no,s.Sett_type,start_date,end_date,Funds_Payin,Funds_PayOut
union all
select Party_code=99980,0,sell_buy=2,s.Sett_no,s.Sett_type,start_date,end_date,Funds_Payin,Funds_PayOut,Amount=isnull(sum(service_tax),0) from Isettlement s, Sett_Mst s1
where s.sett_no = @sett_no and s.sett_Type = @sett_type and s1.sett_no = s.sett_no and s1.sett_type = s.sett_type 
and tradeqty > 0 and billno > 0 
group by s.Sett_no,s.Sett_type,start_date,end_date,Funds_Payin,Funds_PayOut

GO
