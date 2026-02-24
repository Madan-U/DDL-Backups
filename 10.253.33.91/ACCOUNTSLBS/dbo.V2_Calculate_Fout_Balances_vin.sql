-- Object: PROCEDURE dbo.V2_Calculate_Fout_Balances_vin
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

create Proc V2_Calculate_Fout_Balances_vin  

                

as                

                

Declare @FromDate varchar(11)                

Declare @ProcessParams varchar(100)                

                

                

select @FromDate = Left(Convert(Varchar,getdate(),109),11)                  

                

                

Truncate Table V2_Fout_LedgerBalances_Temp                

                

set Transaction Isolation Level Read Uncommitted                

Insert into V2_Fout_LedgerBalances_Temp                

select       

 Party_Code = c1.Cl_Code,                

 Party_Name = c1.Long_Name,                

 Family_Code = c1.Family,                

 Family_Name = c1.Family,                

 Branch_Code = c1.Branch_Cd,                

 Branch_Name = isnull(br.Branch,'Unspecified'),                

 Trader = c1.Trader,                

 Trader_Name = isnull(tr.Short_Name,'UnSpecified'),                

 SubBroker_Code = c1.sub_Broker,                

 SubBroker_Name = isnull(sr.Name,'Unspecified'),                

 AreaCode = isnull(c1.Area,''),                

 AreaName = isnull(ar.Description,'Unspecified'),                

 Region_Code = isnull(c1.Region,''),                

 Region_Name = isnull(c1.Region,''),                

         Res_Phone = isnull(c1.Res_Phone1,''),                

 NSEBALANCE = 0,                

 BSEBALANCE = 0,                

 NSEFOBALANCE = 0,                

 NSEESTIMATED1 = 0,                

 NSEESTIMATED2 = 0,                

 BSEESTIMATED1 = 0,                

 BSEESTIMATED2 = 0,                

 FAActual = 0,                

 NonCash = 0,                

 Cash = 0,                

 IMMargin = 0,                

 VarMargin = 0,                

 RepDate = GetDate()                

From                

 Msajag.dbo.Client_Details c1 With(NoLock)                

  Left Outer Join Msajag.dbo.Branch br With(NoLock)               

   on (c1.BRANCH_CD = br.BRANCH_CODE)                

  left Outer Join Msajag.dbo.SubBrokers Sr With(NoLock)               

   on (c1.SUB_BROKER = sr.SUB_BROKER And c1.BRANCH_CD = sr.Branch_Code)                

  left Outer Join Msajag.dbo.Branches tr With(NoLock)               

   on (c1.TRADER = tr.SHORT_NAME and c1.BRANCH_CD = tr.Branch_Cd)                

  left Outer Join (Select distinct areacode, description,Branch_Code from Msajag.dbo.Area With(NoLock))  ar               

   on (c1.AREA = ar.AREACODE and ar.Branch_Code = c1.BRANCH_CD)      /*branch condition included sinu 14 may07*/          

                

---------------------------------------------------------------------------------------                

-- party code update is complete                

---------------------------------------------------------------------------------------                

                

                

                

set transaction isolation level read uncommitted                          

      update                     

            V2_Fout_LedgerBalances_Temp                         

      set                     

            NSEBALANCE = BALANCE_1 +  BALANCE_2,                    

            FAACTUAL = FAACTUAL + ACTUAL_1 + ACTUAL_2                    
      From                     

            (                        

            SELECT                     

                  L.CltCode,                         

                  BALANCE_1 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                     

                                                EDT <= @FromDate + ' 23:59:59'                     

                                                AND Vtyp <> 2                     

                                          THEN (CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0)),                     

                  BALANCE_2 =      

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                         (CASE WHEN                     

                                                Vtyp = 2                     

     THEN (CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0)),                     

                  ACTUAL_1 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

       (CASE WHEN                     

                                                Vtyp <> 2                     

                                          THEN (CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0)),                     

                  ACTUAL_2 =                     

  CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                    

                EDT <= @FromDate + ' 23:59:59'                          

                                                And Vtyp = 2                     

                                          THEN (CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0))                                      

            FROM                     

                  ACCOUNT.DBO.LEDGER L With(NoLock),                     

                  ACCOUNT.DBO.PARAMETER P With(NoLock),                

                  V2_Fout_LedgerBalances_Temp FL With(NoLock)                    

            WHERE                     

                  EDT Between SdtCur And @FromDate + ' 23:59'                    

                  And @FromDate BetWeen SdtCur And LdtCur                         

                  And L.CltCode = fl.Party_Code                

            Group By                     

                  L.CltCode                        

            ) A                                      

      where                     

            V2_Fout_LedgerBalances_Temp.Party_Code=A.cltcode                         

