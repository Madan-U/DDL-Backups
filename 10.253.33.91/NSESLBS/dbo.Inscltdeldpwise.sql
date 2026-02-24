-- Object: PROCEDURE dbo.Inscltdeldpwise
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc InsCltDelDpWise ( @Sett_no Varchar(7),@Sett_Type Varchar(2),@RefNo int) as          
         
Declare @@Scrip_Cd Varchar(12),          
 @@Series Varchar(3),          
 @@Party_code Varchar(10),          
 @@DelQty int,          
 @@Qty Int,          
 @@TradeQty int,          
 @@CertNo Varchar(15),          
 @@FromNo Varchar(15),          
 @@FolioNo Varchar(15),          
 @@Reason Varchar(25),          
 @@TCode Numeric(18,0),          
 @@CertParty Varchar(10),          
 @@OrgQty int,          
 @@SDate Varchar(11),          
 @@SNo Numeric(18,0),          
 @@Flag varchar(1),          
 @@PCount Int,          
 @@RemQty Int,          
 @@OldQty Int          
        
Set NoCount On          
         
If @Sett_Type <> 'W'          
Begin          
          
 Truncate Table DelInterPO           
 Insert Into DelInterPO           
 Select * From InsDelInterSett Where Psettno = @Sett_No and Psetttype = @Sett_Type          
          
Declare DelClt_Cursor Cursor for          
 select Dt.scrip_cd,Dt.series,Dt.Party_code,Qty,Flag='P' from DeliveryClt Dt where inout = 'O'          
 and sett_no = @Sett_No and Sett_Type = @Sett_Type And Party_Code = (Select AuctionParty From DelSegment )          
 and DT.scrip_cd not in (Select Distinct Scrip_Cd From DematTransOut T  
 Where T.Sett_No = @Sett_no And T.Sett_Type = @Sett_Type  
 And T.Scrip_Cd = DT.Scrip_Cd And T.Series = DT.Series  
 And T.TrType = 906)  
 Union All          
 SELECT I.scrip_cd,I.series,I.Party_code,CQty,Flag='R'          
 FROM Client1 C1, Client2 C2, DelInterPO  I Left Outer Join DelTrans D          
 On ( I.PSettNo = D.Sett_No And I.PSettType = D.Sett_Type   
      And I.Scrip_Cd = D.Scrip_Cd And I.SERIES = D.SERIES  
      And I.Party_Code = D.Party_Code          
      And D.Filler2 = 1 And D.DrCr = 'D' )          
 where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = I.Party_Code And          
 Psettno = @Sett_No and Psetttype = @Sett_Type And           
 I.Party_Code Not in ( Select Party_code From DelPartyFlag Where InterFlag = 1 )    
 and I.scrip_cd not in (Select Distinct Scrip_Cd From DematTransOut T  
 Where T.Sett_No = @Sett_no And T.Sett_Type = @Sett_Type  
 And T.Scrip_Cd = I.Scrip_Cd And T.Series = I.Series  
 And T.TrType = 906)         
 Group By SEC_PAYIN,I.PARTY_CODE,Long_Name,I.SCRIP_CD,I.Series,I.BSECODE,I.sett_no,I.sett_type,DQty,Exchg,CQty          
 Having CQty > Sum(IsNull(D.Qty,0)) And DQty > Sum(IsNull(D.Qty,0))          
 ORDER BY Flag, 1, 2, 4          
end          
else          
begin          
Declare DelClt_Cursor Cursor for          
 select Scrip_CD,Series,Party_Code,Qty=Sum(Qty),Flag='R' From InsNseDelView   DT      
 where sett_no = @Sett_no and Sett_Type = @Sett_Type    
 and DT.scrip_cd not in (Select Distinct Scrip_Cd From DematTransOut T  
 Where T.Sett_No = @Sett_no And T.Sett_Type = @Sett_Type  
 And T.Scrip_Cd = DT.Scrip_Cd And T.Series = DT.Series  
 And T.TrType = 906)         
 Group By Scrip_CD,Series,Party_Code  
 ORDER BY Flag, 1, 2, 4        
