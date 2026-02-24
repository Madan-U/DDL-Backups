-- Object: PROCEDURE dbo.BBGOtrGen
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE    Procedure BBGOtrGen    
@Sauda_date Varchar(11)    
As    
Declare    
@@ContractNo as Varchar(7),    
@@OldContractNo as Varchar(7),    
@@EQty As Int,    
@@Erate As Decimal(20,10),    
@@Myrate As Decimal(20,10),    
@@Eamount As Money,     
@@Escrip_Cd As Char(10),    
@@ESeries AS Char(3),    
@@ESell_buy As Char(1),    
@@ESett_No As Char(10),    
@@ESett_type As Char(3),    
@@EPartipantcode As Char(15),    
@@ExchangeCursor As Cursor,    
@@ContCur As Cursor,    
@@MyQty As Int,    
@@MyAmount As Money,    
@@DiffRate As Decimal(20,10),    
@@BankId As Char(20),    
@@CommitRate As Decimal (20,10),    
@@CP_Code Varchar(15)    
   
Set Nocount On    
    
Select @Sauda_date = Ltrim(Rtrim(@Sauda_date))    
If Len(@Sauda_date) = 10     
Begin    
      Set @Sauda_date = STUFF(@Sauda_date, 4, 1,' ')    
End    
    
Delete Toexchange where sauda_date like @Sauda_date +'%'    
    
    
Set @@ExchangeCursor = Cursor For    
Select Sec_Symbol,Security_Series,Sell_buy = Sell_buyFlag,Sum(Oblig_Qty),    
Sum(Oblig_Value),Sett_no,Sett_type,CP_Code    
from fromexchange Where Rec_type = 10     
Group by Sec_Symbol,Security_Series,Sell_BuyFlag,Sett_no,Sett_type,Cp_Code    
Order by Sec_Symbol,Security_Series,Sett_no,Sett_type    
Open @@ExchangeCursor    
Fetch Next from @@ExchangeCursor Into @@EScrip_Cd ,@@ESeries,@@ESell_buy,@@EQty,@@Eamount,@@Esett_no,@@ESett_type,@@CP_Code    
    
    
If @@Fetch_status = 0     
Begin    
     While @@Fetch_Status = 0    
     Begin    
          Select @@Myqty = 0    
          Select @@MyAmount = 0     
    
          Select @@Erate = Convert(Decimal(20,10),@@Eamount) / @@Eqty     
    
          Set @@ContCur = Cursor For    
    
          Select Amt, ContractNo From (    
          Select Amt=Sum(Tradeqty * Marketrate), Qty=Sum(Tradeqty), ContractNo from     
          Isettlement Where scrip_cd = Ltrim(Rtrim(@@EScrip_cd)) and Series = Ltrim(Rtrim(@@ESeries))    
          And Sett_no = Ltrim(Rtrim(@@ESett_no)) And Sett_type = Ltrim(Rtrim(@@ESett_type))    
          And Sell_buy = (Case When Ltrim(Rtrim(@@ESell_buy)) = 'B' then 1 Else 2 End)    
          And PartipantCode = @@CP_Code And Sauda_Date Like @Sauda_date + '%' And TradeQty > 0   
          Group By ContractNo ) A     
          Order By Qty Asc    
          Open @@ContCur     
          Fetch Next From @@ContCur into @@MyAmount,@@ContractNo 
          While @@Fetch_Status = 0    
          Begin     
           Select @@EAmount = Round(@@EAmount - @@MyAmount,2)    
           Select @@OldContractNo = @@ContractNo      
           Fetch Next From @@ContCur into @@MyAmount,@@ContractNo      
           If @@Fetch_status <> 0                   
           Begin    
            Insert into ToExchange    
            Select '10',Sell_buy = (Case When Sell_buy = 1 Then 'B' Else 'S' End),Sett_type,Sett_no,Scrip_cd,Series,Partipantcode=UPPER(Partipantcode),Sum(Tradeqty),Sum(Tradeqty * marketrate) + @@EAmount,  Client2.Bankid,Contractno,0,@sauda_date,Getdate()
     
            From Isettlement s,Client2  Where s.party_code = Client2.Party_code     
            And Scrip_cd = Ltrim(Rtrim(@@EScrip_cd)) and Series = Ltrim(Rtrim(@@ESeries))     
            and Sett_type = Ltrim(Rtrim(@@ESett_type)) and Sett_no = Ltrim(Rtrim(@@ESett_no))    
            and ContractNo = @@OldContractNo And TradeQty > 0     
            And PartipantCode = @@CP_Code And Sauda_Date Like @Sauda_date + '%'    
            Group by Sell_buy,Sett_type,Sett_no,Scrip_cd,Series,Client2.Bankid,Contractno,Partipantcode,marketrate   
           End    
           Else    
           Begin    
            Insert into ToExchange    
            Select '10',Sell_buy = (Case When Sell_buy = 1 Then 'B' Else 'S' End),Sett_type,Sett_no,Scrip_cd,Series,Partipantcode=UPPER(Partipantcode),Sum(Tradeqty),Sum(Tradeqty * marketrate) ,  Client2.Bankid,Contractno,0,@sauda_date,Getdate()     
            From Isettlement s,Client2  Where s.party_code = Client2.Party_code     
            And Scrip_cd = Ltrim(Rtrim(@@EScrip_cd)) and Series = Ltrim(Rtrim(@@ESeries))     
            and Sett_type = Ltrim(Rtrim(@@ESett_type)) and Sett_no = Ltrim(Rtrim(@@ESett_no))    
       and ContractNo = @@OldContractNo   And TradeQty > 0   
            And PartipantCode = @@CP_Code And Sauda_Date Like @Sauda_date + '%'    
            Group by Sell_buy,Sett_type,Sett_no,Scrip_cd,Series,Client2.Bankid,Contractno,Partipantcode,marketrate   
   End        
          End    
          Fetch Next from @@ExchangeCursor Into @@EScrip_Cd ,@@ESeries,@@ESell_buy,@@EQty,@@Eamount,@@Esett_no,@@ESett_type,@@CP_Code     
     End    
End

GO