--union all

--set transaction isolation level read uncommitted                          

      update                     

            V2_Fout_LedgerBalances_Temp                         

      set                     

            NSEBALANCE = NSEBALANCE + BALANCE_1 +  BALANCE_2,                    

            FAACTUAL = FAACTUAL + ACTUAL_1 + ACTUAL_2                    

      From                     

            (                        

            SELECT                     

                  L.CltCode,                         

                  BALANCE_1 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                     

                                                EDT <= @FromDate + ' 23:59:59'                     

                                                AND Vtyp <> 2                     

                                          THEN (CASE WHEN L.DRCR = 'C' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0)),                     

                  BALANCE_2 =      

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                         (CASE WHEN                     

                                                Vtyp = 2                     

     THEN (CASE WHEN L.DRCR = 'C' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0)),                     

                  ACTUAL_1 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

       (CASE WHEN                     

                                                Vtyp <> 2                     

                                          THEN (CASE WHEN L.DRCR = 'C' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0)),                     

                  ACTUAL_2 =                     

  CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                    

                EDT <= @FromDate + ' 23:59:59'                          

                                                And Vtyp = 2                     

                                          THEN (CASE WHEN L.DRCR = 'C' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0))                                      

            FROM                     

                  ACCOUNT.DBO.LEDGER L With(NoLock),                     

                  ACCOUNT.DBO.PARAMETER P With(NoLock),                

                  V2_Fout_LedgerBalances_Temp FL With(NoLock)                    

            WHERE                     

                  EDT >= SdtCur And VDT < SdtCur

                  And L.CltCode = fl.Party_Code                

            Group By                     

                  L.CltCode                        

            ) A                                      

      where                     

            V2_Fout_LedgerBalances_Temp.Party_Code=A.cltcode                         

                    

/*--------------------------------------------------------------------------------------------------------------                    

BSE Cash                     

Update EDT ledger balances - Receipt Bank Entries ignored                    

Update Total Receipt Bank Entries Amount as on VDT                     

Update the Actual Consolidated Ledger Balance (FAACTUAL)                    

      Receipt Bank Entries considered on Effective Date Basis                    

--------------------------------------------------------------------------------------------------------------*/                    

set transaction isolation level read uncommitted                          

      update                     

            V2_Fout_LedgerBalances_Temp                         

      set                     

            BSEBALANCE = BALANCE_1 +  BALANCE_2,                    

            FAACTUAL = FAACTUAL + ACTUAL_1 + ACTUAL_2                    

      From                     

            (                        

            SELECT                     

                  L.CltCode,                         

                  BALANCE_1 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                     

                                                EDT <= @FromDate + ' 23:59:59'                     

                                                AND Vtyp <> 2                     

                                   THEN (CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END)                    

                    ELSE 0 END)                    

                              ,0)),                     

                  BALANCE_2 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

(SUM                    

                                    (CASE WHEN                     

                                                Vtyp = 2                     

                                          THEN (CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END)                    

       ELSE 0 END)                    

                              ,0)),                     

                  ACTUAL_1 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                     

                                            Vtyp <> 2                     

                                          THEN (CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0)),                     

                  ACTUAL_2 =             

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                    

                                                EDT <= @FromDate + ' 23:59:59'                          

    And Vtyp = 2                     

                                          THEN (CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0))                                      

            FROM                     

                  ACCOUNTBSE.DBO.LEDGER L  With(NoLock),                   

                  ACCOUNTBSE.DBO.PARAMETER P  With(NoLock),                

                  V2_Fout_LedgerBalances_Temp FL  With(NoLock)               

            WHERE                     

                  EDT Between SdtCur And @FromDate + ' 23:59'                    

                  And @FromDate BetWeen SdtCur And LdtCur                         

                  And L.CltCode = fl.Party_Code                

            Group By                     

                  l.CltCode                        

            ) A                                      

      where                     

            V2_Fout_LedgerBalances_Temp.Party_Code=A.cltcode                         

 

