-- Object: PROCEDURE dbo.Usp_Ekyc_BulkReactivateUserCodes_Mimansa
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

















-- =============================================
-- Author:		Yogesh Patil
-- Create date: Dec 16 2021

-- =============================================
CREATE PROCEDURE [dbo].[Usp_Ekyc_BulkReactivateUserCodes_Mimansa]

AS
BEGIN
	

 Declare @ProcessID nvarchar(200)
		Declare @ErrorFlag nvarchar(max)
		Declare @Empid  varchar(40)
		declare @tableHTML varchar(max)                         
        declare @Subject varchar(200)   

	
BEGIN TRY	
	
		Declare @@Flag cursor

	Set @@Flag = CURSOR FOR  

	select top 1 ProcessID ,Emp_code from mimansa.CRM.dbo.tbl_Ekyc_RctivateUserCode_process with(nolock) where
ProcessingStatus='P' and RequestReceivedOn>=convert(varchar(11),getdate(),109) order by  RequestReceivedOn asc

--select top 1 @ProcessID=ProcessID ,@Empid=Emp_code from mimansa.CRM.dbo.tbl_Ekyc_RctivateUserCode_process with(nolock) where
--ProcessingStatus='P' order by  RequestReceivedOn desc --ProcessID desc

--Print @ProcessID
Open @@Flag  
		FETCH NEXT FROM @@Flag INTO @ProcessID,@Empid
	WHILE @@FETCH_STATUS = 0                        
		BEGIN  
if exists (select 1 from mimansa.CRM.dbo.EkycReActivate_BCK with(nolock) where ProcessID=@ProcessID)
Begin

    update mimansa.CRM.dbo.tbl_Ekyc_RctivateUserCode_process set ProcessingStatus='W' where  ProcessID=@ProcessID;

	Select distinct party_Code,Exchange,Segment,entryBy as 'updatedby','P' as ProcessStatus
	Into #tempReactiveInfo
	from mimansa.CRM.dbo.EkycReActivate_BCK
	where ProcessID=@ProcessID;


	create clustered index idx_party_Code on #tempReactiveInfo (party_Code)

	Update  t
	set t.ProcessStatus='F'
	from  #tempReactiveInfo t,msajag.dbo.client_brok_details c with(nolock)
	where t.party_Code=c.cl_code and t.Exchange=c.Exchange and t.Segment=c.Segment
	and (c.InActive_From > getdate() or isnull(c.Deactive_value,'') in ('C','T'))



	--backup
		Insert into msajag.dbo.client_brok_details_log(Cl_Code,Exchange,Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit,InActive_From,Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,Market_Type,Multiplier,Charged,Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett,TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,Del_Stt,Del_Tran_Chrgs,Del_SEBI_Fees,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,Rounding_Method,Round_To_Digit,Round_To_Paise,Fut_Brok,Fut_Opt_Brok,Fut_Fut_Fin_Brok,Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty, Fut_Other_Chrgs,Status,Modifiedon,Modifiedby,Imp_Status,Pay_B3B_Payment,Pay_Bank_name,Pay_Branch_name,Pay_AC_No,Pay_payment_Mode,Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,Edit_By,Edit_on,SYSTEMDATE,Active_Date,CheckActiveClient,Deactive_Remarks,Deactive_value)
		Select Cl_Code,c.Exchange,c.Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit, 
        InActive_From,Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,
       Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,Market_Type,Multiplier,Charged,Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett, TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,Del_Stt,               Del_Tran_Chrgs,Del_SEBI_Fees,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,              Rounding_Method,Round_To_Digit,Round_To_Paise,Fut_Brok,Fut_Opt_Brok,Fut_Fut_Fin_Brok, Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty, Fut_Other_Chrgs,Status,Modifiedon,Modifiedby,Imp_Status,Pay_B3B_Payment,Pay_Bank_name, Pay_Branch_name,Pay_AC_No,Pay_payment_Mode,Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,'E36024',GETDATE(),SYSTEMDATE,Active_Date,CheckActiveClient,Deactive_Remarks,Deactive_value
       From msajag.dbo.client_brok_details c with(nolock) ,#tempReactiveInfo t
       where c.cl_code=rtrim(ltrim(t.party_Code)) and c.Exchange =t.Exchange and c.Segment=t.Segment and c.InActive_From < GETDATE() and isnull(c.Deactive_value,'') not in ('C','T') and t.ProcessStatus='P'

    --update
	if @@ROWCOUNT > 0
	begin

	Declare @log Table ( Cl_code varchar(100))

	update c
	set Modifiedon =getdate() ,
	Modifiedby=t.updatedby ,
	 Deactive_Remarks='',
     InActive_From='2049-12-31 23:59:00.000',
     Deactive_value='R',
     Imp_Status=0 
	  OUTPUT inserted.Cl_code
    INTO @log 
	 From msajag.dbo.client_brok_details c with(nolock) ,#tempReactiveInfo t 
	 
	 where rtrim(ltrim(c.cl_code))=rtrim(ltrim(t.party_Code ))
	 and c.Exchange =t.Exchange 
	 and c.Segment=t.Segment 
	 and c.InActive_From <= GETDATE() 
	 and isnull(c.Deactive_value,'') not in ('C','T') 
	 and t.ProcessStatus='P'

	insert  into msajag.dbo.Dormant_Reactivation(cl_code,process_Date)
	select  distinct cl_code, getdate()from @log

	--set complete

	 update mimansa.CRM.dbo.tbl_Ekyc_RctivateUserCode_process set ProcessingStatus='C',mailType='Success',isMailSend='Y',EmailSentOn=getdate() where  ProcessID=@ProcessID
	
	




	print 'befor mail'

	set @Subject = 'Auto Reactivation confirmation Mailer'               
 
    SET @tableHTML =' <style type="text/css">
                        /* <![CDATA[ */
 
                    
 
                        table
                        {
                                border-width: 0 0 1px 1px;
                                border-spacing: 0;
                                border-collapse: collapse;
                        }
 
                        td
                        {
                                margin: 0;
                                padding-left: 7px;
                                padding-right: 7px;
                                padding-top: 4px;
                                padding-bottom: 4px;
                                border-width: 1px 1px 0 0;
                          
                        }
 
                        /* ]]> */
                        </style>
                    
 
                        <table  style="font-family: verdana;font-size: 12px;">
 
                                <tr><td>Dear Team, </td></tr>
                                <tr><td>&nbsp;</td></tr>
                                <tr>
                                        <td style="padding-left: 50px;">
                                            Auto Reactivation confirmation Mailer.('+@ProcessID+')
                                        </td>
                                </tr>
                                <tr><td>&nbsp;</td></tr>
                                <tr>
                                        <td style="padding-top:10px;padding-left:50px;">
                                            <table border="1" style="font-family:Verdana;font-size:12px;background-color:#EFF5FB;">                       
                                            <tr style="font-weight: bold;text-align:left;border-top:1px solid #808080;" bgcolor="#cccccc">
                                                    <td align="left"><b>Party Code</b></td>
                                                    <td align="left"><b>Segment</b></td>
                                                    <td align="left"><b>Exchange</b></td>
                                                    <td align="left"><b>Status</b></td>                                                                                                  
                                            </tr>'
                                            +
                                            CAST ( (     
                                            select td = party_Code,
                                            '',td=segment,
                                            '',td=Exchange,
                                            '',td=case when ProcessStatus = 'P' then 'Success' else 'Failed' End
                                            from #tempReactiveInfo with(nolock)
                                        
                                            FOR XML PATH('tr'), TYPE ) AS NVARCHAR(MAX) )
                                            +                                              
                                            N'
                                        </table>
                                        </td>
                                </tr>
								<tr><td>&nbsp;</td></tr>
 
                                <tr>
                                        <td><p>Regards,</p>
                                            <p>Mimansa Team</p>
                                        </td>
                                </tr>
								