end          
Open DelClt_Cursor          
Fetch Next From DelClt_Cursor Into @@scrip_cd,@@series,@@party_code,@@delqty,@@flag          
While @@fetch_status = 0           
Begin          
       Declare Quantity_Cursor Cursor for          
       Select Isnull(Sum(Qty),0) From DelTrans With(Index(DelHold))          
       Where Sett_no = @sett_no           
       And Sett_type = @sett_type           
       And Party_code = @@party_code          
       And Scrip_cd  = @@scrip_cd           
       And Series = @@series           
       And Drcr = 'D' And Filler2 = 1           
       Open Quantity_Cursor           
       Fetch Next From Quantity_Cursor Into @@qty             
       If @@delqty > @@qty          
       Begin            
     Select @@delqty = @@delqty - @@qty          
     Declare Cert_Cursor Cursor For          
     Select Qty,Certno, Fromno,Foliono,Tdate=left(Convert(Varchar,Transdate,109),11),Orgqty,Sno,Tcode          
        From DelTrans With(Index(DelHold))          
     Where Sett_no = @sett_no           
     And Sett_type = @sett_type           
     And Party_code = 'Broker'          
     And Scrip_cd  = @@scrip_cd           
     And Series = @@series           
     And Drcr = 'D'  And Trtype <> 1000  And Filler2 = 1              
     Order By Transdate Asc,Qty Desc           
      Open Cert_Cursor          
      Fetch Next From Cert_Cursor Into @@tradeqty,@@certno,@@fromno,@@foliono,@@sdate,@@orgqty,@@sno,@@tcode          
      If @@fetch_status = 0           
      Begin          
       Select @@pcount = 0          
       While @@pcount < @@delqty And @@fetch_status = 0           
       Begin          
        Select @@pcount = @@pcount + @@tradeqty          
        If @@pcount <= @@delqty           
        Begin              
          Update DelTrans   Set Party_code = @@party_code, Reason=@@flag,          
               Dpid = '', Cltdpid = '', Trtype = 904           
--               From DelTrans WITH (ROWLOCK)          
          Where Sno = @@sno           
        End              
       Else            
       Begin          
              Select @@pcount = @@pcount - @@tradeqty          
              Select @@remqty = @@delqty - @@pcount          
             Select @@oldqty = @@tradeqty - @@remqty          
            Select @@pcount = @@pcount + @@remqty            
          
          Update DelTrans   Set Party_code = @@party_code, Reason=@@flag,          
               Dpid = '', Cltdpid = '', Trtype = 904, Qty = @@remqty          
--               From DelTrans WITH (ROWLOCK)          
          Where Sno = @@sno           
          
          Insert Into DelTrans (Sett_no,Sett_type,Refno,Tcode,Trtype,Party_code,Scrip_cd,Series,Qty,Fromno,Tono,Certno,Foliono,          
               Holdername,Reason,Drcr,Delivered,Orgqty,Dptype,Dpid,Cltdpid,Branchcd,Partipantcode,Slipno,Batchno,Isett_no,Isett_type,Sharetype,Transdate,Filler1,Filler2,Filler3,Bdptype,Bdpid,Bcltdpid,Filler4,Filler5)          
          Select Sett_no,Sett_type,Refno,Tcode,Trtype,'BROKER',Scrip_cd,Series,Qty=@@oldqty,Fromno,Tono,Certno,Foliono,          
          Holdername,'DEMAT','D',Delivered,Orgqty,Dptype,Dpid,Cltdpid,Branchcd,Partipantcode,Slipno,Batchno,Isett_no,Isett_type,Sharetype,Transdate,Filler1,1,Filler3,Bdptype,Bdpid,Bcltdpid,Filler4,Filler5    
               From DelTrans          
          Where Sno = @@sno           
          
    End          
    Fetch Next From Cert_Cursor Into @@tradeqty,@@certno,@@fromno,@@foliono,@@sdate,@@orgqty,@@sno,@@tcode          
     End          
   End          
     Close Cert_Cursor          
     Deallocate Cert_Cursor           
   End          
   Close Quantity_Cursor          
   Deallocate Quantity_Cursor          
   Fetch Next From DelClt_Cursor Into @@scrip_cd,@@series,@@party_code,@@delqty,@@flag          
End          
Close DelClt_Cursor          
Deallocate DelClt_Cursor          
          
Update DelTrans Set  Dptype = C.Depository,Dpid = C.Bankid, Cltdpid = C.Cltdpid From Client4 C   
Where C.Party_code  =  DelTrans.Party_code          
And Sett_no = @sett_no And Sett_type = @sett_type   
And Defdp =1 And Dpid = '' And Filler2 = 1 And Drcr = 'D'          
And Delivered = '0' And Trtype = 904   
And C.Cltdpid <> '' And Bankid <> ''   
And C.Depository In ('Cdsl','Nsdl')

GO
