-- Object: PROCEDURE dbo.BSERearrangeBillflagnew_T1Change_25022022
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROCEDURE  [dbo].[BSERearrangeBillflagnew_T1Change_25022022] (@Sett_No varchar(7),@Sett_Type varchar(3)) AS    
declare   
 @@trade_no varchar(20),  
 @@Party_code varchar(10),  
 @@Participantcode Varchar(25),  
 @@Scrip_Cd varchar(12),    
 @@series varchar(3),  
 @@TMark Varchar(3),  
 @@Pqty numeric(9),   
 @@Sqty numeric(9),  
 @@Ltrade_no varchar(20),  
 @@Lqty numeric(9),   
 @@Pdiff numeric(9),  
 @@Flag cursor,  
 @@loop cursor,  
 @@Sdate Varchar(11),  
 @@Edate Varchar(11),  
 @@CF Int,  
 @@Lo Varchar(1),  
 @@Cur Varchar(1),  
 @@ICf Int   
  
If Upper(LTrim(RTrim(@Sett_type))) = 'W'   
Begin   
 Update settlement Set BillFlag = (Case When Sell_Buy = 1 Then 4 Else 5 End)   
 FROM settlement t , CLIENT2   
 Where CLIENT2.PARTY_CODE = T.party_code  
 and (CLIENT2.tran_cat = 'TRD' )    
 and sett_type = @Sett_type  
 and Sett_no = @Sett_no  
End  
Else  
Begin  
  
 Select @@Lo = 'N'  
 Select @@Cur = 'N'    
 Select @@CF = 0  
 Set @@Loop = Cursor For  
 Select  left(Convert(Varchar,Min(Sauda_date),109),11),  left(Convert(Varchar,Max(Sauda_date),109),11) from  
 Settlement where Sett_no = @Sett_no and sett_type = @Sett_type  
  
