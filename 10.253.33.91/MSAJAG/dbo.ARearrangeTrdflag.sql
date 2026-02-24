-- Object: PROCEDURE dbo.ARearrangeTrdflag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE ARearrangeTrdflag ( @statusid varchar(12),@statusname varchar(12) )
AS 
Declare 
 @@trade_no varchar(14),
 @@Pqty numeric(9), 
 @@Sqty numeric(9),
 @@Ltrade_no varchar(14),
 @@Lqty numeric(9), 
 @@Pdiff numeric(9),
 @@Flag cursor,
 @@loop cursor,
 @@TPqty numeric(9), 
 @@TSqty numeric(9),
 @@TSell_Buy int,
 @@Party_code varchar(15), 
 @@Scrip_cd Varchar(20),
 @@Series Varchar(3),
 @@Participantcode Varchar(30),
 @@TMark varchar(3),
 @@Tparty_code Varchar(15),
 @@Tscrip_cd Varchar(20),
 @@Tseries Varchar(3),
 @@TParticipantcode Varchar(30),
 @@Tsett_type Varchar(3), 
 @@Sett_type varchar(3),
 @@TTmark Varchar (3),
 @@Scriploop Cursor

 /*  apply sett_flag = 1 to all trades where client2. tran_cat   = 'DEL' */

