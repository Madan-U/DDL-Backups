-- Object: PROCEDURE dbo.Rpt_proc_nse_scripwise_New
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



--EXEC rpt_proc_NSE_ScripWise_New 'Jan 1 2005', 'Dec 22 2005', '2005061', '2005103', '3IINFOTECH', 'ZUARIAGRO', '21740', '21740'        
        
/****** Object:  Stored Procedure Dbo.rpt_proc_nse_scripwise    Script Date: 01/15/2005 1:44:13 Pm ******/            
            
/****** Object:  Stored Procedure Dbo.rpt_proc_nse_scripwise    Script Date: 12/16/2003 2:31:57 Pm ******/            
            
/****** Object:  Stored Procedure Dbo.rpt_proc_nse_scripwise    Script Date: Jan 24 2003 3:13:27 Pm ******/            
          
CREATE   Procedure Rpt_proc_nse_scripwise_New            
 @datefrom Varchar(50),            
 @dateto Varchar(50),            
 @settnofrom Varchar(15),            
 @settnoto Varchar(15),            
 @scripfrom Varchar(10),            
 @scripto Varchar(10),            
 @partyfrom Varchar(10),            
 @partyto Varchar(10)            
As            
 Select            
  Saudadate=Convert(varchar,C.Sauda_date,103),          
  C.sett_no,            
  C.scrip_cd,            
  C.series,            
  C.party_code,            
  C.party_name,            
  Ownercode = Membercode, --hardcoded For Mosl            
  Ownername = Company, --hardcoded For Mosl            
  Sum(pqtytrd+pqtydel) As Grosspurchaseqty,            
  Sum(sqtytrd+sqtydel) As Grosssellqty,            
  Sum(pqtytrd+pqtydel) - Sum(sqtytrd+sqtydel) As Netpurchsell,        
  SUM(prate) / (CASE WHEN SUM(pqtytrd + pqtydel) > 0 THEN SUM(pqtytrd + pqtydel) ELSE 1 END) As PRate,           
  SUM(srate) / (CASE WHEN SUM(sqtytrd + sqtydel) > 0 THEN SUM(sqtytrd + sqtydel) ELSE 1 END) As SRate,           
  Addrline1=l_address1,            
  Addrline2=l_address2,            
  Addrline3=l_address3,            
  Addrcity=l_city,            
  Addrstate=l_state,            
  Addrzip=l_zip,        
  C1.Res_Phone1,         
  C1.Off_Phone1,        
  ContactPerson=IsNull(uc.Contract_Person,''),        
  Director=IsNull(C5.director_name,''),        
  CommencementDate=Convert(varchar,C5.ActiveFrom,103),        
  DPID=IsNull(C4.CltDpID,''),        
  DPNAME=IsNull(b.bankname,''),        
  ClinetDPID=IsNull(CL4.CltDpID,''),        
  Introducer = isnull(Introducer,''),
  IntroRelationship = isnull(Introd_Relation,''),
  SABINO = FD_CODE,
  SubBrokerCode = C.sub_broker,
  SubBrokerName=sb.Name,
  BrokerAddr1 = sb.Address1,
  BrokerAddr2 = sb.Address2,
  BrokerCity = sb.City,
  BrokerState = sb.State,
  BrokerZip = sb.Zip        
 From            
  OWNER, Cmbillvalan C, Client1 C1  LEFT OUTER JOIN ucc_client uc on (C1.Cl_Code = uc.Party_Code)        
  LEFT OUTER JOIN Client4 C4 on (C1.cl_code = C4.cl_code And C4.Depository in ('NSDL','CDSL') And  C4.DefDp=1)        
  LEFT OUTER JOIN Client4 CL4 on (C1.cl_code = CL4.cl_code And CL4.Depository Not in ('NSDL','CDSL'))        
  LEFT OUTER JOIN bank b on b.BankID = C4.BankID,        
  Client2 C2 LEFT OUTER JOIN Client5 C5 ON C2.cl_code = C5.cl_code
, subbrokers sb         
           
 Where            
  C1.cl_code = C2.cl_code And            
  C.party_code = C2.party_code And            
  Sauda_date >= @datefrom + ' 00:00:00' And            
  Sauda_date <= @dateto + ' 23:59:59' And            
  C.sett_no Between @settnofrom And @settnoto And            
  C.scrip_cd Between @scripfrom And @scripto And            
  C.party_code Between @partyfrom And @partyto And            
  Tradetype Not Like '%f'
  and C.Sub_Broker = sb.Sub_Broker
 Group By            
  Convert(varchar,C.Sauda_date,103),          
  C.sett_no,            
  C.scrip_cd,            
  C.series,            
  C.party_code,            
  C.party_name,            
  L_address1,            
  L_address2,            
  L_address3,            
  L_city,            
  L_state,            
  L_zip,            
  C1.Res_Phone1,         
  C1.Off_Phone1,        
  IsNull(uc.Contract_Person,''),        
  IsNUll(C5.director_name,''),        
  Convert(varchar,C5.ActiveFrom,103),        
  isNull(C4.CltDpID,''),        
  isNull(CL4.CltDpID,''),        
  isNull(b.bankname,''),        
  C4.Depository,         
  C4.DefDp,
  Company,
  membercode,
  Introd_Relation,
  Introducer,
  FD_CODE,
  C.sub_broker,
  Sb.Name,
sb.Address1,
sb.Address2,
sb.City,
sb.State,
sb.Zip    
 Order By            
           
  C.party_code,            
  C.party_name,            
  C.sett_no,       
  C.scrip_cd,            
  C.series

GO
