-- Object: PROCEDURE dbo.V2_ClientFundingProc
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE Proc V2_ClientFundingProc  
(  
      @startdate varchar(11),  
      @enddate varchar(11),  
      @fparty varchar(10),  
      @tparty varchar(10)  
)  
  
As  
  
/*----------------------------------------------------------------------------------------------------------------------  
Client Funding Process: Final Version Sep 16 2005  
----------------------------------------------------------------------------------------------------------------------*/  
      Set NoCount On  
        
      if @startdate = '' OR len(ltrim(rtrim(@startdate))) <> 11  
      begin  
            Select rundate = getdate(), rundate_109 = 'Please enter correct start date'  
            return  
      end  
        
      if @enddate = '' OR len(ltrim(rtrim(@enddate))) <> 11  
      begin  
            Select rundate = getdate(), rundate_109 = 'Please enter correct end date'  
            return  
      end  
        
        
      Declare  
            @LedrCur Cursor,   
            @rundate varchar(11),  
            @datediff int  
              
      Select @datediff = DateDiff(day,convert(datetime,@startdate),convert(datetime,@enddate))  
        
      if @datediff < 0   
      begin  
            Select rundate = getdate(), rundate_109 = 'Start Date cannot be greater than End Date'  
            return  
      end  
        
      if @datediff > 15   
      begin  
            Select rundate = getdate(), rundate_109 = 'Process cannot be executed for more than 15 days'  
            return  
      end  
        
      Create Table #DateCount  
      (        
            RunDate datetime  
      )  
  
