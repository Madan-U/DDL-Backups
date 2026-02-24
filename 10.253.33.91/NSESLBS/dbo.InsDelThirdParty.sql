-- Object: PROCEDURE dbo.InsDelThirdParty
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.InsDelThirdParty    Script Date: 12/16/2003 2:31:19 PM ******/  
  
  
CREATE Proc InsDelThirdParty (  
 @User_Name  Varchar(25),  
 @DpId   Varchar(16),   
 @CltDpId  Varchar(16),   
 @Party_Code  Varchar(10),  
 @Sett_No Varchar(7),  
 @Sett_Type     Varchar(2),  
 @IsIn   Varchar(12),  
 @Qty   Int,  
 @TransNo Varchar(10),  
 @TrDate Varchar(11),    
 @ProcessFlag  Varchar(15),  
 @OldParty_Code Varchar(10),  
 @SNo   Numeric,  
 @TrType Int )  
As  
  
Declare   
 @Description Varchar(50)  
  
--Process Flag Value  
--Process Flag 'Marked'  
--Process Flag 'Cleared'  
--Process Flag 'UnCleared'  
--Process Flag 'ReCleared'  
--Process Flag 'UnClearedPost'  
--Process Flag 'ReClearedPost'  
  
Select @Description = ''  
Select @Description = Description From DeliveryDp Where DpId = @DpId And DpCltNo = @CltDpId  
  
If @ProcessFlag = 'Marked'  
Begin  
 if @OldParty_Code = 'Party' And @TrType <> 907 And @Description = ''  
 Begin   
  Insert Into DelThirdPartyCltId  
  Select Sett_No,Sett_Type,@Party_Code,Scrip_Cd,Series,IsIn,Qty,DpType,DpId,CltDpId=CltAccNo,  
  TransNo,TransDate=TrDate,0,@User_Name,GetDate(),0,'','',0,'','',0,'','',0,'','',0,'','' From DematTrans  
  WHERE DpId = @DpId And CltAccNo = @CltDpId And DpId <> '' And Party_Code = @OldParty_Code And Sno = @Sno
    
  Update DematTrans Set Party_Code = @Party_Code  
  WHERE DpId = @DpId And CltAccNo = @CltDpId And Party_Code = @OldParty_Code And Sno = @Sno
 End   
 Else  
 Begin  
  If @TrType <> 907 And @Description = ''  
  Begin  
   Insert Into DelThirdPartyCltId  
   Select Sett_No,Sett_Type,@Party_Code,Scrip_Cd,Series,IsIn,Qty,DpType,DpId,CltDpId=CltAccNo,  
   TransNo,TransDate=TrDate,0,@User_Name,GetDate(),0,'','',0,'','',0,'','',0,'','',0,'','' From DematTrans  
   WHERE DpId = @DpId And CltAccNo = @CltDpId And DpId <> '' And Party_Code = @OldParty_Code  
   And Sno = @Sno And @OldParty_Code <> @Party_Code  
  End  
  Update DematTrans Set Party_Code = @Party_Code  
  WHERE DpId = @DpId And CltAccNo = @CltDpId And Party_Code = @OldParty_Code   
  And Sno = @Sno And @OldParty_Code <> @Party_Code  
 End  
End  
If @ProcessFlag = 'Cleared'  
Begin  
 Update DelThirdPartyCltId Set   
 Cleared = 1,   
 ClearedBy = @User_Name,  
 ClearedOn = GetDate()  
 WHERE DpId = @DpId And CltDpId = @CltDpId And Party_Code = @Party_Code  
 And Sett_no = @Sett_No And Sett_Type = @Sett_Type And IsIn = @IsIn   
        And Qty = @Qty And TransNo = @TransNo And TransDate Like @TrDate + '%'  
  
 If (Select IsNull(Count(*),0) From MultiCltId Where   
       DpId = @DpId And CltDpNo = @CltDpId And Party_Code = @Party_Code) <= 0   
 Begin   
  Insert Into MultiCltId   
  Select Distinct D.Party_Code,D.CltDpId,D.DpId,Long_Name,DpType,0 From Client2 C2, Client1 C1,   
  DelThirdPartyCltId D Where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code   
  And DpId = @DpId And CltDpId = @CltDpId And D.Party_Code = @Party_Code  
  And Sett_no = @Sett_No And Sett_Type = @Sett_Type And IsIn = @IsIn   
          And Qty = @Qty And TransNo = @TransNo And TransDate Like @TrDate + '%'  
 End  
End  
If @ProcessFlag = 'UnCleared'  
Begin  
 Update DelThirdPartyCltId Set   
 UnCleared = 1,   
 UnClearedBy = @User_Name,  
 UnClearedOn = GetDate()  
 WHERE DpId = @DpId And CltDpId = @CltDpId And Party_Code = @Party_Code   
 And Sett_no = @Sett_No And Sett_Type = @Sett_Type And IsIn = @IsIn   
         And Qty = @Qty And TransNo = @TransNo And TransDate Like @TrDate + '%'  
End  
If @ProcessFlag = 'ReCleared'  
Begin  
 Update DelThirdPartyCltId Set   
 ReCleared = 1,   
 ReClearedBy = @User_Name,  
 ReClearedOn = GetDate()  
 WHERE DpId = @DpId And CltDpId = @CltDpId And Party_Code = @Party_Code   
 And Sett_no = @Sett_No And Sett_Type = @Sett_Type And IsIn = @IsIn   
         And Qty = @Qty And TransNo = @TransNo And TransDate Like @TrDate + '%'  
End  
If @ProcessFlag = 'UnClearedPost'  
Begin  
 Update DelThirdPartyCltId Set   
 UnClearedPost = 1,   
 UnClearedPostBy = @User_Name,  
 UnClearedPostOn = GetDate()  
 WHERE Party_Code = @Party_Code   
 And UnCleared = 1 And UnClearedPost = 0   
End  
If @ProcessFlag = 'ReClearedPost'  
Begin  
 Update DelThirdPartyCltId Set   
 ReClearedPost = 1,    
 ReClearedPostBy = @User_Name,  
 ReClearedPostOn = GetDate()  
 WHERE Party_Code = @Party_Code   
 And UnCleared = 1 And UnClearedPost = 1 And ReCleared = 1 And ReClearedPost = 0    
End

GO
