-- Object: PROCEDURE dbo.usp_get_Financial_Ledger_OneTime_v1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure usp_get_Financial_Ledger_OneTime_v1  
  (  
   @SB_Code varchar(100),  
   @FromDate date,  
   @Todate date  
  )  
  as  
  begin   
  
  
  Print  @FromDate   
  Print  @Todate   
  --EXEC usp_get_Financial_Ledger_OneTime '48AAAI','2017-04-01','2018-03-31'  
  
  select   
    case when FY='17-18' then '2017-2018'  
  when FY='14-15' then '2014-2015'  
  when FY='15-16' then '2015-2016'  
  when FY='16-17' then '2016-2017'  
 ELSE FY  
  END FY  
  
   ,Date   
   ,[Voucher Type]   
   ,[Vr No]    
   ,[Cheque No]   
   ,[Particulars]   
   ,[Debit Amt#]   
   ,[Credit Amt]   
   ,[Balance]   
   ,[SB Code]  
  From   dbo.[Financial_Ledger_OneTime_NXT] with(nolock)  
where [SB Code]=@SB_Code   
and (Fromdate>=@FromDate and Todate<=@ToDate)  
  
  end

GO