/*----------------------------------------------------------------------------------------------------------------------  
Cursor to get the Pay-In dates for which process is to be executed based on the parameters provided.  
----------------------------------------------------------------------------------------------------------------------*/  
      Set @LedrCur = Cursor For                       
  
      /*-----------------------  
      Cursor Query Begins  
      -------------------------*/  
            Select Distinct   
                  RunDate = left(convert(varchar,PayIn_Date,109),11)   
            from   
                  AccBill   
            Where PayIn_Date Between @startdate And @enddate + ' 23:59'  
        
            Union   
        
            Select Distinct   
                  RunDate = left(convert(varchar,RunDate,109),11)   
            from   
                  Tblgrossexpnewdetail (nolock)  
            Where   
                  RunDate Between @startdate And @enddate + ' 23:59'   
      /*-----------------------  
      Cursor Query Ends  
      -------------------------*/  
        
      Open @LedrCur                      
      Fetch Next From @LedrCur   
      into   
            @rundate  
  
      While @@Fetch_Status = 0                      
      Begin                      
            if @rundate = '' OR len(ltrim(rtrim(@rundate))) <> 11  
            begin  
                  Select rundate = getdate(), rundate_109 = 'Date Not Found'  
                  return  
            end  
              
            if @fparty = '' set @fparty = '0000000000'  
            if @tparty = '' set @tparty = 'ZZZZZZZZZZ'  
        
      /*----------------------------------------------------------------------------------------------------------------------  
      Populate Clients having either,   
      VarMargin requirement for the Date   
      OR   
      Bills due for the Date  
      ----------------------------------------------------------------------------------------------------------------------*/  
            Truncate Table V2_ClientFundingData_Up   
        
            Insert Into   
                  V2_ClientFundingData_Up   
            Select   
                  RunDate = @rundate,  
                  Exchange = 'NSE',  
                  Segment = 'CAPITAL',  
                  Party_Code,  
                  VarMargin = Sum(VarMargin),   
                  Collateral_Cash = 0,  
               Collateral_NonCash = 0,  
                  Collateral_Total = 0,  
                  MarginFunding = 0,  
                  BillAmount = Sum(BillAmount),  
                  LedBal = 0,  
                  FutureBills = 0,  
                  BillFunding = 0,  
                  TotalFunding = 0  
            From   
                  (  
                        Select   
                              Party_Code,   
                              BillAmount = Sum(Case When Sell_Buy = 1 Then -Amount Else Amount End),   
                              VarMargin = 0   
                        From   
                              Accbill (nolock)  
                        Where   
                              left(convert(varchar,PayIn_Date,109),11) = @rundate   
                              and Party_Code Between @fparty And @tparty  
                        Group By  
                              Party_Code  
                        Having   
                              Sum(Case When Sell_Buy = 1 Then -Amount Else Amount End) <> 0  
  
                        Union All                    
  
                        Select   
                              Party_Code,   
                              BillAmount = 0,   
                              VarMargin = Sum(-VarMargin)   
                        From   
                              Tblgrossexpnewdetail (nolock)  
                        Where   
                              left(convert(varchar,RunDate,109),11) = @rundate   
                              and Party_Code Between @fparty And @tparty  
                        Group by   
                              Party_Code  
                        Having   
                              Sum(VarMargin) <> 0  
                  ) V  
            Group By  
                  Party_Code  
        
  
      /*----------------------------------------------------------------------------------------------------------------------  
      Delete query to ignore Clients of Type 'REM'  
      ----------------------------------------------------------------------------------------------------------------------*/  
      Delete   
            V2_ClientFundingData_Up  
      From   
            (  
                  select   
                        x.Party_Code   
                  from   
                        V2_ClientFundingData_up x  
                        left outer Join  
                        (     
                              select   
                                    c2.Party_code,   
                                    c1.Cl_type  
                              from   
                                    Client1 c1,   
                                    client2 c2  
                              Where    
                                    C1.Cl_Code = C2.Cl_Code  
                        ) y  
                        on   
                        (  
                              Y.party_code = x.party_Code  
                        )  
                  where   
                        isnull(Y.cl_Type,'REM') = 'REM'  
            ) ABC  
      where   
            V2_ClientFundingData_Up.party_code = ABC.party_code  
  
  
      /*----------------------------------------------------------------------------------------------------------------------  
      Update Collateral Information for clients in Temp table  
      ----------------------------------------------------------------------------------------------------------------------*/  
            Update   
                  V2_ClientFundingData_Up         
            Set   
                  Collateral_Cash = ActualCash,  
                  Collateral_NonCash = ActualNonCash,  
                  Collateral_Total = EffectiveColl  
            From   
                  msajag..collateral c (nolock)   
            Where   
                  left(convert(varchar,Trans_Date,109),11) = @rundate   
                  And V2_ClientFundingData_Up.Party_Code = c.Party_Code   
                  And V2_ClientFundingData_Up.Exchange = c.Exchange  
                  And V2_ClientFundingData_Up.Segment = c.Segment  
        
        
      /*----------------------------------------------------------------------------------------------------------------------  
      Update Voucher Date wise Ledger Balance for clients in Temp table  
      ----------------------------------------------------------------------------------------------------------------------*/  
            Update   
                  V2_ClientFundingData_Up         
            Set   
                  LedBal = L.LedBal  
            From   
                  (  
                  Select  
                        CltCode,    
                        LedBal = Sum(Case When DrCr = 'D' then -vamt else vamt end)  
                  From  
                        Account..Ledger L (nolock), Account..Parameter P (nolock)  
                  Where   
                        Vdt >= SdtCur  
                        And Vdt <= @rundate + ' 23:59'  
                        And @rundate between SdtCur And LdtCur  
                        And CltCode In (Select Party_Code From V2_ClientFundingData_Up (nolock))  
                  Group By   
                        CltCode  
                  ) L  
            Where        
                  Party_Code = CltCode   
        
        
      /*----------------------------------------------------------------------------------------------------------------------  
      Update Ledger Balance : Reduce the Amounts for Bills to be settled in future dates.  
      ----------------------------------------------------------------------------------------------------------------------*/  
            Update   
                  V2_ClientFundingData_Up         
            Set   
                  LedBal = LedBal - B.BillAmount,    
                  FutureBills = B.BillAmount   
            From   
                  (  
                        Select   
                              CltCode = Party_Code,   
                              BillAmount = Sum(Case When Sell_Buy = 1 Then -Amount Else Amount End)   
                        From   
                              Accbill (nolock)  
                        Where   
                              PayIn_Date > @rundate + ' 23:59'  
                              and Start_Date <= @rundate + ' 23:59'  
                              and Party_Code Between @fparty And @tparty  
                        Group By  
                              Party_Code  
                        Having   
                              Sum(Case When Sell_Buy = 1 Then -Amount Else Amount End) <> 0  
                  ) B   
            Where        
                  Party_Code = CltCode   
        
        
      /*----------------------------------------------------------------------------------------------------------------------  
      Update Margin Funding Amount after adjusting Var Margin Requirement (-ve) with Total Collateral (+ve)  
      Where Var Margin Requirement (-ve) + Total Collateral (+ve) is less than zero.  
      ----------------------------------------------------------------------------------------------------------------------*/  
            Update   
                  V2_ClientFundingData_Up         
            Set   
                  MarginFunding =   
                                                (Case When LedBal <= 0 Then VarMargin + Collateral_Total   
                                                Else   
                                                      (Case When LedBal > 0 Then   
                                                            (Case When VarMargin + Collateral_Total + LedBal >= 0 Then 0   
                                                            Else   
                                                                  VarMargin + Collateral_Total + LedBal    
                                                            End)   
                                                      Else 0     
                                                      End)  
                                            End)  
            Where   
                  VarMargin + Collateral_Total < 0  
        
        
      /*----------------------------------------------------------------------------------------------------------------------  
      Voucher Date wise Settlement Funding Amount:   
      Update Settlement Funding Amount for cases where both Ledger Balance and Bill Amount is Debit.  
      Funding Amount is the Minimum of the Debit in Ledger OR Bill  
      ----------------------------------------------------------------------------------------------------------------------*/  
            Update   
                  V2_ClientFundingData_Up         
            Set   
                  BillFunding = (Case When BillAmount > LedBal Then BillAmount Else LedBal End)  
            Where   
                  LedBal < 0  
                  And BillAmount < 0  
        
        
      /*----------------------------------------------------------------------------------------------------------------------  
      Update Total Funding Amount as Margin Funding Amount + Settlement Funding Amount  
      ----------------------------------------------------------------------------------------------------------------------*/  
            Update   
                  V2_ClientFundingData_Up         
            Set   
                  TotalFunding = MarginFunding + BillFunding  
        
       
      /*----------------------------------------------------------------------------------------------------------------------  
      Delete Data From Main Table for the date and populate fresh data as computed above.  
      Select output provided for Data Computed in above process.  
      ----------------------------------------------------------------------------------------------------------------------*/  
            Delete V2_ClientFundingData Where left(convert(varchar,rundate,109),11) = @rundate  
        
            Insert Into V2_ClientFundingData Select * From V2_ClientFundingData_Up (nolock)  
        
            Insert Into #DateCount Select @rundate  
        
            Fetch Next From @LedrCur   
            into   
            @rundate  
      End                      
      Close @LedrCur                      
      DeAllocate @LedrCur                       
        
      Select   
            rundate,   
            rundate_109 = left(convert(varchar,rundate,109),11)   
      From   
            #DateCount  
      Order By   
            rundate  
  
/*----------------------------------------------------------------------------------------------------------------------  
End Of Process  
----------------------------------------------------------------------------------------------------------------------*/

GO
