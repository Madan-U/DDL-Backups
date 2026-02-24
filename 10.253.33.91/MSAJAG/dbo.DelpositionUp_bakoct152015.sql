-- Object: PROCEDURE dbo.DelpositionUp_bakoct152015
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc DelpositionUp @Sett_no Varchar(10),@Sett_type Varchar(3),@Party_code Varchar(10),@Scrip_cd Varchar(12)    
As     
    
Truncate Table DelPos     
    
If @Party_code = ''    
   Set @Party_code = '%'    
    
If @Scrip_cd = ''    
   Set @Scrip_cd = '%'    
    
Insert into Delpos Select party_code,scrip_cd,series,sell_buy,    
pqty = isnull((case when sell_buy = 1 then     
        sum(tradeqty) end),0),    
sqty = Isnull((case when sell_buy = 2 then     
               sum(tradeqty) end),0),    
sett_no,sett_type,User_Id,PartiPantCode   from settlement S    
Where S.Sett_type = @sett_type    
And S.Sett_no = @Sett_no    
/*And S.Party_code Like @Party_code*/    
And S.Scrip_cd Like @Scrip_cd And AuctionPart Not in ('FC','FS','FP')    
group by sett_no,sett_type,party_code,scrip_cd,series,User_Id,sell_buy,PartiPantCode    
    
Insert into Delpos Select party_code,scrip_cd,series,sell_buy,    
pqty = isnull((case when sell_buy = 2 then     
        sum(tradeqty) end),0),    
sqty = Isnull((case when sell_buy = 1 then     
               sum(tradeqty) end),0),    
sett_no,sett_type,User_Id,PartiPantCode   from settlement S    
Where S.Sett_type = @sett_type    
And S.Sett_no = @Sett_no    
/*And S.Party_code Like @Party_code*/    
And S.Scrip_cd Like @Scrip_cd And AuctionPart in ('FC','FS','FP')    
group by sett_no,sett_type,party_code,scrip_cd,series,User_Id,sell_buy,PartiPantCode    
    
IF (SELECT count(*) From Owner Where MainBroker = 0 ) > 0     
 Update DelPos Set PartipantCode = MemberCode From Owner    
    
UPDATE DELPOS SET SERIES = 'EQ' WHERE SERIES IN ( 'IS','RS')

GO
