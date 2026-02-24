-- Object: PROCEDURE dbo.AuctionDelPos
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------







/****** Object:  Stored Procedure dbo.AuctionDelPos    Script Date: 5/5/01 2:51:54 PM ******/
/****** Object:  Stored Procedure dbo.AuctionDelPos    Script Date: 3/21/01 12:50:00 PM ******/
/****** Object:  Stored Procedure dbo.AuctionDelPos    Script Date: 20-Mar-01 11:38:42 PM ******/
CREATE Proc AuctionDelPos (@Sett_no Varchar(7), @Sett_Type Varchar(2),@RefNo int) As 

Delete From DelTrans Where ISett_No = @Sett_No and ISett_Type = @Sett_Type and Reason = 'Received From Auction' 

insert into DelTrans
select Sett_No,Sett_type,@RefNo,0,904,Client2.Party_Code,scrip_cd,series,TradeQty,'','','Auction','','', 'Received From Auction' ,'C',0,TradeQty,'','','','',(Select MemberCode From Owner),0,'',@sett_no,@sett_type,'DEMAT',GetDate(),'',1,'','','','','',''
from Auction, Client2, Client1 where client1.cl_code = client2.cl_code
and client2.party_code = auction.party_code
and sell_buy = 1 and ASett_No = @Sett_No and ASett_Type = @Sett_Type

insert into DelTrans
select Sett_No,Sett_type,@RefNo,0,904,'BROKER',scrip_cd,series,TradeQty,'','','Auction','','', 'Received From Auction' ,'D',0,TradeQty,'','','','',(Select MemberCode From Owner),0,'',@sett_no,@sett_type,'DEMAT',GetDate(),'',1,'','','','','',''
from Auction, Client2, Client1 where client1.cl_code = client2.cl_code
and client2.party_code = auction.party_code
and sell_buy = 1 and ASett_No = @Sett_No and ASett_Type = @Sett_Type

/*
Insert into CertInfo select Sett_no,Sett_type,scrip_cd,series,tradeqty,Auction.party_code,getdate(),
'1','1','Auction','Auction','1',Short_Name,'1','I','0',ASett_No,Asett_Type,Bill_no,TradeQty,1 
from Auction, Client2, Client1 where client1.cl_code = client2.cl_code
and client2.party_code = auction.party_code
and sell_buy = 1 and ASett_No = @Sett_No and ASett_Type = @Sett_Type
*/

insert into DelTrans
select Sett_No,Sett_type,@RefNo,0,906,'NSE',scrip_cd,series,Qty=IsNull(Sum(Sqty),0)-IsNull(Sum(Pqty),0),'','','Auction','','', 'Received From Auction' ,'C',0,OrgQty=IsNull(Sum(Sqty),0)-IsNull(Sum(Pqty),0),'','','','',(Select MemberCode From Owner),0,'',@sett_no,@sett_type,'DEMAT',GetDate(),'',1,'','','','','',''
from AuctionNse Where ASett_No = @Sett_No and ASett_Type = @Sett_Type
Group By Sett_no,Sett_Type,Asett_no,ASett_Type,Scrip_Cd,Series
Having Sum(SQty) > Sum(PQty)

insert into DelTrans
select Sett_No,Sett_type,@RefNo,0,904,'BROKER',scrip_cd,series,Qty=IsNull(Sum(Sqty),0)-IsNull(Sum(Pqty),0),'','','Auction','','', 'Received From Auction' ,'D',0,OrgQty=IsNull(Sum(Sqty),0)-IsNull(Sum(Pqty),0),'','','','',(Select MemberCode From Owner),0,'',@sett_no,@sett_type,'DEMAT',GetDate(),'',1,'','','','','',''
from AuctionNse Where ASett_No = @Sett_No and ASett_Type = @Sett_Type
Group By Sett_no,Sett_Type,Asett_no,ASett_Type,Scrip_Cd,Series
Having Sum(SQty) > Sum(PQty)

/*
Insert into CertInfo select Sett_no,Sett_Type,Scrip_Cd,Series,Qty=IsNull(Sum(Sqty),0)-IsNull(Sum(Pqty),0),'NSE',GetDate(),
'1','1','Auction','Auction','1','NSE','1','I','0',Asett_no,ASett_Type,0,Qty=IsNull(Sum(Sqty),0)-IsNull(Sum(Pqty),0),1
from AuctionNse where ASett_No = @Sett_No and ASett_Type = @Sett_Type
Group By Sett_no,Sett_Type,Asett_no,ASett_Type,Scrip_Cd,Series
Having Sum(SQty) > Sum(PQty)
*/

GO
