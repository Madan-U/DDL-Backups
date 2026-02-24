-- Object: PROCEDURE dbo.ContCumBillHeader
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.ContCumBillHeader    Script Date: 3/12/2004 12:49:55 PM ******/
CREATE procedure ContCumBillHeader (@Sdate varchar(12),@SETT_TYPE VARCHAR(3), @ContNo varchar(6),@Sett_no Varchar(10),@party_code varchar(10)) as
select distinct  Top 1  settlement.party_code,Partyname = client1.Long_name,settlement.billno,
settlement.contractno,sett_mst.sett_no,sett_mst.sett_type, 
convert(varchar(11),sett_mst.start_date,109) as start_date ,convert(varchar(11),sett_mst.end_date,109) as end_date ,
client1.l_address1,client1.l_address2,client1.l_address3,
client1.l_city,client1.l_zip, convert(varchar(11),settlement.sauda_date,109) as sauda_date ,
client2.service_chrg,client1.Branch_cd ,client1.sub_broker,client1.pan_gir_no,
-------------------This commented Party is only used in MOSL and JHP -----------------------
/*Pay_in = 
 	(case when datepart(dw,funds_payin) > 2 or datepart(dw,funds_payin) < 8 
		then convert(varchar(11),dateadd(day,-1,sett_mst.funds_payin),103)---otherdays
	     when datepart(dw,funds_payin) = 2 ---Monday 
		then convert(varchar(11),dateadd(day,-3,sett_mst.funds_payin),103)
	     when datepart(dw,funds_payin) = 1 ---sunday
		then convert(varchar(11),dateadd(day,-2,sett_mst.funds_payin),103)
	end ),
Pay_Out =  (case when datepart(dw,funds_payOut) >= 1  or datepart(dw,funds_payOut) < 5
		then convert(varchar(11),dateadd(day,1,sett_mst.funds_payOut),103)---otherdays
	     when datepart(dw,funds_payOut) = 6 ---Friday 
		then convert(varchar(11),dateadd(day,3,sett_mst.funds_payOut),103)
	     when datepart(dw,funds_payOut) = 7 ---Saturday
		then convert(varchar(11),dateadd(day,2,sett_mst.funds_payOut),103)
	end ) */
-------------Following is used for Refco -------------------
Pay_in = convert(varchar(11),dateadd(day,-2,sett_mst.funds_payin),109),
Pay_Out = convert(varchar(11),sett_mst.funds_payOut,109)
,client1.Off_Phone1,client1.Off_Phone2, sell_buy 
from settlement,CLIENT1 client1,CLIENT2 client2, sett_mst
where client1.cl_code = client2.cl_code 
and settlement.party_code = client2.party_code
and settlement.sett_no = sett_mst.sett_no 
and settlement.sett_type = sett_mst.sett_type 
and convert(int,settlement.contractno) = @CONTNO
and ( settlement.sauda_date LIKE @SDATE + '%' ) 
AND SETTLEMENT.SETT_TYPE = @SETT_TYPE 
and settlement.tradeqty > 0
and settlement.party_code = @Party_code 
And AuctionPart Not In ('AP','AR','FP','FS','FC','FL')
union 
select distinct  Top 1  settlement.party_code,Partyname = client1.Long_name,settlement.billno,
settlement.contractno,sett_mst.sett_no,sett_mst.sett_type, 
convert(varchar(11),sett_mst.start_date,109) as start_date ,convert(varchar(11),sett_mst.end_date,109) as end_date ,
client1.l_address1,client1.l_address2,client1.l_address3,
client1.l_city,client1.l_zip, convert(varchar(11),settlement.sauda_date,109) as sauda_date ,
client2.service_chrg,client1.Branch_cd ,client1.sub_broker,client1.pan_gir_no,
-------------------This commented Party is only used in MOSL and JHP -----------------------
/*Pay_in = 
 	(case when datepart(dw,funds_payin) > 2 or datepart(dw,funds_payin) < 8 
		then convert(varchar(11),dateadd(day,-1,sett_mst.funds_payin),103)---otherdays
	     when datepart(dw,funds_payin) = 2 ---Monday 
		then convert(varchar(11),dateadd(day,-3,sett_mst.funds_payin),103)
	     when datepart(dw,funds_payin) = 1 ---sunday
		then convert(varchar(11),dateadd(day,-2,sett_mst.funds_payin),103)
	end ),
Pay_Out =  (case when datepart(dw,funds_payOut) >= 1  or datepart(dw,funds_payOut) < 5
		then convert(varchar(11),dateadd(day,1,sett_mst.funds_payOut),103)---otherdays
	     when datepart(dw,funds_payOut) = 6 ---Friday 
		then convert(varchar(11),dateadd(day,3,sett_mst.funds_payOut),103)
	     when datepart(dw,funds_payOut) = 7 ---Saturday
		then convert(varchar(11),dateadd(day,2,sett_mst.funds_payOut),103)
	end ) */
-------------Following is used for Refco -------------------
Pay_in = convert(varchar(11),dateadd(day,-2,sett_mst.funds_payin),109),
Pay_Out = convert(varchar(11),sett_mst.funds_payOut,109)
,client1.Off_Phone1,client1.Off_Phone2, sell_buy  
from settlement,CLIENT1 client1,CLIENT2 client2, sett_mst
where client1.cl_code = client2.cl_code 
and settlement.party_code = client2.party_code
and settlement.sett_no = sett_mst.sett_no 
and settlement.sett_type = sett_mst.sett_type 
and convert(int,settlement.contractno) = @CONTNO
and settlement.sett_no = @sett_no  
AND SETTLEMENT.SETT_TYPE = @SETT_TYPE 
and settlement.tradeqty > 0
and settlement.party_code = @Party_code 
And AuctionPart Not In ('AP','AR','FP','FS','FC','FL')

GO
