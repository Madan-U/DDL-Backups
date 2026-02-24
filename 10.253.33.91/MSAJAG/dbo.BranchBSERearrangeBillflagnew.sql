-- Object: PROCEDURE dbo.BranchBSERearrangeBillflagnew
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE  BranchBSERearrangeBillflagnew (@Sett_No varchar(7),@Sett_Type varchar(3),@statusid varchar(12),@statusname varchar(12)) AS  
declare 
 @@trade_no varchar(14),
 @@Party_code varchar(10),
 @@Participantcode Varchar(25),
 @@Scrip_Cd varchar(12),  
 @@series varchar(3),
 @@TMark Varchar(3),
 @@Pqty numeric(9), 
 @@Sqty numeric(9),
 @@Ltrade_no varchar(14),
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


 Select @@Lo = 'N'
 Select @@Cur = 'N'  
 Select @@CF = 0
 Set @@Loop = Cursor For
 Select  left(Convert(Varchar,Start_date,109),11),  left(Convert(Varchar,End_date,109),11) from
 Sett_mst where Sett_no = @Sett_no and sett_type = @Sett_type

Open @@Loop 
Fetch Next  from @@Loop  into @@Sdate,@@Edate
Close @@Loop
Deallocate @@Loop

 If @StatusId = 'Branch'
 Begin
      If @@Sdate = @@Edate 
      Begin
	   Print 'In Sdate = Edate'
	   Update Settlement Set Billflag = Settflag  , Tmark = (Case when Settflag > 3 Then 'D' Else 'N' End)  from settlement , Client2 ,Client1
      	   where Sett_no = @Sett_no and Sett_type = @Sett_type
      	   and client2.party_code = Settlement.party_code and client2.tran_cat = 'TRD'
           And Client1.Branch_cd = @StatusName
           And client2.cl_code = Client1.cl_code
      End
 End

 If @StatusId = 'BROKER'
 Begin
      If @@Sdate = @@Edate 
      Begin
	   Print 'In Sdate = Edate'
	   Update Settlement Set Billflag = Settflag  , Tmark = (Case when Settflag > 3 Then 'D' Else 'N' End)  from settlement , Client2 
      	   where Sett_no = @Sett_no and Sett_type = @Sett_type
      	   and client2.party_code = Settlement.party_code and client2.tran_cat = 'TRD'
      End
 End



 If ( (@@Sdate <> @@Edate)    )
 Begin
    	If (@@Sdate <> @@Edate)
        Begin
                If @StatusId = 'Branch'
                Begin   
        	      Print 'In  (@@Sdate <> @@Edate) '
                      Update settlement set Tmark = 'N', billflag = ( case  when sell_buy = 1 then 2 else 3 end)  from settlement,Client2 ,Client1  where
                      Settlement.party_code = Client2.party_code
                      and client2.tran_cat = 'TRD'
                      and sett_type = @Sett_type
                      and Sett_no = @sett_no
                      And Client1.Branch_cd = @StatusName
                     And client2.cl_code = Client1.cl_code

                      Select  S.Party_code,s.Scrip_cd,s.Series, TMark,partipantcode,Pqty = ( Case when sell_buy  = 1 Then Sum(tradeqty) Else 0 End),Sqty = ( Case when sell_buy  = 2 Then Sum(tradeqty) Else 0 End),Sell_buy
                      Into #BranchMypos  From Settlement S,Client2 C2,client1
                      Where S.sett_no = @Sett_no
                      And S.sett_type = @Sett_type
                      and C2.Tran_cat = 'TRD'
                      and s.Party_code = c2.party_code
                     And Client1.Branch_cd = @StatusName
                      And c2.cl_code = Client1.cl_code
                      Group by  S.Party_code,s.Scrip_cd,s.Series, partipantcode,Sell_buy,Tmark
                      Order by s.Party_code,s.Scrip_cd,s.Series,partipantcode,Tmark 
               End

               If @StatusId = 'Broker'
               Begin   
        	      Print 'In  (@@Sdate <> @@Edate) '
                      Update settlement set Tmark = 'N', billflag = ( case  when sell_buy = 1 then 2 else 3 end)  from settlement,Client2  where
                      Settlement.party_code = Client2.party_code
                      and client2.tran_cat = 'TRD'
                      and sett_type = @Sett_type
                      and Sett_no = @sett_no
                      Select  S.Party_code,s.Scrip_cd,s.Series, TMark,partipantcode,Pqty = ( Case when sell_buy  = 1 Then Sum(tradeqty) Else 0 End),Sqty = ( Case when sell_buy  = 2 Then Sum(tradeqty) Else 0 End),Sell_buy
                      Into #Mypos  From Settlement S,Client2 C2
                      Where S.sett_no = @Sett_no
                      And S.sett_type = @Sett_type
                      and C2.Tran_cat = 'TRD'
                      and s.Party_code = c2.party_code
                      Group by  S.Party_code,s.Scrip_cd,s.Series, partipantcode,Sell_buy,Tmark
                      Order by s.Party_code,s.Scrip_cd,s.Series,partipantcode,Tmark 
               End
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
        Select @@Party_code,@@Scrip_cd,@@Series,@@TMark,@@Participantcode,@@PQty,@@Sqty

           
        While ( (@@fetch_status = 0)  )
        Begin
        	Select @@Cur = 'Y'
                Select @@Party_code,@@Scrip_cd,@@Series,@@TMark,@@Participantcode,@@PQty,@@Sqty
                If  @@Sqty = 0
                Begin
                	Update Settlement Set BillFlag = 4  ,Tmark = ( Case  When @@CF <> 0  Then 'N' Else 'D'  End) 
                	Where Party_code = @@Party_code 
                 	and Scrip_cd = @@Scrip_cd 
                     	and Series = @@Series 
                     	and Sell_buy = 1 
                     	and Sett_Type = @Sett_type 
                     	and Sett_no = @Sett_no
                     	and Tmark like @@TMark 
