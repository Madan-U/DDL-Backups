-- Object: PROCEDURE dbo.ContCumBill_Section_NSECM_dkm
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc ContCumBill_Section_NSECM_dkm 
(  
      @StatusId Varchar(15),   
      @StatusName Varchar(25),   
      @Sauda_Date Varchar(11),   
      @Sett_No Varchar(7),   
      @Sett_Type Varchar(2),   
      @FromParty_code Varchar(10) ,  
      @ToParty_code Varchar(10),   
      @Branch Varchar(10),   
      @Sub_broker Varchar(10)  
)        
  
As        
  
set nocount on  
  
set transaction isolation level read uncommitted      
  
CREATE TABLE [#ContSett] 
(  
      [ContractNo] [varchar] (7)  NULL ,  
      [Party_code] [varchar] (10)  NOT NULL ,  
      [Order_No] [varchar] (16)  NULL ,  
      [TM] [varchar] (30)  NULL ,  
      [Trade_no] [varchar] (17)  NOT NULL ,  
      [Sauda_Date] [datetime] NULL ,  
      [Scrip_Cd] [varchar] (10)  NOT NULL ,  
      [Series] [char] (2)  NOT NULL ,  
      [ScripName] [varchar] (53)  NULL ,  
      [SDT] [varchar] (30)  NULL ,  
      [Sell_Buy] [int] NOT NULL ,  
      [MarketType] [varchar] (2)  NOT NULL ,  
      [Broker_Chrg] [money] NOT NULL ,  
      [turn_tax] [money] NOT NULL ,  
      [sebi_tax] [money] NOT NULL ,  
      [other_chrg] [money] NOT NULL ,  
      [Ins_Chrg] [money] NOT NULL ,  
      [Service_Tax] [money] NOT NULL ,  
      [NSerTax] [money] NOT NULL ,  
      [Sauda_Date1] [varchar] (11)  NULL ,  
      [PQty] [int] NOT NULL ,  
      [SQty] [int] NOT NULL ,  
      [PRate] [money] NOT NULL ,  
      [SRate] [money] NOT NULL ,  
      [PBrok] [money] NULL ,  
      [SBrok] [money] NULL ,  
      [PNetRate] [numeric](20, 4) NULL ,  
      [SNetRate] [numeric](20, 4) NULL ,  
      [PAmt] [numeric](31, 4) NULL ,  
      [SAmt] [numeric](31, 4) NULL ,  
      [Brokerage] [money] NULL ,  
      [Sett_No] [varchar] (7)  NOT NULL ,  
      [Sett_Type] [varchar] (3)  NOT NULL ,  
      [TradeType] [varchar] (2)  NOT NULL ,  
      [Tmark] [varchar] (1)  NOT NULL ,  
      [service_chrg] [tinyint] NOT NULL ,  
      [Branch_cd] [varchar] (10)  NULL ,  
      [sub_broker] [varchar] (10)  NOT NULL ,  
      [Printf] [tinyint] NOT NULL ,  
      [OrderFlag] [int] NOT NULL ,  
      [ScripName1] [varchar] (50)  NULL ,  
      [billflag] [int] NOT NULL   
) ON [PRIMARY]  
        
CREATE TABLE [#ContSettNew] 
(  
      [SrNo] [int] IDENTITY (1, 1) NOT NULL ,  
      [ContractNo] [varchar] (7)  NULL ,  
      [Party_code] [varchar] (10)  NOT NULL ,  
      [Order_No] [varchar] (16)  NULL ,  
      [TM] [varchar] (30)  NULL ,  
      [Trade_no] [varchar] (17)  NOT NULL ,  
      [Sauda_Date] [datetime] NULL ,  
      [Scrip_Cd] [varchar] (10)  NOT NULL ,  
      [Series] [char] (2)  NOT NULL ,  
      [ScripName] [varchar] (53)  NULL ,  
      [SDT] [varchar] (30)  NULL ,  
      [Sell_Buy] [int] NOT NULL ,  
      [MarketType] [varchar] (2)  NOT NULL ,  
      [Broker_Chrg] [money] NOT NULL ,  
      [turn_tax] [money] NOT NULL ,  
      [sebi_tax] [money] NOT NULL ,  
      [other_chrg] [money] NOT NULL ,  
      [Ins_Chrg] [money] NOT NULL ,  
      [Service_Tax] [money] NOT NULL ,  
      [NSerTax] [money] NOT NULL ,  
      [Sauda_Date1] [varchar] (11)  NULL ,  
      [PQty] [int] NOT NULL ,  
      [SQty] [int] NOT NULL ,  
      [PRate] [money] NOT NULL ,  
      [SRate] [money] NOT NULL ,  
      [PBrok] [money] NULL ,  
      [SBrok] [money] NULL ,  
      [PNetRate] [numeric](20, 4) NULL ,  
      [SNetRate] [numeric](20, 4) NULL ,  
      [PAmt] [numeric](31, 4) NULL ,  
      [SAmt] [numeric](31, 4) NULL ,  
      [Brokerage] [money] NULL ,  
      [Sett_No] [varchar] (7)  NOT NULL ,  
      [Sett_Type] [varchar] (3)  NOT NULL ,  
      [TradeType] [varchar] (2)  NOT NULL ,  
      [Tmark] [varchar] (1)  NOT NULL ,  
      [Partyname] [varchar] (100)  NULL ,  
      [l_address1] [varchar] (40)  NOT NULL ,  
      [l_address2] [varchar] (40)  NULL ,  
      [l_address3] [varchar] (40)  NULL ,  
      [l_city] [varchar] (40)  NULL ,  
      [l_zip] [varchar] (10)  NULL ,  
      [service_chrg] [tinyint] NOT NULL ,  
      [Branch_cd] [varchar] (10)  NULL ,  
      [sub_broker] [varchar] (10)  NOT NULL ,  
      [pan_gir_no] [varchar] (50)  NULL ,  
      [Off_Phone1] [varchar] (15)  NULL ,  
      [Off_Phone2] [varchar] (15)  NULL ,  
      [Printf] [tinyint] NOT NULL ,  
      [mapidid] [varchar] (10)  NULL ,  
      [OrderFlag] [int] NOT NULL ,  
      [ScripName1] [varchar] (50)  NULL ,  
      [billflag] [int] NOT NULL   
) ON [PRIMARY]  
  
/*=========================================================================  
      /*FOR THE CLIENT MASTER*/   
=========================================================================*/  
      SELECT C1.CL_CODE,   
            C2.PARTY_CODE,   
            C1.LONG_NAME,   
            C1.L_ADDRESS1,   
            C1.L_ADDRESS2,   
            C1.L_ADDRESS3,   
            C1.L_CITY,   
            C1.L_ZIP,   
            C1.BRANCH_CD ,   
            C1.SUB_BROKER,   
            C1.PAN_GIR_NO,   
            C1.OFF_PHONE1,   
            C1.OFF_PHONE2,   
            PRINTF,   
            MAPIDID,   
            C2.SERVICE_CHRG,   
            BROKERNOTE,   
            TURNOVER_TAX,   
            SEBI_TURN_TAX,   
            C2.OTHER_CHRG,   
            INSURANCE_CHRG   
      INTO #CLIENTMASTER   
      FROM CLIENT1 C1 WITH(NOLOCK),   
            CLIENT2 C2 WITH(NOLOCK)   
            LEFT OUTER JOIN   
            UCC_CLIENT UC WITH(NOLOCK)   
            ON C2.PARTY_CODE = UC.PARTY_CODE   
      WHERE C2.CL_CODE = C1.CL_CODE   
            AND C2.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE   
             AND @STATUSNAME =   
                  (CASE   
                        WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD  
                        WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER  
                        WHEN @STATUSID = 'TRADER' THEN C1.TRADER  
                        WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY  
                        WHEN @STATUSID = 'AREA' THEN C1.AREA  
                        WHEN @STATUSID = 'REGION' THEN C1.REGION  
                        WHEN @STATUSID = 'CLIENT' THEN C2.PARTY_CODE  
                  ELSE   
                        'BROKER'  
                  END)  
            AND BRANCH_CD LIKE @BRANCH   
            AND SUB_BROKER LIKE @SUB_BROKER   
  
      Select   
            S.*,   
            C.BRANCH_CD ,   
            C.SUB_BROKER,   
            C.PRINTF,   
            C.SERVICE_CHRG,   
            C.BROKERNOTE,   
            C.TURNOVER_TAX,   
            C.SEBI_TURN_TAX,   
            OTHER_CHARGE = C.OTHER_CHRG,   
            C.INSURANCE_CHRG   
      Into   
            #Hash_Settlement   
      From   
            Settlement S with(index(stt_index),NOLOCK),   
            #CLIENTMASTER C WITH(NOLOCK)   
      Where   
            Sett_No = @Sett_No                
            And Sett_Type = @Sett_Type                
            And S.Party_code between @FromParty_Code And  @ToParty_Code                
            And S.Party_Code = C.Party_Code   
            And tradeqty > 0                   
            And Sauda_Date <= @Sauda_Date + ' 23:59:59'    
     
  
      Insert Into #Hash_Settlement                
      select   
            S.*,   
            C.BRANCH_CD ,   
            C.SUB_BROKER,   
            C.PRINTF,   
            C.SERVICE_CHRG,   
            C.BROKERNOTE,   
            C.TURNOVER_TAX,   
            C.SEBI_TURN_TAX,   
            OTHER_CHARGE = C.OTHER_CHRG,   
            C.INSURANCE_CHRG   
      from   
            Settlement S with(index(stt_index),NOLOCK),   
            Sett_Mst M WITH(NOLOCK),   
            #CLIENTMASTER C WITH(NOLOCK)   
      Where   
            S.Sett_No = M.Sett_No   
            And S.Sett_Type = M.Sett_Type                
            And M.End_Date > @Sauda_Date + ' 23:59:59'                 
            And M.End_date Not Like @Sauda_Date + '%'                 
            And S.Sett_Type = @Sett_Type          
            And S.Party_code between @FromParty_Code And @ToParty_Code   
            And S.Party_Code = C.Party_Code   
            and s.tradeqty > 0         
            And Sauda_date < @Sauda_Date + ' 23:59'                 
      
/*=========================================================================  
      /*FOR TODAYS TRADE*/   
=========================================================================*/  
      Insert Into #ContSett        
      Select   
            ContractNo,   
            S.Party_code,   
            Order_No,   
            TM=Convert(Varchar,Sauda_Date,108),   
            Trade_no,   
            Sauda_Date,   
            S.Scrip_Cd,   
            S.Series,         
            ScripName = S1.Short_Name + (Case   
                                                When Left(Convert(Varchar,Sauda_date,109),11) = @Sauda_Date   
                                                Then '   '   
                                                Else '-BF'   
                                          End),   
            SDT = Convert(Varchar,Sauda_date,103),   
            Sell_Buy,   
            S.MarketType,    
            Broker_Chrg =(Case When BrokerNote = 1 Then Broker_Chrg Else 0 End ),        
            turn_tax =(Case When Turnover_tax = 1 Then turn_tax Else 0 End),        
            sebi_tax =(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),        
            other_chrg =(Case When OTHER_CHARGE = 1 Then S.other_chrg Else 0 End) ,         
            Ins_Chrg = (Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End ),         
            Service_Tax = (Case When Service_chrg = 0 Then NSerTax Else 0 End ),        
            NSerTax = (Case When Service_chrg = 0 Then NSerTax Else 0 End ),        
            Sauda_Date1 = Left(Convert(Varchar,Sauda_date,109),11),        
            PQty = (Case When Sell_Buy = 1 Then TradeQty Else 0 End),        
            SQty = (Case When Sell_Buy = 2 Then TradeQty Else 0 End),        
            PRate = (Case When Sell_Buy = 1 Then MarketRate Else 0 End),        
            SRate = (Case When Sell_Buy = 2 Then MarketRate Else 0 End),        
            PBrok =   
                  (Case   
                        When Sell_Buy = 1         
                        Then NBrokApp +   
                        (Case   
                              When Service_Chrg = 1         
                              Then NSertax/TradeQty         
                              Else 0         
                        End)        
                        Else 0         
                   End),        
            SBrok =   
                  (Case   
                        When Sell_Buy = 2         
                        Then NBrokApp +   
                        (Case   
                              When Service_Chrg = 1         
                              Then NSertax/TradeQty         
                              Else 0         
                        End)        
                  Else 0         
                  End),        
            PNetRate =   
                  (Case   
                        When Sell_Buy = 1          
                        Then N_NetRate +        
                        (Case   
                              When Service_Chrg = 1         
                              Then NSertax/TradeQty         
                              Else 0         
                        End)        
                  Else 0         
                  End),        
            SNetRate =   
                  (Case   
                        When Sell_Buy = 2          
                        Then N_NetRate -        
                        (Case   
                              When Service_Chrg = 1         
                              Then NSertax/TradeQty         
                              Else 0         
                        End)        
                  Else 0         
                  End),        
            PAmt =   
                  (Case   
                        When Sell_Buy = 1         
                        Then TradeQty*(N_NetRate +        
                        (Case   
                              When Service_Chrg = 1         
                              Then NSertax/TradeQty         
                              Else 0         
                        End))         
                  Else 0         
                  End),        
            SAmt =   
                  (Case   
                        When Sell_Buy = 2        
                        Then TradeQty*(N_NetRate -        
                        (Case   
                              When Service_Chrg = 1         
                              Then NSertax/TradeQty         
                              Else 0         
                        End))         
                  Else 0         
                  End),        
            Brokerage = TradeQty * NBrokApp +   
                                          (Case   
                                                When Service_Chrg = 1   
                                                Then NserTax   
                                                Else 0   
                 End),        
            S.Sett_No,   
            S.Sett_Type,   
            TradeType = '  ',        
            Tmark =   
                  (case   
                        when BillFlag = 1 or BillFlag = 4 or BillFlag = 5   
                        then 'D'   
                        else ''   
                  end),        
            S.service_chrg,   
            S.BRANCH_CD ,   
            S.SUB_BROKER,   
            S.Printf,   
            OrderFlag = 0,   
            ScripName1 = S1.Short_Name,  
            billflag        
      From   
            #Hash_Settlement S,   
            Sett_Mst M,   
            Scrip1 S1,   
            Scrip2 S2   
      Where   
            s.Party_code between @FromParty_Code And  @ToParty_Code        
            And S.Sett_No = @Sett_No   
            And S.Sett_Type = @Sett_Type        
            And S.Sett_No = M.Sett_No   
            And S.Sett_Type = M.Sett_Type        
            And M.End_date Like @Sauda_Date + '%'   
            And S1.Co_Code = S2.Co_Code        
            And S2.Series = S1.Series   
            And S2.Scrip_Cd = S.Scrip_CD   
            And S2.Series = S.Series        
        
      Insert Into #ContSett        
      /*For Other Day Except the Last day of the #Hash_Settlement for not one Day #Hash_Settlement Record */        
      Select   
            ContractNo,   
            S.Party_code,   
            Order_No,   
            TM=Convert(Varchar,Sauda_Date,108),   
            Trade_no,   
            Sauda_Date,   
            S.Scrip_Cd,   
            S.Series,         
            ScripName = S1.Short_Name + ' ',   
            SDT = Convert(Varchar,Sauda_date,103),   
            Sell_Buy,   
            S.MarketType,        
            Broker_Chrg =(Case When BrokerNote = 1 Then Broker_Chrg Else 0 End ),        
            turn_tax =(Case When Turnover_tax = 1 Then turn_tax Else 0 End),        
            sebi_tax =(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),        
            other_chrg =(Case When OTHER_CHARGE = 1 Then S.other_chrg Else 0 End) ,        
            Ins_Chrg = (Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End ),        
            Service_Tax = (Case When Service_chrg = 0 Then NSerTax Else 0 End ),        
            NSerTax = (Case When Service_chrg = 0 Then service_Tax Else 0 End ),        
            Sauda_Date1 = Left(Convert(Varchar,Sauda_date,109),11),        
            PQty = (Case When Sell_Buy = 1 Then TradeQty Else 0 End),        
            SQty = (Case When Sell_Buy = 2 Then TradeQty Else 0 End),        
            PRate = (Case When Sell_Buy = 1 Then MarketRate Else 0 End),        
            SRate = (Case When Sell_Buy = 2 Then MarketRate Else 0 End),        
            PBrok =   
                  (Case   
                        When Sell_Buy = 1         
                        Then BrokApplied +   
                        (Case   
                              When Service_Chrg = 1         
                              Then service_Tax/TradeQty         
                              Else 0         
                        End)        
                  Else 0         
                  End),        
            SBrok =   
                  (Case   
                        When Sell_Buy = 2         
                        Then BrokApplied +   
                        (Case   
                              When Service_Chrg = 1         
                              Then service_Tax/TradeQty         
                              Else 0         
                        End)        
                  Else 0         
                  End),        
            PNetRate =   
                  (Case   
                        When Sell_Buy = 1          
                        Then NetRate +        
                        (Case   
                              When Service_Chrg = 1         
                              Then service_Tax/TradeQty         
                        Else 0         
                        End)        
                  Else 0         
                  End),        
            SNetRate =   
                  (Case   
                        When Sell_Buy = 2          
                        Then NetRate -        
                        (Case   
                              When Service_Chrg = 1         
                              Then service_Tax/TradeQty         
                              Else 0         
                        End)        
                  Else 0         
                  End),        
            PAmt =   
                  (Case   
                        When Sell_Buy = 1         
                        Then TradeQty*(NetRate +        
                        (Case   
                              When Service_Chrg = 1         
                              Then service_Tax/TradeQty         
                              Else 0         
                        End))         
                  Else 0         
                  End),        
            SAmt =   
                  (Case   
                        When Sell_Buy = 2        
                        Then TradeQty*(NetRate -        
                        (Case   
                              When Service_Chrg = 1         
                              Then service_Tax/TradeQty         
                              Else 0         
                        End))         
                  Else 0         
                  End),        
            Brokerage = TradeQty * BrokApplied +   
                                                (Case   
                                                      When Service_Chrg = 1   
                                                      Then service_Tax   
                                                      Else 0   
                                                End),        
            S.Sett_No,   
            S.Sett_Type,   
            TradeType = '  ',        
            Tmark = (case   
                        when BillFlag = 1 or BillFlag = 4 or BillFlag = 5   
                        then 'D'   
                        else ''   
                  end),        
            S.service_chrg,   
            S.BRANCH_CD ,   
            S.SUB_BROKER,   
            S.Printf,   
            OrderFlag = 0,   
            ScripName1 = S1.Short_Name ,        
            billflag        
      From   
            #Hash_Settlement S WITH(NOLOCK),   
            Sett_Mst M WITH(NOLOCK),   
            Scrip1 S1 WITH(NOLOCK),   
            Scrip2 S2 WITH(NOLOCK)  
      Where   
            s.Party_code between @FromParty_Code And  @ToParty_Code        
            And S.Sett_No = @Sett_No   
            And S.Sett_Type = @Sett_Type        
            And S.Sett_No = M.Sett_No   
            And S.Sett_Type = M.Sett_Type        
            And M.End_date Not Like @Sauda_Date + '%'   
            And S1.Co_Code = S2.Co_Code        
            And S2.Series = S1.Series   
            And S2.Scrip_Cd = S.Scrip_CD   
            And S2.Series = S.Series        
        
/*=========================================================================  
      /* ND Record Brought Forward For Same Day Or Previous Days */        
=========================================================================*/  
      Insert Into #ContSett        
      Select   
            ContractNo,   
            S.Party_code,   
            Order_No,   
            TM=Convert(Varchar,Sauda_Date,108),   
            Trade_no,   
            Sauda_Date,   
            S.Scrip_Cd,   
            S.Series,         
            ScripName = S1.Short_Name + (Case When Left(Convert(Varchar,Sauda_date,109),11) = @Sauda_Date Then '-ND' Else '-BF' End),   
            SDT = Convert(Varchar,Sauda_date,103), Sell_Buy, S.MarketType,        
            Broker_Chrg =0,   
            turn_tax=0,   
            sebi_tax=0,   
            s.other_chrg,   
            Ins_Chrg =0,   
            Service_Tax = 0,   
            NSerTax=0,        
            Sauda_Date1 = Left(Convert(Varchar,Sauda_date,109),11),        
            PQty = (Case When Sell_Buy = 1 Then TradeQty Else 0 End),        
            SQty = (Case When Sell_Buy = 2 Then TradeQty Else 0 End),        
            PRate = (Case When Sell_Buy = 1 Then MarketRate Else 0 End),        
            SRate = (Case When Sell_Buy = 2 Then MarketRate Else 0 End),        
            PBrok = 0,         
            SBrok = 0,         
            PNetRate = (Case When Sell_Buy = 1 Then MarketRate Else 0 End),        
            SNetRate = (Case When Sell_Buy = 2 Then MarketRate Else 0 End),        
            PAmt = (Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End),        
            SAmt = (Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End),        
            Brokerage = 0,   
            S.Sett_No,   
            S.Sett_Type,   
            TradeType = 'BF',        
            Tmark = case when BillFlag = 1 or BillFlag = 4 or BillFlag = 5 then '' else '' end ,        
            S.service_chrg,  
            S.BRANCH_CD ,   
            S.SUB_BROKER,   
            S.Printf,  
            OrderFlag = 0,   
            ScripName1 = S1.Short_Name ,        
            billflag        
      From   
            #Hash_Settlement S WITH(NOLOCK),        
            Sett_Mst M WITH(NOLOCK),   
            Scrip1 S1 WITH(NOLOCK),   
            Scrip2 S2 WITH(NOLOCK)  
      Where   
            s.Party_code between @FromParty_Code And  @ToParty_Code        
            And M.End_Date > @Sauda_Date + ' 23:59:59'   
            And s.Sett_Type = @Sett_Type        
            And S.Sett_No = M.Sett_No   
            And S.Sett_Type = M.Sett_Type        
            And M.End_date Not Like @Sauda_Date + '%'   
            And S1.Co_Code = S2.Co_Code        
            And S2.Series = S1.Series   
            And S2.Scrip_Cd = S.Scrip_CD   
            And S2.Series = S.Series        
        
/*=========================================================================  
      /* ND Record Carry Forward For Same Day Or Previous Days */        
=========================================================================*/  
      Insert Into #ContSett        
      Select   
            ContractNo,   
            S.Party_code,   
            Order_No,   
            TM=Convert(Varchar,Sauda_Date,108),   
            Trade_no,   
            Sauda_Date,   
            S.Scrip_Cd,   
            S.Series,         
            ScripName = S1.Short_Name + '-CF' ,   
            SDT = Convert(Varchar,Sauda_date,103),   
            Sell_Buy=(CASE WHEN SELL_BUY = 1 THEN 2 ELSE 1 END),   
            S.MarketType,        
            Broker_Chrg =0,   
            turn_tax=0,   
            sebi_tax=0,   
            s.other_chrg,   
            Ins_Chrg = 0,   
            Service_Tax = 0,   
            NSerTax=0,        
            Sauda_Date1 = Left(Convert(Varchar,Sauda_date,109),11),        
            PQty = (Case When Sell_Buy = 2 Then TradeQty Else 0 End),        
            SQty = (Case When Sell_Buy = 1 Then TradeQty Else 0 End),        
            PRate = (Case When Sell_Buy = 2 Then MarketRate Else 0 End),        
            SRate = (Case When Sell_Buy = 1 Then MarketRate Else 0 End),        
            PBrok = 0,         
            SBrok = 0,         
            PNetRate = (Case When Sell_Buy = 2 Then MarketRate Else 0 End),        
            SNetRate = (Case When Sell_Buy = 1 Then MarketRate Else 0 End),        
            PAmt = (Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End),        
            SAmt = (Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End),        
            Brokerage = 0,   
            S.Sett_No,   
            S.Sett_Type,   
            TradeType = 'CF',        
            Tmark = case when BillFlag = 1 or BillFlag = 4 or BillFlag = 5 then '' else '' end ,        
            S.service_chrg,   
            S.BRANCH_CD ,   
            S.SUB_BROKER,   
            S.Printf,   
            OrderFlag = 1,   
            ScripName1 = S1.Short_Name ,        
            billflag        
      From   
            #Hash_Settlement S WITH(NOLOCK),        
            Sett_Mst M WITH(NOLOCK),   
            Scrip1 S1 WITH(NOLOCK),   
            Scrip2 S2 WITH(NOLOCK)  
      Where   
            s.Party_code between @FromParty_Code And  @ToParty_Code        
            And M.End_Date > @Sauda_Date + ' 23:59:59'   
            And s.Sett_Type = @Sett_Type        
            And S.Sett_No = M.Sett_No   
            And S.Sett_Type = M.Sett_Type        
            And M.End_date Not Like @Sauda_Date + '%'   
            And S1.Co_Code = S2.Co_Code        
            And S2.Series = S1.Series   
            And S2.Scrip_Cd = S.Scrip_CD   
            And S2.Series = S.Series        
        

/*=========================================================================  
      Populate Summarized Contract Data for Clients with PrintF Flag = 3        
=========================================================================*/  
      Insert Into #ContSettNew   
      select   
            ContractNo,  
            Party_code,  
            Order_No='0000000000000000',  
            TM='0000000000000',  
            Trade_no='00000000000000',        
            Sauda_Date=Left(Convert(Varchar,Sauda_Date,109),11),  
            Scrip_Cd,  
            Series,  
            ScripName,  
            SDT,        
            Sell_Buy,  
            MarketType,  
            Broker_Chrg=Sum(Broker_Chrg),  
            turn_tax=Sum(Turn_Tax),  
            sebi_tax=Sum(sebi_tax),        
            other_chrg=Sum(Other_Chrg),  
            Ins_Chrg = sum(Ins_chrg),  
            Service_Tax = sum(Service_Tax),  
            NSerTax=Sum(NSerTax),  
            Sauda_Date1,  
            PQty=Sum(PQty),  
            SQty=Sum(SQty),        
            PRate=(Case When Sum(PQty) > 0 Then Sum(PRate*PQty)/Sum(PQty) Else 0 End),        
            SRate=(Case When Sum(SQty) > 0 Then Sum(SRate*SQty)/Sum(SQty) Else 0 End),        
            PBrok=(Case When Sum(PQty) > 0 Then Sum(PBrok*PQty)/Sum(PQty) Else 0 End),        
            SBrok=(Case When Sum(SQty) > 0 Then Sum(SBrok*SQty)/Sum(SQty) Else 0 End),        
            PNetRate=(Case When Sum(PQty) > 0 Then Sum(PNetRate*PQty)/Sum(PQty) Else 0 End),        
            SNetRate=(Case When Sum(SQty) > 0 Then Sum(SNetRate*SQty)/Sum(SQty) Else 0 End),        
            PAmt=Sum(PAmt),  
            SAmt=Sum(SAmt),  
            Brokerage=Sum(Brokerage),  
            Sett_No,  
            Sett_Type,  
            TradeType,  
            Tmark,  
            Partyname = '',  
            l_address1 = '',  
            l_address2 = '',  
            l_address3 = '',  
            l_city= '',  
            l_zip = '',  
            service_chrg,  
            Branch_cd,  
            sub_broker,  
            pan_gir_no = '',  
            Off_Phone1 = '',  
            Off_Phone2 = '',  
            Printf,  
            mapidid = '',   
            OrderFlag,        
            ScripName1 ,   
            billflag        
      From   
            #ContSett WITH(NOLOCK)   
      Where   
            Printf = '3'         
      Group By   
            BRANCH_CD, SUB_BROKER, ContractNo,Party_code,Left(Convert(Varchar,Sauda_Date,109),11),Scrip_Cd,Series,ScripName,SDT,        
            Sell_Buy,MarketType,Sett_No,Sett_Type,Sauda_Date1,TradeType,Tmark,service_chrg,Printf,OrderFlag,ScripName1 , billflag        
      Order By   
            BRANCH_CD, SUB_BROKER, Party_code,ContractNo,ScripName1,OrderFlag,Sett_No, Sett_Type,  Order_No, Trade_No        
  

/*=========================================================================  
      Update Min Order No / Trade Time / Trade No for summarized contract
=========================================================================*/  
      Update #ContSettNew   
      Set   
            Order_No = S.Order_No,   
            TM = Convert(Varchar,S.Sauda_Date,108),   
            Trade_No = S.Trade_No        
      From   
            #ContSett S WITH(NOLOCK)   
      Where         
            S.PrintF = #ContSettNew.PrintF   
            And S.PrintF = '3'   
            And S.Sauda_Date Like @Sauda_Date + '%'        
            And S.Scrip_cd = #ContSettNew.Scrip_CD        
            And S.Series = #ContSettNew.Series        
            And S.Party_Code = #ContSettNew.Party_Code        
            And S.ContractNo = #ContSettNew.ContractNo        
            And S.Sell_Buy = #ContSettNew.Sell_Buy        
            And S.Sauda_Date =   
                        (  
                              Select   
                                    Min(Sauda_Date)   
                              From   
                                    #ContSett ISett WITH(NOLOCK)        
                              Where   
                                    PrintF = '3'   
                                    And ISett.Sauda_Date Like @Sauda_Date + '%'        
                                    And S.Scrip_cd = ISett.Scrip_CD        
                                    And S.Series = ISett.Series        
                                    And S.Party_Code = ISett.Party_Code        
                                    And S.ContractNo = ISett.ContractNo        
                                    And S.Sell_Buy = ISett.Sell_Buy   
                        )        


/*=========================================================================  
      Populate Detailed Contract Data for Clients with PrintF Flag <> 3        
=========================================================================*/  
      Insert into #ContSettNew         
      Select   
            ContractNo,  
            Party_code,  
            Order_No,  
            TM,  
            Trade_no,        
            Sauda_Date,  
            Scrip_Cd,  
            Series,  
            ScripName,  
            SDT,        
            Sell_Buy,  
            MarketType,  
            Broker_Chrg,  
            turn_tax,  
            sebi_tax,        
            other_chrg,  
            Ins_Chrg,  
            Service_Tax,  
            NSerTax,  
            Sauda_Date1,  
            PQty,  
            SQty,        
            PRate,        
            SRate,        
            PBrok,        
            SBrok,        
            PNetRate,        
            SNetRate,        
            PAmt,  
            SAmt,  
            Brokerage,  
            Sett_No,  
            Sett_Type,  
            TradeType,  
            Tmark,  
            Partyname = '',  
            l_address1 = '',  
            l_address2 = '',  
            l_address3 = '',  
            l_city= '',  
            l_zip = '',  
            service_chrg,  
            Branch_cd,  
            sub_broker,  
            pan_gir_no = '',  
            Off_Phone1 = '',  
            Off_Phone2 = '',  
            Printf,  
            mapidid = '',   
            OrderFlag,        
            ScripName1 ,   
            billflag        
      From   
            #ContSett WITH(NOLOCK)   
      Where   
            Printf <> '3'         
      Order By   
            BRANCH_CD, SUB_BROKER, Party_code,ContractNo,ScripName1,OrderFlag,Sett_No, Sett_Type,  Order_No, Trade_No        
    
/*
      CREATE 
        INDEX [cont] ON [dbo].[#ContsettNew] ([Scrip_Cd], [Series], [Party_code], [Sell_Buy], [ContractNo])          
      ON [PRIMARY]          
                
      CREATE 
        INDEX [cont] ON [dbo].[#Contsett] ([Scrip_Cd], [Series], [Party_code], [Sell_Buy], [ContractNo])          
      ON [PRIMARY]          
*/              

/*=========================================================================  
      Update Header Information in the first row of each contract 
=========================================================================*/  
      Update   
            #ContSettNew   
      Set   
            Partyname = C.LONG_NAME,  
            l_address1 = C.l_address1,  
            l_address2 = C.l_address2,  
            l_address3 = C.l_address3,  
            l_city= C.l_city,  
            l_zip = C.l_zip,  
            pan_gir_no = C.pan_gir_no,  
            Off_Phone1 = C.Off_Phone1,  
            Off_Phone2 = C.Off_Phone2,  
            mapidid = C.mapidid   
      From   
            #CLIENTMASTER C WITH(NOLOCK),   
            (Select Party_Code, ContractNo, SrNo = Min(SrNo) From #ContSettNew WITH(NOLOCK) Group By Party_Code, ContractNo) S   
      Where   
            #ContSettNew.Party_Code = C.Party_Code   
            And C.Party_Code = S.Party_Code   
            And #ContSettNew.Party_Code = S.Party_Code   
            And #ContSettNew.SrNo = S.SrNo  
            And #ContSettNew.ContractNo = S.ContractNo  
  

/*=========================================================================  
      Final Select Query
=========================================================================*/  
      Select   
            ContractNo,Party_code,Order_No,TM,Trade_no,Sauda_Date,Scrip_Cd,Series,ScripName,SDT,Sell_Buy,MarketType,Broker_Chrg,
            turn_tax,sebi_tax,other_chrg,Ins_Chrg,Service_Tax,NSerTax,Sauda_Date1,PQty,SQty,PRate,SRate,PBrok,SBrok,PNetRate,SNetRate,
            PAmt,SAmt,Brokerage,Sett_No,Sett_Type,TradeType,Tmark,Partyname,l_address1,l_address2,l_address3,l_city,l_zip,service_chrg,
            Branch_cd,sub_broker,pan_gir_no,Off_Phone1,Off_Phone2,Printf,mapidid,OrderFlag,ScripName1,billflag, SrNo 
      From   
            #ContSettNew WITH(NOLOCK)         
      order by   
            Branch_cd,Sub_Broker,  
            Party_code, 
            ContractNo, SrNo, 
            Partyname,  
            ScripName1,OrderFlag,Sett_No, Sett_Type,  Order_No, Trade_No        

Drop Table #ContSett 
Drop Table #ContSettNew 
Drop Table #CLIENTMASTER 
Drop Table #Hash_Settlement

GO
