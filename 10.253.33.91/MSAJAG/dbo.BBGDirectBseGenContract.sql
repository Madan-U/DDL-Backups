-- Object: PROCEDURE dbo.BBGDirectBseGenContract
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE BBGDirectBseGenContract AS 
Declare @@Party varchar(12),
        @@Sett_Type varchar(2),  
        @@ContNo varchar(7),
        @@ContNoPartiPant varchar(7),
        @@ParticiPantCode Varchar(15),
        @@MemberCode Varchar(15),
        @@Sauda_Date Varchar(11),
        @@Order_no Varchar(16),
        @@Scrip_Cd Varchar(12),
        @@Series Varchar(3),
        @@Sell_buy Int,
        @@Style int,
        @@StartDate varchar(11),
        @@EndDate Varchar(11),
        @@Flag int,
        @@Cont Cursor  ,  
        @@PartyCont Cursor    ,
        @@CurSettType Varchar(2),
        @@inscontno varchar(7),
        @@Sett_no Varchar(10),           
        @@MaxContNoS Int,
        @@MaxConnoI  Int,
        @@BBGcontcur Cursor,
        @@getmaxcontno cursor,
        @@Inscont   Varchar(4)


Set @@PartyCont = Cursor for
     Select Distinct Left(Convert(Varchar,Sauda_date,109),11) from  trade 
     Open @@PartyCont
     Fetch next  from @@PartyCont into   @@sauda_date
Close @@PartyCont
     
Set @@PartyCont = cursor for 
    Select MemberCode,Style=IsNull(Style,0) from Owner
    Open @@PartyCont
    Fetch next  from @@PartyCont into   @@MemberCode,@@Style
Close @@PartyCont

  Update Trade set Pro_cli = 'PRO' from Trade,Client2,Client1 where 
  Trade.party_code = client2.party_code
  and Client1.cl_code = Client2.cl_code
  and client1.Cl_type = 'PRO'
  and Trade.partipantcode  = @@MemberCode

  Update Trade set Pro_cli = 'CLI' from Trade,Client2,Client1 where 
  Trade.party_code = client2.party_code
  and Client1.cl_code = Client2.cl_code
  and client1.Cl_type = 'CLI'
  and Trade.partipantcode  = @@MemberCode

  Update Trade set Pro_cli = 'INS' from Trade,Client2,Client1 where 
  Trade.party_code = client2.party_code
  and Client1.cl_code = Client2.cl_code
  and client1.Cl_type = 'INS'
  and Trade.partipantcode  = @@MemberCode

Print 'Made changes as per pro trade in client '
 
 Update Trade set partipantcode = 'DVP'  from Trade,Client2,Client1 where 
 Trade.party_code = client2.party_code
 and Client1.cl_code = Client2.cl_code
 and client1.Cl_type = 'INS'
 and Trade.partipantcode  = @@MemberCode

Print 'Updated trade for DVP trades  '
Print ' Inserting into BBgSettlement from confirmview '
Truncate table bbgsettlement
Truncate table bbgisettlement

  insert into bbgsettlement  select '0000000','0' ,Trade_no, Party_Code, Scrip_Cd,user_id  ,tradeqty,
  AuctionPart, markettype,series, order_no, MarketRate,
  Sauda_date, Table_No, Line_No, Val_perc, Normal ,  Day_puc, day_sales, Sett_purch, Sett_sales,  Sell_buy,settflag,     Brokapplied,NetRate,
  Amount, Ins_chrg,turn_tax,other_chrg,sebi_tax, Broker_chrg,Service_tax, Trade_amount , 1 ,  sett_no,
  BrokApplied , Service_tax ,NetRate,sett_type,partipantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMARK,scheme,Dummy1,Dummy2
  from Bseconfirmview

Print 'Inserted all records into bbgsettlement '


insert into bbgisettlement 
select ContractNo,BillNo,Trade_no,Party_Code,Scrip_Cd,User_id,Tradeqty,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,Trade_amount,Billflag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,Partipantcode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2
from bbgsettlement  where
partipantCode not in (Select distinct CltCode from MultiBroker)
and  ( partipantCode  Like 'FI%' or partipantCode <> @@MemberCode)

Print 'Inserted records in bbgisettlement'

delete bbgsettlement where
partipantCode not in (Select distinct CltCode from MultiBroker)
and  ( partipantCode  Like 'FI%' or partipantCode <> @@MemberCode)

