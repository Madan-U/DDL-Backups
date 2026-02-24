-- Object: PROCEDURE dbo.V2_ClientFundingReport
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




Create Proc V2_ClientFundingReport
(
      @startdate varchar(11),
      @enddate varchar(11),
      @fparty varchar(10),
      @tparty varchar(10), 
      @AmountFilter money 
)


/*----------------------------------------------------------------------------------------------------------------------
Exec V2_ClientFundingReport
      @startdate = 'Aug 17 2005', 
      @enddate = 'Aug 17 2005',
      @fparty = '0000000000',
      @tparty = 'ZZZZZZZZZZ', 
      @AmountFilter = 1
----------------------------------------------------------------------------------------------------------------------*/

As

/*----------------------------------------------------------------------------------------------------------------------
Client Funding Report: Final Version Sep 16 2005
----------------------------------------------------------------------------------------------------------------------*/
      Set NoCount On
      
      Set @AmountFilter = Abs(@AmountFilter) 

      If @AmountFilter = 0
      Begin 
            Set @AmountFilter = 0.01
      End

      if @startdate = '' OR len(ltrim(rtrim(@startdate))) <> 11
      begin
            Print 'Please enter correct start date'
            return
      end
      
      if @enddate = '' OR len(ltrim(rtrim(@enddate))) <> 11
      begin
            Print 'Please enter correct end date'
            return
      end


      Select 
            TradeDate = left(convert(varchar,rundate,109),11), 
            V.* 
      From 
            V2_ClientFundingData V
      Where 
            RunDate Between @startdate and @enddate + ' 23:59'
            And Party_Code Between @fparty and @tparty
            And TotalFunding < -@AmountFilter
      Order By 
            Party_Code, RunDate

GO