If @statusid = 'broker'
Begin 
  
 Update ATrade Set Settflag = 1  FROM ATrade t , CLIENT2 
 Where  CLIENT2.PARTY_CODE = t.PARTY_CODE 
 and (CLIENT2.tran_cat = 'DEL')  
  

 Update ATrade Set Settflag = (Case When Sell_Buy = 1 then 2 else 3 end )
 FROM ATrade , CLIENT2 
 where CLIENT2.PARTY_CODE = ATrade.PARTY_CODE 
 and ( CLIENT2.tran_cat = 'TRD'  )
 

 Set @@Flag = Cursor for
 Select Distinct T.Party_code,PartipantCode,Scrip_cd,Series,TMark
 From ATrade T , Client2 C2
 Where C2.Tran_cat = 'TRD'
 and C2.party_code = t.Party_code
 Order by T.Party_code,Scrip_cd,Series,Partipantcode,Tmark 
 
 Open @@Flag
 Fetch next from @@Flag into @@Party_code,@@Participantcode,@@Scrip_cd,@@Series,@@TMark

 Select @@Tpqty = 0
 Select @@Tsqty = 0

 Select @@Sqty = 0
 Select @@PQty = 0

 Select @@Tparty_code = @@Party_code
 Select @@TParticipantCode = @@ParticipantCode
 Select @@TScrip_cd = @@Scrip_cd
 Select @@Tseries = @@Series
 Select @@TTmark = @@Tmark   
 Select @@Party_code,@@Participantcode,@@Scrip_cd,@@Series,@@TSell_buy,@@TMark
  
  
 While ( (@@fetch_status = 0)  )
 Begin
      Select @@TSqty = Isnull(Sum(Tradeqty),0) from ATrade where Sell_buy = 2 
      and Party_code = @@TParty_code and Partipantcode = @@TParticipantcode
      and Scrip_cd = @@TScrip_cd and Series = @@TSeries and Tmark = @@Tmark 
       
      Select @@TPqty = Isnull(Sum(Tradeqty),0) from ATrade where Sell_buy = 1 
      and Party_code = @@TParty_code and Partipantcode = @@TParticipantcode
      and Scrip_cd = @@TScrip_cd and Series = @@TSeries and Tmark = @@Tmark 
      select @@TSqty,@@Tpqty
      If  @@TSqty = 0
      Begin
           Print '@@Sqty = 0'
           Update ATrade Set Settflag = 4
           Where Party_code = @@TParty_code 
           and Scrip_cd = @@Tscrip_cd 
           and Series = @@TSeries 
           and Sell_buy = 1 
           and Tmark like @@TMark +'%'
           and Partipantcode = @@TParticipantCode
       End
       If  @@TPqty = 0
       Begin
            Print '@@Pqty = 0'
            Update ATrade set Settflag = 5 
            Where party_code = @@Party_Code 
            and Scrip_cd = @@Scrip_Cd 
            and Series = @@Series 
            and Sell_buy = 2
            and Tmark like @@TMark +'%'
            and partipantcode = @@TParticipantcode
        End

         If  ( (@@TPqty > @@TSqty) and (@@TSqty > 0 )) 
         Begin 
              Print 'TPqty > TSqty'
              Select @@Pdiff = @@TPqty - @@TSqty
              Select @@PDiff
              Set @@Loop  = Cursor For 
              Select Trade_no,Tradeqty From ATrade
              Where Party_code = @@TParty_code 
              and Scrip_cd = @@TScrip_cd 
              and Series = @@TSeries 
              and Sell_buy = 1 
              and Partipantcode = @@TParticipantcode
              Order by Marketrate Desc  
              Open @@Loop
              Fetch Next From @@Loop Into @@Ltrade_no,@@Lqty
              Select @@Ltrade_no,@@Lqty    
              While ( @@Fetch_Status = 0 ) and (@@Pdiff > 0) 
              Begin
                   If @@Pdiff >= @@Lqty 
                   Begin
                        Print '@@Pdiff  > @@Lqty'
                        Update ATrade Set Settflag = 4   
                        Where Party_code = @@TParty_code 
                        and Scrip_cd = @@TScrip_cd 
                        and Series = @@TSeries 
                        and Sell_buy = 1 
                        and Trade_no = @@ltrade_no 
                        and Tradeqty = @@lqty  
                        and partipantcode = @@TParticipantCode
                        Select @@Pdiff = @@Pdiff - @@Lqty
                   End    
                   Else If @@Pdiff < @@Lqty 
                   Begin
                        Print '@@Pdiff  > @@Lqty'
                        Insert into ATrade select 'R'+Trade_No,Order_No,Status,Scrip_Cd,series,ScripName,Instrument,BookType,MarketType,User_Id,PARTIPANTCODE,Branch_Id,Sell_Buy,@@Pdiff,
                        MarketRate,Pro_Cli,Party_Code,AuctionPart,AuctionNo,SettNo,Sauda_Date,TradeModified,CpId,4,TMARK,scheme,Dummy1,Dummy2
                        From ATrade Where 
                        Party_code = @@TParty_code 
                        and Scrip_cd = @@TScrip_cd 
                        and Series = @@Tseries 
                        and Sell_buy = 1 
                        and Trade_no = @@ltrade_no 
                        and Tradeqty = @@lqty 
                        and PARTIPANTCODE = @@TPARTICIPANTCODE   
                        Update ATrade Set Settflag = 2,Tradeqty = @@Lqty - @@pdiff    
                        Where Party_code = @@TParty_Code 
                        and Scrip_cd = @@TScrip_cd  
                        and Sell_buy = 1 
                        and trade_no = @@ltrade_no 
                        and tradeqty = @@lqty 
                        and PARTIPANTCODE = @@PARTICIPANTCODE  
                        Select @@Pdiff = 0   
                    End
                    Fetch next from @@Loop into @@Ltrade_no,@@Lqty
                    Print ' Going for Next @@loop '  
                 End
                 Close @@Loop 
          End  
          
          If  ( (@@TPqty < @@TSqty) and (@@TPqty > 0 )) 
          Begin 
              Print '@@Pqty < @Sqty'
              Select @@Pdiff = @@TSqty - @@TPqty
              Select @@PDiff
              Set @@Loop  = Cursor For 
              Select Trade_no,Tradeqty From ATrade
              Where Party_code = @@TParty_code 
              and Scrip_cd = @@TScrip_cd 
              and Series = @@TSeries 
              and Sell_buy = 2 
              and Partipantcode = @@TParticipantcode
              Order by Marketrate Desc  
              Open @@Loop
              Fetch Next From @@Loop Into @@Ltrade_no,@@Lqty
              Select @@Ltrade_no,@@Lqty    
              While ( @@Fetch_Status = 0 ) and (@@Pdiff > 0) 
              Begin
                   Select @@Ltrade_no,@@Lqty,@@Pdiff
                   If @@Pdiff >= @@Lqty 
                   Begin
                        Print '@@Pdiff  > @@Lqty'
                        Update ATrade Set Settflag = 5   
                        Where Party_code = @@TParty_code 
                        and Scrip_cd = @@TScrip_cd 
                        and Series = @@TSeries 
                        and Sell_buy = 2 
                        and Trade_no = @@ltrade_no 
                        and Tradeqty = @@lqty  
                        and partipantcode = @@TParticipantCode
                        Select @@Pdiff = @@Pdiff - @@Lqty
                   End    
                   Else If @@Pdiff < @@Lqty 
                   Begin
                        Print '@@Pdiff  < @@Lqty'
                        Insert into ATrade select 'R'+Trade_No,Order_No,Status,Scrip_Cd,series,ScripName,Instrument,BookType,MarketType,User_Id,PARTIPANTCODE,Branch_Id,Sell_Buy,@@Pdiff,
                        MarketRate,Pro_Cli,Party_Code,AuctionPart,AuctionNo,SettNo,Sauda_Date,TradeModified,CpId,5,TMARK,scheme,Dummy1,Dummy2
                        From ATrade Where 
                        Party_code = @@TParty_code 
                        and Scrip_cd = @@TScrip_cd 
                        and Series = @@Tseries 
                        and Sell_buy = 2 
                        and Trade_no = @@ltrade_no 
                        and Tradeqty = @@lqty 
                        and PARTIPANTCODE = @@TPARTICIPANTCODE   
                        
                        Update ATrade Set Settflag = 3,Tradeqty = @@Lqty - @@pdiff    
                        Where Party_code = @@TParty_Code 
                        and Scrip_cd = @@TScrip_cd  
                        and Sell_buy = 2 
                        and trade_no = @@ltrade_no 
                        and tradeqty = @@lqty 
                        and PARTIPANTCODE = @@PARTICIPANTCODE  
                        Select @@Pdiff = 0   
                    End
                    Fetch next from @@Loop into @@Ltrade_no,@@Lqty
                    Print ' Going for Next @@loop '  
               End
               Close @@Loop  
            End
  Fetch next from @@Flag into @@Party_code,@@Participantcode,@@Scrip_cd,@@Series,@@TMark
  Select @@Party_code,@@Participantcode,@@Scrip_cd,@@Series,@@TSell_buy,@@TMark
  Select @@Tparty_code = @@Party_code
  Select @@TParticipantCode = @@ParticipantCode
  Select @@TScrip_cd = @@Scrip_cd
  Select @@Tseries = @@Series
  Select @@TTmark = @@Tmark   
  Select @@Tpqty = 0
  Select @@Tsqty = 0
  Select @@Sqty = 0
  Select @@PQty = 0
 