Print 'deleted records From  bbgsettlement'

Set @@Partycont = Cursor For
    Select distinct Sett_type,partipantcode,Party_code,Contractno From Settlement Where
    sauda_date like @@sauda_date +'%' and Pro_cli <>'PRO'  and trade_no not like '%C%'

Open @@Partycont
Fetch Next from @@Partycont into @@Sett_type,@@participantCode,@@Party,@@Contno


While @@Fetch_status = 0
Begin
         Update bbgsettlement set contractno = @@contno Where
         Party_code = @@Party
         and
         Sett_type = @@Sett_type
         and 
     partipantcode = @@Participantcode    
     Fetch Next from @@Partycont into @@Sett_type,@@ParticiPantCode,@@Party,@@Contno
End    

Close @@Partycont

If @@Style = 0
Begin
     Set @@BBGContcur =  Cursor for
     Select isnull(Max(Convert(Int,Contractno)),0) From Settlement
     Where sauda_Date like  @@Sauda_date +'%'
     and Sett_Type = @@Sett_type
     and partipantCode = @@ParticiPantCode 
End
If @@Style = 1 
Begin
     Set @@BBGContcur = Cursor for	
     Select isnull(Convert(int,Contractno),0) From ContGen  
     Where @@sauda_Date >= Start_Date and @@Sauda_Date <= End_Date 
End 
                   
Open @@BBGcontcur
Fetch next from @@BBGcontcur into @@MaxcontNos
Close @@BBGcontCur

Set @@PartyCont = cursor for 
Select Distinct Sett_Type,partipantCode,Party_Code from bbgsettlement where pro_cli  <> 'PRO'
and convert(int,ContractNo) = 0 
Order by Sett_type,partipantCode,Party_code

Open @@PartyCont

Fetch Next  From @@PartyCont into   @@Sett_type,@@ParticiPantCode,@@Party
  
While @@fetch_status = 0
Begin
     /* Print ' Going for partyCode  ' +@@Party +'  Sett_type " +@@sett_type + "  partipant Code  " +@@ParticiPantCode */
     Select @@ContNo = 0 
     Select @@CurSettType = @@Sett_Type
        
     Select @@ContNo = @@MaxcontNos + 1
     Select @@MaxcontNos = @@MaxcontNos + 1 
     /*   Print "partyCode  " +  @@Party   +"  Sett_type " +@@sett_type + "  Participant Code  " +@@ParticiPantCode  */
     Update Bbgsettlement Set contractno = STUFF('0000000', 8 - Len(@@Contno), Len(@@Contno), @@Contno) 
     Where
     Party_code =@@Party 
     and 
     Sett_Type = @@sett_type 
     and 
     partipantCode = @@ParticiPantCode

     If @@Style = 1 
     Update ContGen set ContractNo = @@ContNo where @@sauda_Date >= Start_Date and @@Sauda_Date <= End_Date 
     Fetch next  from @@PartyCont into   @@Sett_type,@@ParticiPantCode,@@Party
End
Close @@Partycont
/* Completed the processing for Non Institutional Trades  */