'

	exec msdb.dbo.sp_send_dbmail   
   @recipients = 'syed.hashmi@angelbroking.com;yogesh.mpatil@angelbroking.com;Praveen.srivastava@angelbroking.com;deepak.redekar@angelbroking.com;sunny.1siddula@angelbroking.com',
   --@recipients = 'Priyanka.Shrikant@angelbroking.com;',
    @body_format='HTML',                            
    @subject = @Subject,                            
    @body = @tableHTML,                           
    @profile_name ='MimansaTeam'

 End
 drop table #tempReactiveInfo;
End
Else
BEGIN
	Print 'No Records'

	   update mimansa.CRM.dbo.tbl_Ekyc_RctivateUserCode_process set ProcessingStatus='C',mailType='NORECORDS',isMailSend='Y',EmailSentOn=getdate() where  ProcessID=@ProcessID
 

END

set @ProcessID='';

FETCH NEXT FROM @@Flag INTO @ProcessID,@Empid
end
	CLOSE @@Flag  	
END TRY
BEGIN CATCH
	print 'catch'
   update mimansa.CRM.dbo.tbl_Ekyc_RctivateUserCode_process set ProcessingStatus='F',mailType='Fail',isMailSend='Y',EmailSentOn=getdate() where  ProcessID=@ProcessID

    SELECT @ErrorFlag=ERROR_MESSAGE()

	Print @ErrorFlag
    
      set @Subject = 'Auto Reactivation Process Failed'
	  SET @tableHTML =''+cast(@ErrorFlag as varchar(8000))+''
	  exec msdb.dbo.sp_send_dbmail   
      @recipients = 'yogesh.mpatil@angelbroking.com',
      @body_format='HTML',                            
      @subject = @Subject,                            
      @body = @tableHTML,                           
      @profile_name ='MimansaTeam'

	

END CATCH;
END

GO