--Union All

 

set transaction isolation level read uncommitted                          

      update                     

            V2_Fout_LedgerBalances_Temp                         

      set                     

            BSEBALANCE = BSEBALANCE + BALANCE_1 +  BALANCE_2,                    

            FAACTUAL = FAACTUAL + ACTUAL_1 + ACTUAL_2                    

      From                     

            (                        

            SELECT                     

                  L.CltCode,                         

                  BALANCE_1 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                     

                                                EDT <= @FromDate + ' 23:59:59'                     

                                                AND Vtyp <> 2                     

                                   THEN (CASE WHEN L.DRCR = 'C' THEN VAMT ELSE -VAMT END)                    

                    ELSE 0 END)                    

                              ,0)),                     

                  BALANCE_2 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

(SUM                    

                                    (CASE WHEN                     

                                                Vtyp = 2                     

                                          THEN (CASE WHEN L.DRCR = 'C' THEN VAMT ELSE -VAMT END)                    

       ELSE 0 END)                    

                              ,0)),                     

                  ACTUAL_1 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                     

                                            Vtyp <> 2                     

                                          THEN (CASE WHEN L.DRCR = 'C' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0)),                     

                  ACTUAL_2 =             

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                    

                                                EDT <= @FromDate + ' 23:59:59'                          

    And Vtyp = 2                     

                                          THEN (CASE WHEN L.DRCR = 'C' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0))                                      

            FROM                     

                  ACCOUNTBSE.DBO.LEDGER L  With(NoLock),                   

                  ACCOUNTBSE.DBO.PARAMETER P  With(NoLock),                

                  V2_Fout_LedgerBalances_Temp FL  With(NoLock)               

            WHERE                     

                          EDT >= SdtCur And VDT < SdtCur

--                And @FromDate BetWeen SdtCur And LdtCur                         

                  And L.CltCode = fl.Party_Code                

            Group By                     

                  l.CltCode                        

            ) A                                      

      where                     

            V2_Fout_LedgerBalances_Temp.Party_Code=A.cltcode     

 

                

                    

                    

/*--------------------------------------------------------------------------------------------------------------                    

NSE Derivatives                     

Update EDT ledger balances - Receipt Bank Entries ignored                    

Update Total Receipt Bank Entries Amount as on VDT                     

Update The Actual Consolidated Ledger Balance (FAACTUAL)                    

      Receipt Bank Entries considered on Effective Date Basis                    

--------------------------------------------------------------------------------------------------------------*/                    

set transaction isolation level read uncommitted                          

      update                     

            V2_Fout_LedgerBalances_Temp                         

      set                     

            NSEFOBALANCE = BALANCE_1 +  BALANCE_2,                    

            FAACTUAL = FAACTUAL + ACTUAL_1 + ACTUAL_2                    

      From                     

            (                        

            SELECT                     

                  L.CltCode,                         

                  BALANCE_1 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                   (SUM                    

                                    (CASE WHEN                     

                                                EDT <= @FromDate + ' 23:59:59'                     

                                                AND Vtyp <> 2                     

                                          THEN (CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                 

                              ,0)),                     

                  BALANCE_2 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                     

                                                Vtyp = 2                     

            THEN (CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0)),                     

                  ACTUAL_1 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                     

                               Vtyp <> 2                     

                                          THEN (CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0)),                     

                  ACTUAL_2 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

           (CASE WHEN                    

                                                EDT <= @FromDate + ' 23:59:59'                          

                                                And Vtyp = 2                     

                                          THEN (CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0))                                      

            FROM                     

                  ACCOUNTFO.DBO.LEDGER L With(NoLock),                     

                  ACCOUNTFO.DBO.PARAMETER P With(NoLock),                

                  V2_Fout_LedgerBalances_Temp FL With(NoLock)               

            WHERE                     

                  EDT Between SdtCur And @FromDate + ' 23:59'                    

                  And @FromDate BetWeen SdtCur And LdtCur                         

                  And L.CltCode = fl.Party_Code                

            Group By                     

                  l.CltCode                        

            ) A                                      

      where                     

            V2_Fout_LedgerBalances_Temp.Party_Code=A.cltcode           

 