/* Now first we will update the parties who have previous contracts in either scrip or order */    
/* why do we have join with client2 */

     Set @@Partycont = cursor for
     Select Distinct I.Party_code,I.Sett_type,I.partipantCode,I.Contractno,I.Order_no,I.Scrip_cd,InsCont 
     From Isettlement I ,Client2 C2 Where I.Sauda_date like @@Sauda_date +'%'  and I.Party_code = C2.Party_code and trade_no not like '%C%'
     Order by I.Sett_type,I.partipantcode,I.Party_code,I.Scrip_cd,I.Order_no,I.Contractno
     open @@PartyCont

     Fetch next  from @@PartyCont into  @@Party,@@Sett_type,@@ParticiPantCode,@@contno,@@Order_no,@@Scrip_cd,@@Inscont

     While @@fetch_status = 0
     Begin
          If @@InsCont = 'N' 
          Begin
               Update bbgisettlement set Contractno = @@Contno 
               Where
               Sett_type = @@Sett_type
               and 
               partipantCode = @@ParticiPantCode   
               and 
               Party_code = @@Party
          End
          If @@InsCont = 'O' 
          Begin 
               Update bbgisettlement set Contractno = @@Contno 
               Where
               Sett_type = @@Sett_type
               and 
               partipantCode = @@ParticiPantCode   
               and 
               Party_code = @@Party
               and
               Order_no = @@Order_no
          End
          If @@InsCont = 'S' 
          Begin 
               Update bbgisettlement set Contractno = @@Contno 
               Where
               Sett_type = @@Sett_type
               and 
               partipantCode = @@ParticiPantCode   
               and 
               Party_code = @@Party
               and
               Scrip_cd = @@Scrip_cd
          End

          Fetch next  from @@PartyCont into  @@Party,@@Sett_type,@@ParticiPantCode,@@contno,@@Order_no,@@Scrip_cd,@@Inscont
     End     
     Close @@Partycont

     Select @@Sett_type=''
     Select @@ParticiPantCode =''
  Select @@Party=''

        
     Set @@PartyCont = cursor for 
     Select Distinct Sett_Type,partipantCode,bbgisettlement.Party_Code  From Bbgisettlement,Client2 
     Where pro_cli  <> 'PRO'     
     and convert(int,contractno) = 0  and bbgisettlement.party_code = client2.party_code and inscont =  'N'
     order by sett_type,partipantCode,bbgisettlement.party_code 

     open @@PartyCont

     Fetch next  from @@PartyCont into   @@Sett_type,@@ParticiPantCode,@@Party
     While @@fetch_status = 0
     Begin
          Select @@CurSettType = @@Sett_Type
          Select @@ContNo =@@Maxcontnos +1
          Select @@Maxcontnos = @@Maxcontnos + 1
          Select @@Sett_type,@@Party,@@ContNo,@@ParticiPantCode
          Update bbgisettlement Set contractno = STUFF('0000000', 8 - Len(@@Contno), Len(@@Contno), @@Contno) Where
          Party_code =@@Party 
          and Sett_Type = @@sett_type and partipantCode = @@ParticiPantCode
          fetch next  from @@PartyCont into   @@Sett_type,@@ParticiPantCode,@@Party
     End
     Close @@PartyCont
     Select @@Sett_type=''
     Select @@ParticiPantCode =''
     Select @@Party=''

/* Now Order Wise    */

     Set @@PartyCont = cursor for 
     Select distinct Sett_Type,partipantCode,bbgisettlement.Party_Code,Order_no From Bbgisettlement,Client2 
     Where pro_cli  <> 'PRO'     
     and convert(int,contractno) = 0  
     and bbgisettlement.party_code = client2.party_code 
     and inscont  =  'O'
     Order by sett_type,partipantCode,bbgisettlement.party_code,Order_no  

     Open @@PartyCont

     Fetch next  from @@PartyCont into   @@Sett_type,@@ParticiPantCode,@@Party,@@Order_no
     While @@fetch_status = 0
     Begin
          Select @@CurSettType = @@Sett_Type
          Select @@ContNo = 0
          Select @@ContNo =@@Maxcontnos +1
          Select @@Maxcontnos = @@Maxcontnos + 1
          Update bbgisettlement Set contractno = STUFF('0000000', 8 - Len(@@Contno), Len(@@Contno), @@Contno) Where
          Party_code =@@Party 
          and Sett_Type = @@Sett_type and partipantCode = @@ParticiPantCode
          and Order_no = @@Order_no
          Fetch next  from @@PartyCont into   @@Sett_type,@@ParticiPantCode,@@Party,@@Order_no
     End
     Close @@PartyCont

     Select @@Sett_type=''
     Select @@ParticiPantCode =''
     Select @@Party=''

/* Now Scrip_wise   */
      
        Set @@PartyCont = cursor for 
        Select Distinct Sett_Type,partipantCode,bbgisettlement.Party_Code,Scrip_cd  from Bbgisettlement,Client2 where pro_cli  <> 'PRO'     
        and convert(int,contractno) = 0  and bbgisettlement.party_code = client2.party_code and inscont = 'S'
        order by sett_type,partipantCode,bbgisettlement.party_code  ,Scrip_cd
        open @@PartyCont

        Fetch next  from @@PartyCont into   @@Sett_type,@@ParticiPantCode,@@Party,@@Scrip_cd
        Select  @@Sett_type,@@ParticiPantCode,@@Party,@@Scrip_cd


        While @@fetch_status = 0
        Begin
             Select @@CurSettType = @@Sett_Type
             Select @@ContNo = 0
             Select @@ContNo =@@Maxcontnos +1
             Select @@Maxcontnos = @@Maxcontnos + 1
             Update bbgisettlement set contractno = STUFF('0000000', 8 - Len(@@Contno), Len(@@Contno), @@Contno) where
             Party_code =@@Party 
             and sett_Type = @@sett_type and partipantCode = @@ParticiPantCode
             and Scrip_cd = @@Scrip_cd 

             Fetch next  from @@PartyCont into   @@Sett_type,@@ParticiPantCode,@@Party,@@Scrip_cd
        End
        Close @@PartyCont

        If Convert(Int,@@Contno) >= 0 
        Begin 
                  Select @@Contno = @@Contno
        End
        Else
        Begin
                  Select @@Contno = '0000000'
        End          
        If @@style = 1
        Begin
                  If @@Contno > 0  
                  Update ContGen set ContractNo = @@ContNo where @@sauda_Date >= Start_Date and @@Sauda_Date <= End_Date 
        End
