-- Object: PROCEDURE dbo.Rpt_grossexposurenew
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure Rpt_grossexposurenew        
@fromparty Varchar(10),        
@toparty Varchar(10),        
@fromdate Varchar(11),        
@todate Varchar(11),        
@settlementtype Varchar(3),        
@branch_cd Varchar(10),        
@sub_broker Varchar(10)        
As        
Declare        
@@fromsettlementno Varchar (12),        
@@tosettlementno Varchar (12),        
@@sauda_date Varchar(12),        
@@settlementtype Varchar(3),        
@@fromsettno Varchar(13),        
@@tosettno Varchar(13),        
@@settype Varchar(3),        
@@settypeani Varchar(3),        
@@fromdate Varchar(11),        
@@dummyfromdate Varchar(11),        
@@scripcd Varchar (12),        
@@buyvalue Money,        
@@sellvalue Money,        
@@branchid Varchar (12),        
@@series Varchar(2),        
@@dummyseries Varchar(2),        
@@dummyscrip Varchar (12),        
@@dummybranchid Varchar(12),        
@@netvalue Money,        
@@rate Money,        
@@varmargin Money,        
@@gross Money,        
@@totnetval Money,        
@@newsellvalue Money,        
@@newbuyvalue Money,        
@@resvarmargin Money,        
@@totvarmargin Money,        
@@restotvarmargin Money,        
@@grosstot Money,        
@@resgrosstot Money         
         
