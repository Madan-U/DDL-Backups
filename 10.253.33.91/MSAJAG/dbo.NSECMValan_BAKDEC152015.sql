-- Object: PROCEDURE dbo.NSECMValan_BAKDEC152015
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc [dbo].[NSECMValan] (         
       
@Sett_No Varchar(7),                     
@Sett_Type Varchar(2),          
@SDate Varchar(11),          
@Party_Code Varchar(10),          
@Scrip_Cd Varchar(12),          
@Series Varchar(3),          
@StatusName Varchar(15))          
As           
/* Drop Proc NSECMValan */          
          
/* Set Nocount On */          
          
If @Party_Code = ''           
 Select @Party_Code = '%'          
          
If @Scrip_Cd = ''           
 Select @Scrip_Cd = '%'          
          
If @Series = ''           
 Select @Series = '%'          
          
If @sdate = ''           
   Select @sdate = '%'          
          
Truncate Table CMBillValan_Temp          
          
Insert Into CMBillValan_Temp           
          
/* Normal Trade From Settlement WithOut ND Scrip */          
select S.Sett_no,S.Sett_Type,billno,S.ContractNo,S.party_code,Party_Name=Left(C1.Long_Name, 50),S.Scrip_Cd,S.Series,          
Scrip_Name='',IsIn='',Sauda_Date=Left(Convert(Varchar,S.Sauda_Date,109),11),          
PQtyTrd = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 1 And BillFlag = 2           
          Then TradeQty          
          Else 0           
     End )           
      Else (Case When Sell_Buy = 1 And SettFlag = 2           
          Then TradeQty           
          Else 0           
     End )           
      End),           
PAmtTrd = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 1 And BillFlag = 2           
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate + NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
      Else (Case When Sell_Buy = 1 And SettFlag = 2           
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate + NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
      End),           
PQtyDel = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 1 And BillFlag in (1,4)           
          Then TradeQty          
          Else 0           
     End )           
      Else (Case When Sell_Buy = 1 And SettFlag in (1,4)          
          Then TradeQty           
          Else 0           
     End )           
      End),           
PAmtDel = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 1 And BillFlag in (1,4)          
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate + NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
      Else (Case When Sell_Buy = 1 And SettFlag in (1,4)          
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate + NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
      End),           
SQtyTrd = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 2 And BillFlag = 3          
          Then TradeQty          
          Else 0           
     End )           
      Else (Case When Sell_Buy = 2 And SettFlag = 3           
          Then TradeQty           
          Else 0           
     End )           
      End),           
SAmtTrd = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 2 And BillFlag = 3           
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate - NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
    Else (Case When Sell_Buy = 2 And SettFlag = 3           
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate - NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
      End),           
SQtyDel = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 2 And BillFlag in (1,5)        
          Then TradeQty          
          Else 0           
     End )           
      Else (Case When Sell_Buy = 2 And SettFlag in (1,5)          
        Then TradeQty           
          Else 0           
     End )           
      End),           
SAmtDel = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 2 And BillFlag in (1,5)          
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate - NserTax             
                           else tradeqty * N_NetRate           
                 end )          
          Else 0           
     End )           
      Else (Case When Sell_Buy = 2 And SettFlag in (1,5)          
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate - NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
      End),           