insert into settlement select ContractNo,BillNo,Trade_no,Party_Code,Scrip_Cd,User_id,Tradeqty,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,Trade_amount,Billflag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,Partipantcode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2 from bbgsettlement
insert into isettlement select ContractNo,BillNo,Trade_no,Party_Code,Scrip_Cd,User_id,Tradeqty,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,Trade_amount,Billflag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,Partipantcode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2 from bbgisettlement


truncate table  Trade
deallocate @@Partycont


Set @@PartyCont = cursor for 
Select Distinct B.Party_code,B.Scrip_cd,B.Series,B.partipantCode,B.Sett_type,B.Sett_no From Settlement S, Bbgsettlement B  where S.Sauda_date like @@Sauda_date
and B.Sauda_date Like @@Sauda_date 
and B.Scrip_cd = S.Scrip_cd 
and B.Series = S.Series 
and B.partipantcode = S.partipantcode
And B.Sett_type = S.Sett_type 
And B.Sett_no = S.Sett_no 
Order by B.Party_code,B.Scrip_cd,B.Series,B.partipantCode,B.Sett_type,B.Sett_no

Open @@PartyCont
Fetch Next from @@Partycont into @@Party,@@Scrip_cd,@@Series,@@Participantcode,@@Sett_type,@@Sett_no

If @@Fetch_status = 0
Begin 
          While @@fetch_status = 0
           Begin
                     Exec BseRearrangeAfterContflag  @@Sett_Type ,@@Party ,@@Scrip_cd ,@@Series ,@@Sauda_date,'%',@@Participantcode 
                     Fetch Next from @@Partycont into @@Party,@@Scrip_cd,@@Series ,@@Participantcode,@@Sett_type,@@Sett_no
           End
           Close @@PartyCont
           Deallocate @@PartyCont
End

Set @@PartyCont = cursor for 
Select Distinct B.Party_code,B.Scrip_cd,B.Series,B.partipantCode,B.Sett_type,B.Sett_no From ISettlement S, BbgIsettlement B  where S.Sauda_date like @@Sauda_date
and B.Sauda_date Like @@Sauda_date 
and B.Scrip_cd = S.Scrip_cd 
and B.Series = S.Series 
and B.partipantcode = S.partipantcode
And B.Sett_type = S.Sett_type 
And B.Sett_no = S.Sett_no 
Order by B.Party_code,B.Scrip_cd,B.Series,B.partipantCode,B.Sett_type,B.Sett_no

Open @@PartyCont
Fetch Next from @@Partycont into @@Party,@@Scrip_cd,@@Series ,@@Participantcode,@@Sett_type,@@Sett_no
If @@Fetch_status = 0
Begin 
          While @@fetch_status = 0
           Begin
                     Exec BseRearrangeAfterContflagIns  @@Sett_Type ,@@Party ,@@Scrip_cd ,@@Series ,@@Sauda_date,'%',@@Participantcode 
                     Fetch Next from @@Partycont into @@Party,@@Scrip_cd,@@Series,@@Sell_buy ,@@Participantcode,@@Sett_type,@@Sett_no
           End
           Close @@PartyCont
           Deallocate @@PartyCont
End

insert into details select distinct Left(convert(varchar,sauda_date,109),11),Sett_no,sett_type,Party_code,'S' from bbgsettlement
insert into details select distinct Left(convert(varchar,sauda_date,109),11),Sett_no,sett_type,Party_code,'IS' from bbgisettlement

/* Print " Deleted records form Trade " */

GO