Truncate Table Tblgrossexp         
Insert Into Tblgrossexp         
Select Sm.sett_type ,sm.sett_no,s.sauda_date,s.branch_id,        
Buyqty=(case When Sell_buy = 1 Then  Tradeqty Else 0 End ) ,         
Buyval=(case When Sell_buy = 1 Then  Tradeqty * Marketrate Else 0 End ) ,         
Sellqty=(case When Sell_buy = 2 Then  Tradeqty Else 0 End ) ,         
Sellval=(case When Sell_buy = 2 Then  Tradeqty * Marketrate Else 0 End ) ,         
Scrip_cd,s.party_code,s.series, Trade_no,rate=0,family,branch_cd=ltrim(branch_cd),sub_broker        
From Settlement S, Client2 C2, Client1 C1, Sett_mst Sm         
Where Tradeqty > 0         
And C1.cl_code = C2.cl_code And C2.party_code = S.party_code         
And Sec_payin > @fromdate        
And Start_date <= @fromdate And Sm.sett_type = S.sett_type        
And Sm.sett_no = S.sett_no        
And Sm.sett_type = @settlementtype And S.party_code >= @fromparty And S.party_code <= @toparty        
        
 Select @@settlementtype = @settlementtype        
 Truncate Table Tempgrossexp        
 Truncate Table Grpexpdate        
 Insert Into Grpexpdate        
 Select Distinct  Start_date = Left(convert(varchar,sauda_date,109),11) From Tblgrossexp        
        
 Declare Getsaudadate Cursor For          
  Select Distinct  Start_date From Grpexpdate        
 Open Getsaudadate        
 Fetch Next From Getsaudadate Into @@sauda_date        
 While @@fetch_status = 0         
 Begin         
  Select @@settlementtype = @settlementtype        
  Declare Opensettno Scroll Cursor For         
   Select Sett_no From Sett_mst         
   Where Sec_payin > @@sauda_date And Start_date <= @@sauda_date        
   And Sett_type = @@settlementtype        
   Group By Sett_type , Start_date, Sett_no , Left(convert(varchar,sec_payin,109),11)         
   Order By Sett_type,sett_no         
  Open Opensettno        
  If @@settlementtype = 'n'        
  Begin        
   Fetch Absolute 2 From Opensettno Into @@fromsettlementno        
   Fetch Last From Opensettno Into @@tosettlementno         
   Insert Into Tempgrossexp Values(@@fromsettlementno,@@tosettlementno,@@settlementtype,@@sauda_date,0,0)        
  End          
  Else        
  If @@settlementtype = 'w'        
  Begin        
   Fetch Next From Opensettno Into @@fromsettlementno        
   Fetch Last From Opensettno Into @@tosettlementno         
   Insert Into Tempgrossexp Values(@@fromsettlementno,@@tosettlementno,@@settlementtype,@@sauda_date,0,0)        
  End         
  Close Opensettno        
  Deallocate Opensettno        
  If @@settlementtype = '%'        
  Begin        
   Select @@settlementtype = 'n'        
   Declare Opensettno1 Scroll Cursor For         
    Select Sett_no From Sett_mst         
    Where Sec_payin > @@sauda_date And Start_date <= @@sauda_date        
    And Sett_type = @@settlementtype         
  Group By Sett_type , Start_date, Sett_no , Left(convert(varchar,sec_payin,109),11)         
    Order By Sett_type,sett_no         
   Open Opensettno1        
   If @@settlementtype = 'n'        
   Begin        
    Fetch Absolute 2 From Opensettno1 Into @@fromsettlementno        
    Fetch Last From Opensettno1 Into @@tosettlementno         
    Insert Into Tempgrossexp Values(@@fromsettlementno,@@tosettlementno,@@settlementtype,@@sauda_date,0,0)        
   End         
   Close Opensettno1        
   Deallocate Opensettno1        
        
   Select @@settlementtype = 'w'        
   Declare Opensettno2 Scroll Cursor For         
    Select Sett_no From Sett_mst         
    Where Sec_payin > @@sauda_date And Start_date <= @@sauda_date        
    And Sett_type = @@settlementtype         
        
    Group By Sett_type , Start_date, Sett_no , Left(convert(varchar,sec_payin,109),11)         
    Order By Sett_type,sett_no          
    Open Opensettno2        
   If @@settlementtype = 'w'        
   Begin        
    Fetch Next From Opensettno2 Into @@fromsettlementno        
    Fetch Last From Opensettno2 Into @@tosettlementno         
    Insert Into Tempgrossexp Values(@@fromsettlementno,@@tosettlementno,@@settlementtype,@@sauda_date,0,0)        
   End         
   Close Opensettno2        
   Deallocate Opensettno2        
  End /* End Of All*/        
 Fetch Next From Getsaudadate Into @@sauda_date        
 End /*end Of Fetch Status*/        
 Close Getsaudadate        
 Deallocate Getsaudadate        
 Truncate Table Tblgrossexpnew        
 Insert Into Tblgrossexpnew        
 Select S.scrip_cd,        
 BuyQty = Isnull(sum(buyQty),0),        
 Buyvalue = Isnull(sum(buyval),0),        
 SellQty = Isnull(sum(sellQty),0),      
 Sellvalue = Isnull(sum(sellval),0),        
 S.branch_id,s.series,fromsettno,tosettno,t.sett_type,saudadate,varmargin,grossexp,rate=0.00,party_code,family,branch_cd,sub_broker,0        
 From Tempgrossexp T, Tblgrossexp S        
 Where S.family >= @fromparty And S.family <= @toparty        
 And S.sett_no >= T.fromsettno And S.sett_no <= T.tosettno        
 And S.sauda_date Like Left(convert(varchar,saudadate,109),11) + '%'        
 And S.sett_type = T.sett_type And Branch_cd Like @branch_cd And Sub_broker Like @sub_broker         
 Group By S.scrip_cd ,s.sett_type , S.series, S.branch_id,fromsettno,tosettno,t.sett_type,saudadate,varmargin,grossexp,party_code,family,branch_cd,sub_broker        
        
 Insert Into Tblgrossexpnew        
 Select  S.scrip_cd,        
 BuyQty = Isnull(sum(buyQty),0),        
 Buyvalue = Isnull(sum(buyval),0),        
 SellQty = Isnull(sum(sellQty),0),      
 Sellvalue = Isnull(sum(sellval),0),        
 S.branch_id,s.series,fromsettno,tosettno,t.sett_type,saudadate,varmargin,grossexp,rate=0.00,party_code,family,branch_cd,sub_broker,0        
 From Sett_mst St, Tempgrossexp T, Tblgrossexp S Where Sec_payin > T.saudadate        
 And Sauda_date <= Left(convert(varchar,t.saudadate,109),11) + ' 23:59:59'        
 And St.sett_no=s.sett_no And St.sett_type=s.sett_type        
 And S.family >= @fromparty And  S.family <= @toparty And        
 S.sett_no >= T.fromsettno And S.sett_no < = T.tosettno        
 And S.sauda_date Like Left(convert(varchar,saudadate,109),11) + '%'        
 And St.sett_type = T.sett_type And Branch_cd Like @branch_cd And Sub_broker Like @sub_broker And         
 S.sett_no = (select Distinct Settled_in From Nodel N Where N.scrip_cd=s.scrip_cd And N.series=s.series And N.sett_type=s.sett_type And S.sett_no=n.settled_in )        
 Group By S.scrip_cd ,s.sett_type , S.series, S.branch_id,fromsettno,tosettno,t.sett_type,saudadate,varmargin,grossexp,party_code,family,branch_cd,sub_broker        
        
 Update Tblgrossexpnew Set Rate = Isnull(varmarginrate,0)  From Vardetail V, Varcontrol C         
 Where V.scrip_cd = Tblgrossexpnew.scrip_cd And V.series = Tblgrossexpnew.series And V.detailkey = C.detailkey         
 And Recdate Like Left(convert(varchar,saudadate,109),11) + '%'        
    
 Update Tblgrossexpnew Set Rate = Isnull(varmarginrate,0)  From Vardetail V, Varcontrol C         
 Where V.scrip_cd = Tblgrossexpnew.scrip_cd And V.detailkey = C.detailkey         
 And Recdate Like Left(convert(varchar,saudadate,109),11) + '%' And V.Series = 'EQ'    
 And Rate = 0    
        
 Update Tblgrossexpnew Set Grossexp = (case When Sett_type = 'N' Then Abs(buyvalue-sellvalue) Else Abs(buyvalue+sellvalue) End )         
        
 Update Tblgrossexpnew Set Varmargin = Abs(grossexp*rate/100)        
      
 Update Tblgrossexpnew Set Cl_Rate = C.Cl_Rate      
 From Closing C Where C.SysDate Like @fromdate + '%'      
 And C.Scrip_Cd = Tblgrossexpnew.Scrip_Cd      
 And C.Series = Tblgrossexpnew.Series      
       
Delete From Tblgrossexpnewdetail Where Rundate Like @fromdate + '%'          
And Party_code Between @fromparty And @toparty And Sett_type = @settlementtype        
      
Insert Into Tblgrossexpnewdetail         
Select *,@fromdate From Tblgrossexpnew

GO