PBrokTrd = Sum(Case When BillNo > 0           
         Then (Case When Sell_Buy = 1 And BillFlag = 2           
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
  Else          
            (Case When Sell_Buy = 1 And SettFlag = 2          
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
              End),           
SBrokTrd = Sum(Case When BillNo > 0           
         Then (Case When Sell_Buy = 2 And BillFlag = 3          
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
  Else          
            (Case When Sell_Buy = 2 And SettFlag = 3          
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
              End),          
PBrokDel = Sum(Case When BillNo > 0           
         Then (Case When Sell_Buy = 1 And BillFlag in (1,4)           
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
  Else          
            (Case When Sell_Buy = 1 And SettFlag in (1,4)          
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
              End),          
SBrokDel =  Sum(Case When BillNo > 0           
         Then (Case When Sell_Buy = 2 And BillFlag in (1,5)           
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
  Else          
            (Case When Sell_Buy = 2 And SettFlag in (1,5)          
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
              End),          
Family,FamilyName='',Terminal_Id=User_Id,ClientType=Cl_Type,TradeType='S',Trader,Sub_Broker,Branch_cd,PartipantCode,          
pamt = isnull(Sum(case when sell_buy = 1           
      then (case when Service_chrg = 2           
                 then tradeqty * N_NetRate             
          else tradeqty * N_NetRate + NserTax          
     end ) +           
    (CASE WHEN dispcharge = 1            
          THEN (CASE WHEN Turnover_tax = 1           
                       THEN turn_tax          
                     else 0           
         end )              
          else 0          
     end ) +           
    (CASE WHEN dispcharge = 1           
          THEN (CASE WHEN Sebi_Turn_tax = 1           
       THEN (Sebi_Tax)             
              else 0           
         end )              
          else 0           
     end ) +           
    (CASE WHEN dispcharge = 1           
          THEN (CASE WHEN Insurance_Chrg = 1           
       THEN Ins_chrg          
                     else 0           
         end )          
          else 0           
     end ) +           
    (CASE WHEN dispcharge = 1         
          THEN (CASE WHEN Brokernote = 1           
       THEN (Broker_chrg)             
              else 0           
                       end )              
                 else 0           
     end ) +           
    (CASE WHEN dispcharge = 1           
          THEN (CASE WHEN c2.Other_chrg = 1           
       THEN (S.other_chrg)             
                     else 0           
         end )              
                               else 0         
  end )            
   Else 0           
   end),0),            
Samt = isnull(Sum(case when sell_buy = 2           
      then (case when Service_chrg = 2           
                 then tradeqty * N_NetRate             
          else tradeqty * N_NetRate - NserTax          
     end ) -           
    (CASE WHEN dispcharge = 1           
          THEN (CASE WHEN Turnover_tax = 1           
            THEN turn_tax          
                     else 0           
         end )              
          else 0          
     end ) -           
    (CASE WHEN dispcharge = 1           
          THEN (CASE WHEN Sebi_Turn_tax = 1           
       THEN (Sebi_Tax)             
              else 0           
         end )              
          else 0           
     end ) -           
    (CASE WHEN dispcharge = 1           
          THEN (CASE WHEN Insurance_Chrg = 1           
       THEN Ins_chrg          
                     else 0           
         end )          
          else 0           
     end ) -           
    (CASE WHEN dispcharge = 1           
          THEN (CASE WHEN Brokernote = 1           
       THEN (Broker_chrg)             
              else 0           
                       end )              
                 else 0           
     end ) -          
    (CASE WHEN dispcharge = 1           
          THEN (CASE WHEN c2.Other_chrg = 1           
       THEN (S.other_chrg)             
                     else 0           
         end )              
                               else 0          
                          end )            
   Else 0           
   end),0),            
PRate = Sum(Case When Sell_Buy = 1 Then (TradeQty*S.Dummy1) Else 0 End),            
SRate = Sum(Case When Sell_Buy = 2 Then (TradeQty*S.Dummy1) Else 0 End),          
TrdAmt = Sum(TradeQty*S.MarketRate),           
DelAmt = Sum((Case When BillFlag in (1,4,5)          
         Then TradeQty*S.MarketRate          
        Else 0           
   End)),           
SerInEx = Service_chrg,          
Service_Tax = Sum(NserTax),          
ExService_Tax = Sum(Case When Service_chrg = 2           
        Then (NserTax)          
        Else 0           
   End),           
Turn_Tax = Sum(Case WHEN dispcharge = 1           
   THEN (Case WHEN Turnover_tax = 1           
              THEN (turn_tax)             
                 Else 0           
         End)              
          else 0           
     End ),          
Sebi_Tax = Sum(Case WHEN dispcharge = 1           
   THEN (CASE WHEN Sebi_Turn_tax = 1           
              THEN (Sebi_Tax)             
       Else 0           
         End)              
   Else 0           
     End),            
Ins_Chrg = Sum(Case WHEN dispcharge = 1           
   THEN (CASE WHEN Insurance_Chrg = 1           
       THEN (Ins_chrg)             
            Else 0           
         End)              
   Else 0           
     End),          
Broker_Chrg = Sum(CASE WHEN dispcharge = 1           
      THEN (CASE WHEN Brokernote = 1           
          THEN (Broker_chrg)             
                 Else 0           
            End)              
      Else 0           
    End),          
Other_Chrg = Sum(CASE WHEN dispcharge = 1           
     THEN (CASE WHEN c2.Other_chrg = 1           
                THEN (S.other_chrg)             
                Else 0           
           End)              
     Else 0           
       End),            
Region, Start_Date='', End_Date='', Update_Date=Left(Convert(Varchar,GetDate(),109),11), Status_Name=@StatusName,          
Exchange='NSE',Segment='CAPITAL',MemberType=MemberCode,CompanyName='',Dummy1='',Dummy2='',Dummy3='',Dummy4=0,Dummy5=0, Area          
from settlement S, Client2 C2, OWNER,Client1 C1           
where S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type         
And C2.Cl_Code = S.Party_Code and C1.cl_code = c2.cl_code            
And AuctionPart Not in ('AP','AR') And MarketRate > 0 And TradeQty > 0             
group by sett_no,sett_type,ContractNo,BillNo,s.party_code,C1.Long_Name,S.Scrip_Cd,S.series,Left(Convert(Varchar,S.Sauda_Date,109),11),          
C1.family,User_Id,Trader,Sub_Broker,PartipantCode,MemberCode,          
service_chrg,Branch_cd,Cl_Type, Region, Area          
      
  INSERT INTO CMBillValan_Temp        
  SELECT   S.CD_SETT_NO,        
           S.CD_SETT_TYPE,        
           BILLNO = 0,        
           CONTRACTNO = '0',        
           S.CD_PARTY_CODE,        
           PARTY_NAME = LEFT(C1.LONG_NAME, 50),      
           SCRIP_CD = (CASE         
                         WHEN S.CD_SCRIP_CD = '' THEN 'BROKERAGE'        
                         ELSE S.CD_SCRIP_CD        
                       END),        
           SERIES = (CASE         
                       WHEN S.CD_SERIES = '' THEN (CASE         
                                                     WHEN CD_SETT_TYPE = 'W' THEN 'BE'        
                                                     ELSE 'EQ'        
                                                   END)        
                       ELSE S.CD_SERIES        
                     END),        
           SCRIP_NAME = '',        
           ISIN = '',        
           SAUDA_DATE = LEFT(CONVERT(VARCHAR,S.CD_SAUDA_DATE,109),11),        
           PQTYTRD = 0,        
           PAMTTRD = SUM(CD_TRDBUYBROKERAGE + (CASE         
                                                 WHEN SERVICE_CHRG = 1 THEN CD_TRDBUYSERTAX        
                                                 ELSE 0        
                                               END)),        
           PQTYDEL = 0,        
           PAMTDEL = SUM(CD_DELBUYBROKERAGE + (CASE         
                                                 WHEN SERVICE_CHRG = 1 THEN CD_DELBUYSERTAX        
                                                 ELSE 0        
                                               END)),        
           SQTYTRD = 0,        
           SAMTTRD = SUM(CD_TRDSELLBROKERAGE + (CASE         
                                                  WHEN SERVICE_CHRG = 1 THEN CD_TRDSELLSERTAX        
                                                  ELSE 0        
                                                END)),        
           SQTYDEL = 0,        
           SAMTDEL = SUM(CD_DELSELLBROKERAGE + (CASE         
                                                  WHEN SERVICE_CHRG = 1 THEN CD_DELSELLSERTAX        
                                                  ELSE 0        
                                          END)),        
           PBROKTRD = SUM(CD_TRDBUYBROKERAGE),        
           SBROKTRD = SUM(CD_TRDSELLBROKERAGE),        
           PBROKDEL = SUM(CD_DELBUYBROKERAGE),        
           SBROKDEL = SUM(CD_DELSELLBROKERAGE),        
           FAMILY,        
           FAMILYNAME = '',        
           TERMINAL_ID = '0',        
           CLIENTTYPE = CL_TYPE,        
           TRADETYPE = 'S',        
           TRADER,        
           SUB_BROKER,        
           BRANCH_CD,        
           MEMBERCODE,        
       PAMT = SUM(CD_TRDBUYBROKERAGE + CD_DELBUYBROKERAGE + (CASE         
                                                                   WHEN SERVICE_CHRG = 1 THEN CD_TRDBUYSERTAX + CD_DELBUYSERTAX        
                                                                   ELSE 0        
                                                                 END)),        
           SAMT = SUM(CD_TRDSELLBROKERAGE + CD_DELSELLBROKERAGE + (CASE         
                                                                     WHEN SERVICE_CHRG = 1 THEN CD_TRDSELLSERTAX + CD_DELSELLSERTAX        
                                                                     ELSE 0        
                                                                   END)),        
           PRATE = 0,        
    SRATE = 0,        
           TRDAMT = 0,        
           DELAMT = 0,        
           SERINEX = SERVICE_CHRG,        
           SERVICE_TAX = SUM(CD_TRDBUYSERTAX + CD_DELBUYSERTAX + CD_TRDSELLSERTAX + CD_DELSELLSERTAX),        
           EXSERVICE_TAX = SUM(CASE         
                                 WHEN SERVICE_CHRG = 2 THEN (CD_TRDBUYSERTAX + CD_DELBUYSERTAX + CD_TRDSELLSERTAX + CD_DELSELLSERTAX)        
                                 ELSE 0        
                               END),        
           TURN_TAX = 0,        
           SEBI_TAX = 0,        
           INS_CHRG = 0,        
           BROKER_CHRG = 0,        
           OTHER_CHRG = 0,        
           REGION,        
           START_DATE = '',        
           END_DATE = '',        
           UPDATE_DATE = LEFT(CONVERT(VARCHAR,GETDATE(),109),11),        
   STATUS_NAME = @StatusName,        
           EXCHANGE = 'NSE',        
           SEGMENT = 'CAPITAL',        
           MEMBERTYPE = MEMBERCODE,        
           COMPANYNAME = '',        
           DUMMY1 = '',        
           DUMMY2 = '',        
           DUMMY3 = '',        
           DUMMY4 = 0,        
           DUMMY5 = 0,        
           AREA        
  FROM     CHARGES_DETAIL S,        
           CLIENT2 C2,        
           OWNER,        
           CLIENT1 C1        
  WHERE    S.CD_SETT_NO = @SETT_NO        
           AND S.CD_SETT_TYPE = @SETT_TYPE        
           AND C2.Cl_Code = S.CD_PARTY_CODE        
           AND C1.CL_CODE = C2.CL_CODE        
  GROUP BY CD_SETT_NO,CD_SETT_TYPE,S.CD_PARTY_CODE,C1.LONG_NAME,        
           S.CD_SCRIP_CD,S.CD_SERIES,LEFT(CONVERT(VARCHAR,S.CD_SAUDA_DATE,109),11),C1.FAMILY,        
           TRADER,SUB_BROKER,MEMBERCODE,SERVICE_CHRG,        
           BRANCH_CD,CL_TYPE,REGION,AREA,        
           L_STATE      
          
Insert Into CMBillValan_Temp           
select S.Sett_no,S.Sett_Type,billno,S.ContractNo,S.party_code,Party_Name= Left(C1.Long_Name, 50),S.Scrip_Cd,S.Series,          
Scrip_Name='',IsIn='',Sauda_Date=Left(Convert(Varchar,S.Sauda_Date,109),11),          
PQtyTrd = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 1 And BillFlag = 2           
          Then TradeQty          
          Else 0           
     End )           
      Else (Case When Sell_Buy = 1 And SettFlag = 2           
          Then TradeQty           
          Else 0           
     End )           
      End),           
PAmtTrd = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 1 And BillFlag = 2           
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate + NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
      Else (Case When Sell_Buy = 1 And SettFlag = 2           
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate + NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
      End),           
PQtyDel = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 1 And BillFlag in (1,4)           
          Then TradeQty          
      Else 0           
     End )           
      Else (Case When Sell_Buy = 1 And SettFlag in (1,4)          
          Then TradeQty           
          Else 0           
     End )           
      End),           
PAmtDel = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 1 And BillFlag in (1,4)          
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate + NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
      Else (Case When Sell_Buy = 1 And SettFlag in (1,4)          
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate + NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
      End),           
SQtyTrd = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 2 And BillFlag = 3          
          Then TradeQty          
          Else 0           
     End )           
      Else (Case When Sell_Buy = 2 And SettFlag = 3           
          Then TradeQty           
          Else 0           
     End )           
      End),           
SAmtTrd = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 2 And BillFlag = 3           
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate - NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )         
      Else (Case When Sell_Buy = 2 And SettFlag = 3           
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate - NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
      End),           
SQtyDel = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 2 And BillFlag in (1,5)          
          Then TradeQty          
          Else 0           
     End )           
      Else (Case When Sell_Buy = 2 And SettFlag in (1,5)          
          Then TradeQty           
          Else 0           
     End )           
      End),           
