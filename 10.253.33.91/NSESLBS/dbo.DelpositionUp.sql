-- Object: PROCEDURE dbo.DelpositionUp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc [dbo].[DelpositionUp] @Sett_no Varchar(10),@Sett_type Varchar(3),@Party_code Varchar(10),@Scrip_cd Varchar(12)          
As           
Truncate Table DelPos           
          
If @Party_code = ''          
   Set @Party_code = '%'          
          
If @Scrip_cd = ''          
   Set @Scrip_cd = '%'          
          
If @Sett_Type = 'Q'           
Begin          
Insert into Delpos Select party_code,scrip_cd,series,sell_buy=0,          
pqty = isnull(Sum(Case when sell_buy = 1 then TradeQty Else 0 end),0),          
sqty = isnull(Sum(Case when sell_buy = 2 then TradeQty Else 0 end),0),          
sett_no,sett_type,User_Id,PartiPantCode   from settlement S          
Where S.Sett_no = @Sett_no          
And S.Sett_type = @sett_type          
And AuctionPart Not in ('FC','FS','FP')          
group by sett_no,sett_type,party_code,scrip_cd,series,User_Id,PartiPantCode          
          
Insert into Delpos Select party_code,scrip_cd,series,sell_buy=0,          
pqty = isnull(Sum(Case when sell_buy = 2 then TradeQty Else 0 end),0),          
sqty = isnull(Sum(Case when sell_buy = 1 then TradeQty Else 0 end),0),          
sett_no,sett_type,User_Id,PartiPantCode   from settlement S          
Where S.Sett_no = @Sett_no          
And S.Sett_type = @sett_type      
/*And S.Party_code Like @Party_code*/          
And AuctionPart in ('FC','FS','FP')          
group by sett_no,sett_type,party_code,scrip_cd,series,User_Id,PartiPantCode          
End          
Else          
Begin          
Insert into Delpos Select party_code,scrip_cd,series,sell_buy=0,          
pqty = isnull(Sum(Case when sell_buy = 1 then TradeQty Else 0 end),0),          
sqty = isnull(Sum(Case when sell_buy = 2 then TradeQty Else 0 end),0),          
sett_no,sett_type,User_Id,PartiPantCode   from settlement S          
Where S.Sett_no = @Sett_no        
And S.Sett_type = @sett_type 
AND AUCTIONPART <> 'CA'           
group by sett_no,sett_type,party_code,scrip_cd,series,User_Id,PartiPantCode          
End          
IF (SELECT count(*) From Owner Where MainBroker = 0 ) > 0           
 Update DelPos Set PartipantCode = MemberCode From Owner        
        
 UPDATE DELPOS SET SERIES = 'EQ'

GO