Open @@Loop   
Fetch Next  from @@Loop  into @@Sdate,@@Edate  
Close @@Loop  
Deallocate @@Loop  
 
	Update Settlement Set Billflag = Settflag  , Tmark = (Case when Settflag > 3 Then 'D' Else 'N' End)  from settlement , Client2   
	where Sett_no = @Sett_no and Sett_type = @Sett_type  
	and client2.party_code = Settlement.party_code and client2.tran_cat = 'TRD'  
  
 If @@Sdate <> @@Edate   
 Begin  
		Select Distinct Scrip_CD, Series into #SettND From Settlement Where Sett_no = @Sett_no and Sett_type = @Sett_type and sauda_date not like @@Edate + '%'
 End  

  
 If ( (@@Sdate <> @@Edate)    )  
 Begin  
     If (@@Sdate <> @@Edate)  
        Begin  
                Update settlement set Tmark = 'N', billflag = ( case  when sell_buy = 1 then 2 else 3 end)  from settlement,Client2  where  
                Settlement.party_code = Client2.party_code  
                and client2.tran_cat = 'TRD'  
                and sett_type = @Sett_type  
                and Sett_no = @sett_no  
   								 and scrip_cd in ( Select Scrip_CD From #SettND) 

                Select  S.Party_code,s.Scrip_cd,s.Series, TMark,partipantcode,Pqty = ( Case when sell_buy  = 1 Then Sum(tradeqty) Else 0 End),Sqty = ( Case when sell_buy  = 2 Then Sum(tradeqty) Else 0 End),Sell_buy  
                Into #Mypos  From Settlement S,Client2 C2  
                Where S.sett_no = @Sett_no  
                And S.sett_type = @Sett_type  
                and C2.Tran_cat = 'TRD'  
                and s.Party_code = c2.party_code  
   								 and scrip_cd in ( Select Scrip_CD From #SettND) 
                Group by  S.Party_code,s.Scrip_cd,s.Series, partipantcode,Sell_buy,Tmark  
                Order by s.Party_code,s.Scrip_cd,s.Series,partipantcode,Tmark   
        End  
         
        Set @@Flag = Cursor for  
        Select Party_code ,Scrip_cd,   Series, TMark ,partipantcode, Sum(Pqty),Sum(Sqty) from #mypos  
        Group by  
        Party_code, Scrip_cd,   Series ,  TMark, partipantcode  
        having sum(Pqty) <> Sum(Sqty)  
        Order by Party_code,Scrip_cd,Series,partipantcode,Tmark   
End  
  
  
 If (@@Sdate <> @@Edate)  
 Begin  
        Open @@Flag  
        Fetch next from @@Flag into @@Party_code,@@Scrip_cd,@@Series,@@TMark,@@Participantcode,@@PQty,@@Sqty  
   
             
        While ( (@@fetch_status = 0)  )  
        Begin  
         Select @@Cur = 'Y'  
                If  @@Sqty = 0 and @@fetch_status = 0  
                Begin  
                 Update Settlement Set BillFlag = 4  ,Tmark = ( Case  When @@CF <> 0  Then 'N' Else 'D'  End)   
                 Where Party_code = @@Party_code   
                  and Scrip_cd = @@Scrip_cd   
                      and Series = @@Series   
                      and Sell_buy = 1   
                      and Sett_Type = @Sett_type   
                      and Sett_no = @Sett_no  
                      and Tmark like @@TMark   
                      and partipantcode = @@Participantcode  
                End  
                  
 If  @@Pqty = 0 and @@fetch_status = 0  
                Begin  
                 Update Settlement Set BillFlag = 5 , Tmark = ( Case  When @@CF <> 0  Then 'N' Else 'D'  End)  
                    Where party_code = @@Party_code   
                      and Scrip_cd = @@Scrip_cd   
                  and Series = @@Series   
                  and Sell_buy = 2  
                  and Sett_Type = @Sett_type   
                  and Sett_no = @Sett_no  
                  and Tmark like @@TMark    
                  and partipantcode = @@Participantcode  
             End  
  
       If  ( (@@Pqty > @@Sqty) and (@@Sqty > 0 ) and @@fetch_status = 0)   
             Begin   
                 Select @@Pdiff = @@Pqty - @@Sqty   
                 Set @@Loop  = Cursor For   
                 Select Trade_no,Tradeqty From Settlement   
                  Where Party_code = @@Party_code   
                  and Scrip_cd = @@Scrip_cd   
                  and Series = @@Series   
                  and Sell_buy = 1   
                  and Sett_no = @Sett_no   
                  and Sett_Type = @Sett_type   
                  and Tmark like @@TMark    
                  and partipantcode = @@Participantcode  
                  Order by Marketrate Desc    
                  Open @@Loop  
                  Fetch Next From @@Loop Into @@Ltrade_no,@@Lqty  
        
             While ( @@Fetch_Status = 0 ) and (@@Pdiff > 0)   
                  Begin  
                        Select @@Lo = 'Y'   
                        If @@Pdiff >= @@Lqty   
                        Begin  
                             Update Settlement Set Billflag = 4 /* ,Tmark = ( Case  When @@CF <> 0  Then 'N' Else 'D'  End)  */  
                             Where Party_code = @@Party_code   
                             and Scrip_cd = @@Scrip_cd   
                             and Series = @@Series   
                             and Sell_buy = 1   
                             and Trade_no = @@ltrade_no   
                             and Tradeqty = @@lqty  
                             and Sett_no = @Sett_no    
                             and Sett_Type = @Sett_type    
                             and Tmark like @@TMark    
                             and partipantcode = @@Participantcode  
                             Select @@Pdiff = @@Pdiff - @@Lqty  
                        End      
                        Else If @@Pdiff < @@Lqty and @@fetch_status = 0   
                        Begin                                                                                                                                                                                                                                 
   
  
  
                                                               
                             Insert into Settlement                                                          
                             Select ContractNo,BillNo,'X'+Trade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,
																			Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,4,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type  ,partipantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,Tmark ,
																			scheme,Dummy1,Dummy2         
                             From Settlement Where   
                             Party_code = @@Party_code   
                             and Scrip_cd = @@Scrip_cd   
                             and Series = @@Series   
                             and Sell_buy = 1   
                             and Trade_no = @@ltrade_no   
                             and tradeqty = @@lqty    
                             and Sett_no = @Sett_no  
                             and Sett_Type = @Sett_type    
                             and tmark like @@TMark    
                             and partipantcode = @@Participantcode  
                               
   Update Settlement Set Billflag = 2,Tradeqty = @@Lqty - @@Pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate    /* ,Tmark = 'N'*/  
                             Where Party_code = @@Party_code   
                             and Scrip_cd = @@Scrip_cd   
                             and Series = @@Series   
                             and Sell_Buy = 1   
                              and Trade_no = @@LTrade_no   
                             and Tradeqty = @@LQty  
                             and Sett_no = @Sett_no  
                             and Sett_Type = @Sett_type    
                             and Tmark like @@TMark    
                             and partipantcode = @@Participantcode            
                             Select @@Pdiff = 0    
                          End  
                     Fetch next from @@Loop into @@Ltrade_no,@@Lqty  
                End  
                End  
  If ((@@Pqty < @@Sqty) And (@@PQty > 0 ) and @@fetch_status = 0)    
         Begin   
               Select @@Pdiff = @@Sqty - @@Pqty   
       
               Set @@Loop  = Cursor For   
               Select Trade_no,Tradeqty From Settlement   
               Where Party_code = @@Party_code   
               and Scrip_cd = @@Scrip_cd   
               and Series = @@Series   
               and Sell_buy = 2   
               and Sett_no = @Sett_no    
               and Sett_Type = @Sett_type   
               and Tmark like @@TMark    
               and partipantcode = @@Participantcode  
               Order by Marketrate Desc    
               Open @@Loop  
               Fetch Next From @@Loop Into @@Ltrade_no,@@Lqty  
               While ( @@Fetch_Status = 0 ) and (@@Pdiff > 0)   
               Begin  
                    If @@Pdiff >= @@Lqty and @@fetch_status = 0  
                    Begin  
                          Update Settlement Set Billflag = 5  /* , Tmark = ( Case  When @@CF <> 0  Then 'N' Else 'D'  End)  */  
                          Where Party_code = @@Party_code  
                          and Scrip_cd = @@Scrip_cd  
                          and Series = @@Series   
                          and Sell_buy = 2   
                          and Trade_no = @@ltrade_no   
                          and Tradeqty = @@lqty  
                          and Sett_no = @Sett_no    
                          and Sett_Type = @Sett_type    
                          and Tmark like @@TMark    
                          and partipantcode = @@Participantcode  
                                  
                          Select @@Pdiff = @@Pdiff - @@Lqty  
                    End      
                    Else If @@Pdiff < @@Lqty and @@fetch_status = 0  
                    Begin                                                                                                                                                                                                                                      
  
  
  
                                                           
                          Insert into Settlement                                                          
                          Select ContractNo,BillNo,'X'+Trade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,  
           MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,  
           Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,  
           @@Pdiff*MarketRate,5,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type  ,partipantCode,Status,Pro_Cli,CpId,Instrument,  
           BookType,Branch_Id,Tmark  ,scheme,Dummy1,Dummy2         
                          From Settlement Where   
                          Party_code = @@Party_code   
                          and Scrip_cd = @@Scrip_cd   
                          and Series = @@Series   
                          and Sell_buy = 2   
                          and Trade_no = @@ltrade_no   
        and Tradeqty = @@lqty   
                          and Sett_no = @Sett_no   
                          and Sett_Type = @Sett_type    
                          and tmark like @@TMark    
                          and partipantcode = @@Participantcode  
                          Update Settlement Set Billflag = 3,Tradeqty = @@Lqty - @@Pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate /* ,Tmark = 'N'   */  
                          Where Party_code = @@Party_code   
                          and Scrip_cd = @@Scrip_cd   
                          and Series = @@Series   
                          and Sell_Buy = 2  
                          and Trade_no = @@LTrade_no   
                          and Tradeqty = @@LQty  
                          and Sett_no = @Sett_no  
                          and Sett_Type = @Sett_type    
                          and Tmark like @@TMark    
                          and partipantcode = @@Participantcode            
                          Select @@Pdiff = 0    
                    End  
                    Fetch next from @@Loop into @@Ltrade_no,@@Lqty  
               End  
   End  
            Fetch next from @@Flag into @@Party_code,@@Scrip_cd,@@Series,@@TMark,@@Participantcode,@@PQty,@@Sqty  
  
       End  
Close @@Flag   
Deallocate @@Flag  
 End  
End  
  
Exec Newupdbilltax @Sett_No ,@Sett_Type

GO