SAmtDel = Sum(Case When BillNo > 0           
             Then (Case When Sell_Buy = 2 And BillFlag in (1,5)          
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate - NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
      Else (Case When Sell_Buy = 2 And SettFlag in (1,5)          
        Then (case when Service_chrg = 1           
                           then tradeqty * N_NetRate - NserTax             
                           else tradeqty * N_NetRate           
                  end )          
          Else 0           
     End )           
      End),           
PBrokTrd = Sum(Case When BillNo > 0           
         Then (Case When Sell_Buy = 1 And BillFlag = 2           
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
  Else          
            (Case When Sell_Buy = 1 And SettFlag = 2          
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
              End),           
SBrokTrd = Sum(Case When BillNo > 0      
         Then (Case When Sell_Buy = 2 And BillFlag = 3          
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
  Else          
            (Case When Sell_Buy = 2 And SettFlag = 3          
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
              End),          
PBrokDel = Sum(Case When BillNo > 0           
         Then (Case When Sell_Buy = 1 And BillFlag in (1,4)           
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
  Else          
            (Case When Sell_Buy = 1 And SettFlag in (1,4)          
           Then TradeQty*NBrokApp          
                      Else 0           
           End)          
              End),          
SBrokDel =  Sum(Case When BillNo > 0           
         Then (Case When Sell_Buy = 2 And BillFlag in (1,5)           
                      Then TradeQty*NBrokApp          
                      Else 0           
            End)          
  Else          
            (Case When Sell_Buy = 2 And SettFlag in (1,5)          
                      Then TradeQty*NBrokApp          
     Else 0           
   End)          
              End),          
Family,FamilyName='',Terminal_Id=User_Id,ClientType=Cl_Type,TradeType='I',Trader,Sub_Broker,Branch_cd,PartipantCode,          
pamt = isnull(Sum(case when sell_buy = 1           
      then (case when Service_chrg = 2           
                 then tradeqty * N_NetRate             
          else tradeqty * N_NetRate + NserTax          
     end )           
   Else 0           
   end),0),            
Samt = isnull(Sum(case when sell_buy = 2           
      then (case when Service_chrg = 2           
                 then tradeqty * N_NetRate             
          else tradeqty * N_NetRate - NserTax          
     end )           
   Else 0           
   end),0),            
PRate = 0,            
SRate = 0,          
TrdAmt = Sum(TradeQty*S.MarketRate),           
DelAmt = Sum(TradeQty*S.MarketRate),           
SerInEx = Service_chrg,          
Service_Tax = Sum(NserTax),          
ExService_Tax = Sum(Case When Service_chrg = 2           
        Then (NserTax)          
        Else 0           
   End),          
Turn_Tax = 0,          
Sebi_Tax = 0,            
Ins_Chrg = Sum(Case WHEN dispcharge = 1           
   THEN (CASE WHEN Insurance_Chrg = 1           
      THEN (Ins_chrg)             
            Else 0           
         End)              
   Else 0           
     End),          
Broker_Chrg = 0,          
Other_Chrg = 0,            
Region, Start_Date='', End_Date='', Update_Date=Left(Convert(Varchar,GetDate(),109),11), Status_Name=@StatusName,          
Exchange='NSE',Segment='CAPITAL',MemberType=MemberCode,CompanyName='',Dummy1='',Dummy2='',Dummy3='',Dummy4=0,Dummy5=0,Area          
from Isettlement S, Client2 C2, OWNER,Client1  C1           
where S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type           
And C2.Cl_Code = S.Party_Code and C1.cl_code = c2.cl_code                    
And AuctionPart Not in ('AP','AR') And MarketRate > 0           
group by sett_no,sett_type,ContractNo,BillNo,s.party_code,C1.Long_Name,S.Scrip_Cd,S.series,
Left(Convert(Varchar,S.Sauda_Date,109),11),          
C1.family,User_Id,Trader,Sub_Broker,PartipantCode,MemberCode,          
service_chrg,Branch_cd,Cl_Type, Region, Area          
          
Update CMBillValan_Temp Set Scrip_Name = S1.Long_Name From Scrip1 S1, Scrip2 S2           
Where CMBillValan_Temp.Sett_no = @Sett_No And CMBillValan_Temp.Sett_Type = @Sett_Type          
AND S1.Co_Code = S2.Co_Code And S1.Series = S2.Series And CMBillValan_Temp.Scrip_Cd = S2.Scrip_Cd  
and CMBillValan_Temp.Series = S2.Series          
      
Update CMBillValan_Temp Set IsIn = M.IsIn From MultiIsIn M           
Where CMBillValan_Temp.Sett_no = @Sett_No And CMBillValan_Temp.Sett_Type = @Sett_Type     
AND M.Scrip_Cd = CMBillValan_Temp.Scrip_Cd and M.Series = CMBillValan_Temp.Series And Valid = 1           
      
Update CMBillValan_Temp Set Family_Name = Left(C1.Long_Name, 50) From Client1 C1          
Where CMBillValan_Temp.Sett_no = @Sett_No And CMBillValan_Temp.Sett_Type = @Sett_Type          
And C1.cl_code = CMBillValan_Temp.party_code     
And C1.Family = CMBillValan_Temp.Family           
          
Update CMBillValan_Temp Set 
		Start_Date = Left(Convert(Varchar,S.Start_Date,109),11),
		End_Date = Left(Convert(Varchar,S.End_Date,109),11)          
From Sett_Mst S  
Where CMBillValan_Temp.Sett_no = @Sett_No And CMBillValan_Temp.Sett_Type = @Sett_Type          
And S.Sett_No = CMBillValan_Temp.Sett_No And S.Sett_Type = CMBillValan_Temp.Sett_Type  
          
Delete From CMBillValan Where Sett_No = @Sett_No And Sett_Type = @Sett_Type  
          
Insert into CMBillValan          
Select * From CMBillValan_Temp(nolock)

GO