End
Close @@Flag
 Deallocate @@Flag  
End




If @statusid = 'BRANCH'
Begin 
  
 Update ATrade Set Settflag = 1  FROM ATrade t , CLIENT2 , Branches
 Where  CLIENT2.PARTY_CODE = t.PARTY_CODE 
 and (CLIENT2.tran_cat = 'DEL')  
 and T.user_id = branches.terminal_id		
  And Branches.Branch_cd = @StatusName
/* and branches.branch_cd = branch.branch_code 
 and branch.branch = @statusname 
*/
 Update ATrade Set Settflag = (Case When Sell_Buy = 1 then 2 else 3 end )
 FROM ATrade , CLIENT2 ,Client1
 where CLIENT2.PARTY_CODE = ATrade.PARTY_CODE 
 and ( CLIENT2.tran_cat = 'TRD'  )
  And Client1.Branch_cd = @StatusName
 and Client2.CL_code = Client1.Cl_code  

 Set @@Flag = Cursor for
 Select Distinct T.Party_code,PartipantCode,Scrip_cd,Series,TMark
 From ATrade T , Client2 C2, Client1
 Where C2.Tran_cat = 'TRD'
 and C2.party_code = t.Party_code
  And Client1.Branch_cd = @StatusName
 and C2.CL_code = Client1.Cl_code  
 Order by T.Party_code,Scrip_cd,Series,Partipantcode,Tmark 
 
 Open @@Flag
 Fetch next from @@Flag into @@Party_code,@@Participantcode,@@Scrip_cd,@@Series,@@TMark

 Select @@Tpqty = 0
 Select @@Tsqty = 0

 Select @@Sqty = 0
 Select @@PQty = 0

 Select @@Tparty_code = @@Party_code
 Select @@TParticipantCode = @@ParticipantCode
 Select @@TScrip_cd = @@Scrip_cd
 Select @@Tseries = @@Series
 Select @@TTmark = @@Tmark   
 Select @@Party_code,@@Participantcode,@@Scrip_cd,@@Series,@@TSell_buy,@@TMark
  
  
 While ( (@@fetch_status = 0)  )
 Begin
      Select @@TSqty = Isnull(Sum(Tradeqty),0) from ATrade where Sell_buy = 2 
      and Party_code = @@TParty_code and Partipantcode = @@TParticipantcode
      and Scrip_cd = @@TScrip_cd and Series = @@TSeries and Tmark = @@Tmark 
       
      Select @@TPqty = Isnull(Sum(Tradeqty),0) from ATrade where Sell_buy = 1 
      and Party_code = @@TParty_code and Partipantcode = @@TParticipantcode
      and Scrip_cd = @@TScrip_cd and Series = @@TSeries and Tmark = @@Tmark 
      select @@TSqty,@@Tpqty
      If  @@TSqty = 0
      Begin
           Print '@@Sqty = 0'
           Update ATrade Set Settflag = 4
           Where Party_code = @@TParty_code 
           and Scrip_cd = @@Tscrip_cd 
           and Series = @@TSeries 
           and Sell_buy = 1 
           and Tmark like @@TMark +'%'
           and Partipantcode = @@TParticipantCode
       End
       If  @@TPqty = 0
       Begin
            Print '@@Pqty = 0'
            Update ATrade set Settflag = 5 
            Where party_code = @@Party_Code 
            and Scrip_cd = @@Scrip_Cd 
            and Series = @@Series 
            and Sell_buy = 2
            and Tmark like @@TMark +'%'
            and partipantcode = @@TParticipantcode
        End

         If  ( (@@TPqty > @@TSqty) and (@@TSqty > 0 )) 
         Begin 
              Print 'TPqty > TSqty'
              Select @@Pdiff = @@TPqty - @@TSqty
              Select @@PDiff
              Set @@Loop  = Cursor For 
              Select Trade_no,Tradeqty From ATrade
              Where Party_code = @@TParty_code 
              and Scrip_cd = @@TScrip_cd 
              and Series = @@TSeries 
              and Sell_buy = 1 
              and Partipantcode = @@TParticipantcode
              Order by Marketrate Desc  
              Open @@Loop
              Fetch Next From @@Loop Into @@Ltrade_no,@@Lqty
              Select @@Ltrade_no,@@Lqty    
              While ( @@Fetch_Status = 0 ) and (@@Pdiff > 0) 
              Begin
                   If @@Pdiff >= @@Lqty 
                   Begin
                        Print '@@Pdiff  > @@Lqty'
                        Update ATrade Set Settflag = 4   
                        Where Party_code = @@TParty_code 
                        and Scrip_cd = @@TScrip_cd 
                        and Series = @@TSeries 
                        and Sell_buy = 1 
                        and Trade_no = @@ltrade_no 
                        and Tradeqty = @@lqty  
                        and partipantcode = @@TParticipantCode
                        Select @@Pdiff = @@Pdiff - @@Lqty
                   End    
                   Else If @@Pdiff < @@Lqty 
                   Begin
                        Print '@@Pdiff  > @@Lqty'
                        Insert into ATrade select 'R'+Trade_No,Order_No,Status,Scrip_Cd,series,ScripName,Instrument,BookType,MarketType,User_Id,PARTIPANTCODE,Branch_Id,Sell_Buy,@@Pdiff,
                        MarketRate,Pro_Cli,Party_Code,AuctionPart,AuctionNo,SettNo,Sauda_Date,TradeModified,CpId,4,TMARK,scheme,Dummy1,Dummy2
                        From ATrade Where 
                        Party_code = @@TParty_code 
                        and Scrip_cd = @@TScrip_cd 
                        and Series = @@Tseries 
                        and Sell_buy = 1 
                        and Trade_no = @@ltrade_no 
                        and Tradeqty = @@lqty 
                        and PARTIPANTCODE = @@TPARTICIPANTCODE   
                        Update ATrade Set Settflag = 2,Tradeqty = @@Lqty - @@pdiff    
                        Where Party_code = @@TParty_Code 
                        and Scrip_cd = @@TScrip_cd  
                        and Sell_buy = 1 
                        and trade_no = @@ltrade_no 
                        and tradeqty = @@lqty 
                        and PARTIPANTCODE = @@PARTICIPANTCODE  
                        Select @@Pdiff = 0   
                    End
                    Fetch next from @@Loop into @@Ltrade_no,@@Lqty
                    Print ' Going for Next @@loop '  
                 End
                 Close @@Loop 
          End  
          
          If  ( (@@TPqty < @@TSqty) and (@@TPqty > 0 )) 
          Begin 
              Print '@@Pqty < @Sqty'
              Select @@Pdiff = @@TSqty - @@TPqty
              Select @@PDiff
              Set @@Loop  = Cursor For 
              Select Trade_no,Tradeqty From ATrade
              Where Party_code = @@TParty_code 
              and Scrip_cd = @@TScrip_cd 
              and Series = @@TSeries 
              and Sell_buy = 2 
              and Partipantcode = @@TParticipantcode
              Order by Marketrate Desc  
              Open @@Loop
              Fetch Next From @@Loop Into @@Ltrade_no,@@Lqty
              Select @@Ltrade_no,@@Lqty    
              While ( @@Fetch_Status = 0 ) and (@@Pdiff > 0) 
              Begin
                   Select @@Ltrade_no,@@Lqty,@@Pdiff
                   If @@Pdiff >= @@Lqty 
                   Begin
                        Print '@@Pdiff  > @@Lqty'
                        Update ATrade Set Settflag = 5   
                        Where Party_code = @@TParty_code 
                        and Scrip_cd = @@TScrip_cd 
                        and Series = @@TSeries 
                        and Sell_buy = 2 
                        and Trade_no = @@ltrade_no 
                        and Tradeqty = @@lqty  
                        and partipantcode = @@TParticipantCode
                        Select @@Pdiff = @@Pdiff - @@Lqty
                   End    
                   Else If @@Pdiff < @@Lqty 
                   Begin
                        Print '@@Pdiff  < @@Lqty'
                        Insert into ATrade select 'R'+Trade_No,Order_No,Status,Scrip_Cd,series,ScripName,Instrument,BookType,MarketType,User_Id,PARTIPANTCODE,Branch_Id,Sell_Buy,@@Pdiff,
                        MarketRate,Pro_Cli,Party_Code,AuctionPart,AuctionNo,SettNo,Sauda_Date,TradeModified,CpId,5,TMARK,scheme,Dummy1,Dummy2
                        From ATrade Where 
                        Party_code = @@TParty_code 
                        and Scrip_cd = @@TScrip_cd 
                        and Series = @@Tseries 
                        and Sell_buy = 2 
                        and Trade_no = @@ltrade_no 
                        and Tradeqty = @@lqty 
                        and PARTIPANTCODE = @@TPARTICIPANTCODE   
                        
                        Update ATrade Set Settflag = 3,Tradeqty = @@Lqty - @@pdiff    
                        Where Party_code = @@TParty_Code 
                        and Scrip_cd = @@TScrip_cd  
                        and Sell_buy = 2 
                        and trade_no = @@ltrade_no 
                        and tradeqty = @@lqty 
                        and PARTIPANTCODE = @@PARTICIPANTCODE  
                        Select @@Pdiff = 0   
                    End
                    Fetch next from @@Loop into @@Ltrade_no,@@Lqty
                    Print ' Going for Next @@loop '  
               End
               Close @@Loop  
            End
  Fetch next from @@Flag into @@Party_code,@@Participantcode,@@Scrip_cd,@@Series,@@TMark
  Select @@Party_code,@@Participantcode,@@Scrip_cd,@@Series,@@TSell_buy,@@TMark
  Select @@Tparty_code = @@Party_code
  Select @@TParticipantCode = @@ParticipantCode
  Select @@TScrip_cd = @@Scrip_cd
  Select @@Tseries = @@Series
  Select @@TTmark = @@Tmark   
  Select @@Tpqty = 0
  Select @@Tsqty = 0
  Select @@Sqty = 0
  Select @@PQty = 0
 
End
 Close @@Flag
 Deallocate @@Flag  
End

GO