--Union All 

 

set transaction isolation level read uncommitted                          

      update                     

            V2_Fout_LedgerBalances_Temp                         

      set                     

            NSEFOBALANCE = BSEBALANCE+BALANCE_1 +  BALANCE_2,                    

            FAACTUAL = FAACTUAL + ACTUAL_1 + ACTUAL_2                    

      From                     

            (                        

            SELECT                     

                  L.CltCode,                         

                  BALANCE_1 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                   (SUM                    

                                    (CASE WHEN                     

                                                EDT <= @FromDate + ' 23:59:59'                     

                                                AND Vtyp <> 2                     

                                          THEN (CASE WHEN L.DRCR = 'C' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                 

                              ,0)),                     

                  BALANCE_2 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                     

                                                Vtyp = 2                     

            THEN (CASE WHEN L.DRCR = 'C' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0)),                     

                  ACTUAL_1 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

                                    (CASE WHEN                     

                               Vtyp <> 2                     

                                          THEN (CASE WHEN L.DRCR = 'C' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0)),                     

                  ACTUAL_2 =                     

                        CONVERT(NUMERIC(18,4),ISNULL                    

                              (SUM                    

           (CASE WHEN                    

                                                EDT <= @FromDate + ' 23:59:59'                          

                                                And Vtyp = 2                     

                                          THEN (CASE WHEN L.DRCR = 'C' THEN VAMT ELSE -VAMT END)                    

                                          ELSE 0 END)                    

                              ,0))                                      

            FROM                     

                  ACCOUNTFO.DBO.LEDGER L With(NoLock),                     

                  ACCOUNTFO.DBO.PARAMETER P With(NoLock),                

                  V2_Fout_LedgerBalances_Temp FL With(NoLock)               

            WHERE                     

                  EDT >= SdtCur And VDT < SdtCur

--                And @FromDate BetWeen SdtCur And LdtCur                         

                  And L.CltCode = fl.Party_Code                

            Group By                     

                  l.CltCode                        

            ) A                                      

      where                     

            V2_Fout_LedgerBalances_Temp.Party_Code=A.cltcode     

 

 

 

                

              

      CREATE TABLE [#led]               

      (              

       [Vdt] [datetime] NULL ,              

       [CltCode] [varchar] (10) NOT NULL ,              

       [DrCr] [char] (1) NULL ,              

       [VAmt] [money] NULL ,              

       [Narration] [varchar] (234) NULL               

      ) ON [PRIMARY]              

              

      CREATE               

        NONCLUSTERED INDEX [vdt] ON [#led] ([Vdt])              

      ON [PRIMARY]              

                    

/*--------------------------------------------------------------------------------------------------------------                    

Retrieving NSE VDT Wise Bill Amounts for Future Dated Bills i.e. (Effective Date > RunDate)                    

--------------------------------------------------------------------------------------------------------------*/                    

              

      set transaction isolation level read uncommitted                            

              

      Insert into #led               

      Select               

            Vdt, CltCode, DrCr, VAmt, Narration               

      From               

            ACCOUNT.DBO.LEDGER L With(NoLock)               

      Where               

            Vdt <= @FromDate + ' 23:59:59'                                      

            AND Edt >= @FromDate + ' 23:59:59'                         

            And Vtyp in (15,21)                     

              

      Select                     

            Exc='NSE',                     

        Vdt,                     

            L.CltCode,                        

            Amount=CONVERT(NUMERIC(18,4),isnull(Sum(Case When DrCr = 'D' Then Vamt Else -Vamt End),0) )                                      

      Into                     

            #LedgerEstimate                         

      From                     

             #led L With(NoLock),                     

             MSAJAG.DBO.Sett_Mst S With(NoLock),                

             V2_Fout_LedgerBalances_Temp FL With(NoLock)                

      Where           

            L.narration Like '%' + RTrim(Sett_No) + 'NSECM' + RTrim(Sett_Type) + '%'                                       

            And Vdt >= S.Start_Date                         

            And Vdt <= S.Sec_PayIn                         

            and L.CltCode = fl.Party_Code                

      Group By                     

            VDT,                     

            L.CltCode                                      

                  

                    

/*--------------------------------------------------------------------------------------------------------------                    

Retrieving BSE VDT Wise Bill Amounts for Future Dated Bills i.e. (Effective Date > RunDate)                    

--------------------------------------------------------------------------------------------------------------*/                    

      set transaction isolation level read uncommitted                            

              

      Truncate Table #led              

              

      Insert into #led               

      Select               

            Vdt, CltCode, DrCr, VAmt, Narration               

      From               

            ACCOUNTBSE.DBO.LEDGER L With(NoLock)               

      Where               

            Vdt <= @FromDate + ' 23:59:59'             

            AND Edt >= @FromDate + ' 23:59:59'                         

            And Vtyp in (15,21)                     

              

      Insert Into                     

            #LedgerEstimate                                       

      Select                     

            Exc='BSE',                     

            Vdt,                     

            L.CltCode,                        

            Amount=CONVERT(NUMERIC(18,4),isnull(Sum(Case When DrCr = 'D' Then Vamt Else -Vamt End),0) )                                      

      From                     

            #led L With(NoLock),                     

            BSEDB.DBO.Sett_Mst S With(NoLock),                

     V2_Fout_LedgerBalances_Temp FL With(NoLock)                    

      Where                     

            L.narration Like '%' + RTrim(Sett_No) + 'BSECM' + RTrim(Sett_Type) + '%'                                       

            And Vdt >= S.Start_Date                         

            And Vdt <= S.Sec_PayIn                         

            and L.cltcode = fl.Party_Code                

      Group By                     

            VDT,                     

            L.CltCode                                       

                  

                  

/*--------------------------------------------------------------------------------------------------------------                    

Updating NSE Future Dated Bill Amounts as retrieved in the above query                    

for the most recent Bill as Estimated Amount 1                    

--------------------------------------------------------------------------------------------------------------*/                    

                

     set transaction isolation level read uncommitted                          

      update                     

            V2_Fout_LedgerBalances_Temp                     

      set                     

            NSEESTIMATED1 = Amount                         

      From                     

            (                    

                  Select                     

                        CltCode,                     

                        Amount=IsNull(Sum(Amount),0)                         

                  From                     

                        #LedgerEstimate L (nolock)                    

      Where                     

                        Vdt Like                     

                        (                    

                              Select                     

                                    Left(Convert(Varchar,Min(Vdt),109),11) + '%'                         

                              From                     

                                    #LedgerEstimate (nolock)                    

                              Where                     

                                    L.Exc = Exc                     

                                    And Exc = 'NSE'                     

                        )                         

                  Group By                     

                        CltCode                     

            ) A                                      

      Where                     

            V2_Fout_LedgerBalances_Temp.Party_Code=A.Cltcode                         

                    

                    

/*--------------------------------------------------------------------------------------------------------------                    

Updating NSE Future Dated Bill Amounts as retrieved in the above query                    

for all bills other than the most recent Bill as Estimated Amount 2                    

--------------------------------------------------------------------------------------------------------------*/                    

set transaction isolation level read uncommitted                       

      update                     

            V2_Fout_LedgerBalances_Temp                         

      set                     

            NSEESTIMATED2 = Amount                         

      From                     

            (                    

                  Select                     

                        CltCode,                     

                        Amount=IsNull(Sum(Amount),0)                     

                  From                     

                        #LedgerEstimate L  (nolock)                    

                  Where                     

                        Vdt Not Like                     

                

                        (                    

                              Select                     

                                    Left(Convert(Varchar,Min(Vdt),109),11) + '%'                         

                              From                     

                                    #LedgerEstimate (nolock)                    

                              Where                     

                                    L.Exc = Exc                     

                                    And Exc = 'NSE'                     

                        )                         

                  Group By                     

                        CltCode                     

            ) A                             

      Where                     

            V2_Fout_LedgerBalances_Temp.Party_Code=A.Cltcode                         

                

                    

                    

/*--------------------------------------------------------------------------------------------------------------                    

Updating BSE Future Dated Bill Amounts as retrieved in the above query            

for the most recent Bill as Estimated Amount 1                    

--------------------------------------------------------------------------------------------------------------*/                    

      set transaction isolation level read uncommitted                          

      update                     

            V2_Fout_LedgerBalances_Temp                         

      set                     

            BSEESTIMATED1 = Amount                         

      From                     

            (                    

                  Select                     

                        CltCode,                     

                        Amount=IsNull(Sum(Amount),0)                     

                  From                     

                        #LedgerEstimate L (nolock)                    

                  Where                     

          Vdt Like                     

                        (                    

                 Select                     

                                    Left(Convert(Varchar,Min(Vdt),109),11) + '%'                         

                              From                     

                                    #LedgerEstimate (nolock)                    

                              Where                     

                      L.Exc = Exc                     

                                    And Exc = 'BSE'                     

                        )                         

                  Group By                     

                        CltCode                     

            ) A                                      

      Where                     

            V2_Fout_LedgerBalances_Temp.Party_Code=A.Cltcode                        

                    

                    

/*--------------------------------------------------------------------------------------------------------------                    

Updating BSE Future Dated Bill Amounts as retrieved in the above query                    

for all bills other than the most recent Bill as Estimated Amount 2                    

--------------------------------------------------------------------------------------------------------------*/                    

                

      set transaction isolation level read uncommitted                          

      update                     

            V2_Fout_LedgerBalances_Temp                         

      set                     

            BSEESTIMATED2 = Amount                         

      From                     

            (                    

                  Select                     

                        CltCode,                     

        Amount=IsNull(Sum(Amount),0)                     

                  From                     

                        #LedgerEstimate L (nolock)                    

                  Where                     

                        Vdt Not Like                     

                        (                    

                              Select                     

                                    Left(Convert(Varchar,Min(Vdt),109),11) + '%'                         

                              From                     

                                    #LedgerEstimate (nolock)                    

                              Where                     

                                    L.Exc = Exc                     

                            And Exc = 'BSE'                    

                        )                         

                  Group By                     

                        CltCode                     

            ) A                                      

  Where                     

            V2_Fout_LedgerBalances_Temp.Party_Code=A.Cltcode                         

                    

                    

/*--------------------------------------------------------------------------------------------------------------                    

                    

--------------------------------------------------------------------------------------------------------------*/                    

      set transaction isolation level read uncommitted                          

-- select * from V2_Fout_LedgerBalances_Temp where party_code = 'MUM3P001' and repdate like 'may 18 2006%'          

          

          

 Update           

  V2_Fout_LedgerBalances_Temp          

 Set           

  NonCash = CC.NonCash,          

  Cash = CC.Cash          

 From           

  (          

   Select           

    Party_Code,          

    Cash = Sum(Cash),          

    NonCash = Sum(NonCash)          

   From           

    MSAJAG.DBO.Collateral C   WITH(INDEX(PARTYCODE),nolock)          

   Where          

    Trans_Date = (Select Max(Trans_Date) From MsaJag.Dbo.Collateral (NoLock))          

   Group By          

    Party_Code          

  ) CC          

 Where          

  V2_Fout_LedgerBalances_Temp.Party_Code=CC.Party_Code          

          

          

/*          

          

      Update                     

            V2_Fout_LedgerBalances_Temp                         

      Set                     

            NonCash = sum(C.NonCash),                     

            Cash = sum(C.Cash)                                      

      From                     

            MSAJAG.DBO.Collateral C   WITH(INDEX(PARTYCODE),nolock)                     

      Where                     

            Trans_Date =                     

                  (                    

                        SELECT                     

     MAX(TRANS_DATE)                     

                        FROM                     

                              MSAJAG.DBO.COLLATERAL (nolock)                    

                  )                      

            And V2_Fout_LedgerBalances_Temp.Party_Code=C.Party_Code            

group by ca              

                    

          

select max(trans_date),sum(cash) from msajag.dbo.collateral where trans_date like 'may 18 2006%' and party_code like 'MUM3P001'                    

group by cash*/          

/*--------------------------------------------------------------------------------------------------------------                    

                    

--------------------------------------------------------------------------------------------------------------*/                    

      set transaction isolation level read uncommitted                          

      Update                     

            V2_Fout_LedgerBalances_Temp                         

      Set                     

            IMMargin = IsNull(Margin,0)                         

      From                     

            (                    

                  Select                     

                        Party_Code,                     

                        Margin = Sum(PspanMargin)                                        

                  From                     

                        NSEFO.DBO.FoMarginNew F  WITH(INDEX(CLTYPEPARTYDATE),nolock)                        

                  Where                     

                        Mdate =                     

                              (                    

                                    Select                     

                  Max(MDate)                         

                                    From                     

                                          NSEFO.DBO.FoMarginNew (nolock)                    

                                    Where                     

                                          MDate <= @FromDate +' 23:59:59'                     

                              )                                 

                  Group By                     

                  Party_Code                     

            ) A                                      

      Where                     

            V2_Fout_LedgerBalances_Temp.Party_Code=A.Party_Code                         

                    

                    

/*--------------------------------------------------------------------------------------------------------------                    

                    

--------------------------------------------------------------------------------------------------------------*/                    

      set transaction isolation level read uncommitted                          

      Update                     

            V2_Fout_LedgerBalances_Temp                         

Set                     

            VarMargin = IsNull(VMargin,0)                         

      From                     

            (                    

                  Select                     

                        Party_Code,                     

                        VMargin = Sum(MtoM)                                        

                  From                     

                        NSEFO.DBO.FoMarginNew F  WITH(INDEX(CLTYPEPARTYDATE),nolock)                        

                  Where                     

                        Mdate =                     

                              (                    

                                    Select                     

                                          Max(MDate)                         

                 From                     

                                          NSEFO.DBO.FoMarginNew (Nolock)                    

                                    Where                     

                                          MDate <= @FromDate +' 23:59:59'                     

                              )                                 

              Group By                     

                        Party_Code                    

            ) A                                      

      Where                     

            V2_Fout_LedgerBalances_Temp.Party_Code=A.Party_Code                         

                    

                    

/*--------------------------------------------------------------------------------------------------------------                    

                    

--------------------------------------------------------------------------------------------------------------*/                    

set transaction isolation level read uncommitted                          

      Update                     

            V2_Fout_LedgerBalances_Temp                         

      Set                     

            NonCash = ((Case When ((IMMargin + VarMargin)*0.75)  < NonCash Then  ((IMMargin + VarMargin)*0.75) Else nonCash End)) * -1,                

     Cash = Cash * -1                

                    

                    

                    

--------------------------------------------------------------------------------------------------------------*/                    

                

                

      Delete From                     

            V2_Fout_LedgerBalances_Temp                                       

      Where                     

            NSEBALANCE   = 0                                       

            And BSEBALANCE      = 0                                       

            And NSEFOBALANCE  = 0                                       

            And NSEESTIMATED1 = 0                                       

            And NSEESTIMATED2 = 0                                       

            And BSEESTIMATED1 = 0                                       

            And BSEESTIMATED2 = 0                                       

            And FAActual           = 0                                       

            And NonCash           = 0                                       

            And Cash                = 0                                       

      And IMMargin           = 0                                       

            And VarMargin         = 0                                      

                

                

                    

/*--------------------------------------------------------------------------------------------------------------                    

                    

--------------------------------------------------------------------------------------------------------------*/                    

                

/*         

      if @reportopt='D'                      

      begin                

            set transaction isolation level read uncommitted                  

            select                     

                  FamilyCode,                    

                  CLTCODE,                    

                  ACNAME,                    

                  NSEBALANCE,                    

                  BSEBALANCE,                    

                  NSEFOBALANCE,                    

                  NSEESTIMATED1,                    

                  NSEESTIMATED2,                                   

                  BSEESTIMATED1,                    

                  BSEESTIMATED2,                    

                  FAActual,                    

                  Res_Phone1,                    

                  Cash,                    

                  NonCash,                    

      IMMargin,                    

                  VarMargin,                     

                  @@SPID as SesID                                   

            from                     

                  V2_Fout_LedgerBalances_Temp L (nolock),                    

                  MSAJAG.DBO.ClientMaster C  with(index(partycdidx),nolock)                                  

            Where                     

                  C.Party_Code = L.CltCode                     

                  and procid=@@spid                                  

            Order By                     

                  FamilyCode,                    

                  CLTCODE,                    

                  C.Long_Name,                    

                  Res_Phone1                                   

      end                                

      else                                

      begin                                

            set transaction isolation level read uncommitted                  

            select                     

                  L.REP_GROUP as FamilyCode,                     

                  L.REP_GROUP_NAME as AcName,                    

                  sum(NSEBALANCE) as TotNSEBALANCE,                        

                  sum(BSEBALANCE) as TotBSEBALANCE,                    

                  sum(NSEFOBALANCE) as TotNSEFOBALANCE,                                

                  sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE ) as TotTotalParty,                                

                  sum(NSEESTIMATED1) as TotNSEESTIMATED1,                    

                  sum(NSEESTIMATED2) as TotNSEESTIMATED2,                                   

                  sum(BSEESTIMATED1) as TotBSEESTIMATED1,                    

  sum(BSEESTIMATED2) as TotBSEESTIMATED2,                                

                  sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2) as TotEstimateTotalParty,                                

                  sum(FAActual) as TotFAACTUAL,                                

                  sum(FAActual - (NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2)) as TotFANETPARTY,                                

                  sum(Cash) as TotCASH,                    

                  sum(NonCash) as TotNonCash,                     

                  sum(IMMargin) as TotIMMargin,                    

                  sum(VarMargin) as TotVarMargin,                                

                  sum(FAActual + IMMargin + VarMargin + NONCASH + CASH) as TotFinTotalParty,                     

                  @@SPID as SesID                                     

            from                     

                  V2_Fout_LedgerBalances_Temp L (nolock)                    

            Where                     

                  L.Procid=@@spid                                  

            group By                     

       L.Rep_Group,                     

                  L.Rep_Group_Name                    

    Order By                     

                  L.Rep_Group                     

      end                                   

                                  

*/                

                

                

Select   @ProcessParams = ProcessParams from V2_Process_Master where ProcessName = 'FOUT REPORT'                

                

                

                

Update V2_Process_Master                

Set ProcessFlag = 'N',                

ProcessParams = 'Fout Report is being Calculated for ' + @FromDate + ' at ' + left(convert(varchar,getdate(),109),20),                

ProcessBy = 'SYSTEM',                

ProcessDate = GetDate()                

Where ProcessName = 'FOUT REPORT'                

                

                

begin Tran                

                

      Truncate Table V2_Fout_LedgerBalances                

                

                      

      Insert Into                 

            V2_Fout_LedgerBalances                

      select                 

            *                 

      From                 

            V2_Fout_LedgerBalances_Temp                

                

                

IF @@ERROR = 0                

begin                

      Commit Tran                

      Select @ProcessParams = 'Fout Report Calculated for ' + @FromDate + ' at ' + left(convert(varchar,getdate(),109),20)            

End                

Else                

Begin                

      RollBack Tran                

End                

                

                

                

      Drop Table #LedgerEstimate                    

                

                

      Update V2_Process_Master                

      Set ProcessFlag = 'Y',                

      ProcessParams = @ProcessParams,                

      ProcessBy = 'SYSTEM',                

      ProcessDate = GetDate()                

      Where ProcessName = 'FOUT REPORT'                

                

                

                    

/*--------------------------------------------------------------------------------------------------------------                    

END Process                    

--------------------------------------------------------------------------------------------------------------*/

GO