/*                     	and ( Tmark <> 'D'  ) */
                     	and partipantcode = @@Participantcode
                End
                
	If  @@Pqty = 0
                Begin
               		Update Settlement Set BillFlag = 5 , Tmark = ( Case  When @@CF <> 0  Then 'N' Else 'D'  End)
                   	Where party_code = @@Party_code 
                     	and Scrip_cd = @@Scrip_cd 
                 	and Series = @@Series 
                 	and Sell_buy = 2
                 	and Sett_Type = @Sett_type 
                 	and Sett_no = @Sett_no
                 	and Tmark like @@TMark  
  /*               	and ( tmark <> 'D' )  */
                 	and partipantcode = @@Participantcode
            	End

      	If  ( (@@Pqty > @@Sqty) and (@@Sqty > 0 )) 
            	Begin 
                	Select @@Pdiff = @@Pqty - @@Sqty 
	                Print ' in Pqty > Sqty '
        	                Select @@Pdiff
                	Set @@Loop  = Cursor For 
                	Select Trade_no,Tradeqty From Settlement 
                 	Where Party_code = @@Party_code 
                 	and Scrip_cd = @@Scrip_cd 
                 	and Series = @@Series 
                 	and Sell_buy = 1 
                 	and Sett_no = @Sett_no 
                 	and Sett_Type = @Sett_type 
                 	and Tmark like @@TMark  
/*                 	and  ( Tmark <> 'D')  */
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
                      		Else If @@Pdiff < @@Lqty 
                      		Begin                                                                                                                                                                                                                                                                                               
                           		Insert into Settlement                                                        
                           		Select ContractNo,BillNo,'R'+Trade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,4,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type  ,partipantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,Tmark /* = ( Case  When @@CF <> 0  Then 'N' Else 'D'  End)*/ ,scheme,Dummy1,Dummy2       
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
		If ((@@Pqty < @@Sqty) And (@@PQty > 0 ))  
        	Begin 
             		Select @@Pdiff = @@Sqty - @@Pqty 
            		Print ' in Pqty > Sqty '
             		Select @@Pdiff
     
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
                  		If @@Pdiff >= @@Lqty 
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
                       	/*		and ( tmark <> 'D' )   */
                       			and partipantcode = @@Participantcode
                                
                       			Select @@Pdiff = @@Pdiff - @@Lqty
                  		End    
                  		Else If @@Pdiff < @@Lqty 
                  		Begin                                                                                                                                                                                                                                                                                               
                       			Insert into Settlement                                                        
                       			Select ContractNo,BillNo,'R'+Trade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,5,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type  ,partipantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,Tmark  ,scheme,Dummy1,Dummy2       
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
 Close @@Loop
 Deallocate @@Loop
Close @@Flag 
Deallocate @@Flag
 End

Exec BranchNewupdbilltax @Sett_No ,@Sett_Type,@statusid ,@statusname
Exec BranchInsproc @Sett_No ,@Sett_Type,@statusid ,@statusname
Exec BRanchDelpositionUp @Sett_no ,@Sett_type,'%','%',@statusid,@statusname

GO
