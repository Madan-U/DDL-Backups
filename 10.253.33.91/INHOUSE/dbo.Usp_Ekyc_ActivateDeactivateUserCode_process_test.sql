-- Object: PROCEDURE dbo.Usp_Ekyc_ActivateDeactivateUserCode_process_test
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Usp_Ekyc_ActivateDeactivateUserCode_process_test]

AS
BEGIN
	

 Declare @ProcessID nvarchar(200)
		Declare @ErrorFlag nvarchar(max)
		Declare @Empid  varchar(40)
		declare @tableHTML varchar(max)                         
        declare @Subject varchar(200)   
        declare @MainPartycode varchar(200)   

	
BEGIN TRY	

	

select top 1 @ProcessID=ProcessID ,@Empid=Emp_code from mimansa.CRM.dbo.Ekyc_ActivateDeactivateUserCode_process with(nolock) where ProcessID='ps35bpxf0wza1jlehfnfyw0303032018_142352'

--'P' order by ProcessID desc

Print @ProcessID

if exists (select * from mimansa.CRM.dbo.EkycActivate_BCK with(nolock) where ProcessID=@ProcessID)
Begin

	
SELECT DISTINCT
       party_Code, Segment, Remark AS 'NewRemark', entryBy AS 'updatedby'
INTO #tempDeactiveInfo
FROM mimansa.CRM.dbo.EkycActivate_BCK
WHERE ProcessID = @ProcessID
      AND party_code NOT IN('A100085', 'A100675', 'A101580', 'A102237', 'A104530', 'A10536', 'A105360', 'A106168', 'A106514', 'A106730', 'A106748', 'A107803', 'A107892', 'A109036', 'A109792', 'A111181', 'A111950', 'A112331', 'A115381', 'A116149', 'A116786', 'A116900', 'A114925', 'A117674', 'A117809', 'A119982', 'A121341', 'a12414', 'A17329', 'A38026', 'A43040', 'A48320', 'A59629', 'A62282', 'A71906', 'A76778', 'A76813', 'A81221', 'A84328', 'A84566', 'A84987', 'A85641', 'A88643', 'A91358', 'A92499', 'A92809', 'A93026', 'A93142', 'A93363', 'A94696', 'A95512', 'A96241', 'A96395', 'A96882', 'AADU044', 'AAKV089', 'AAOA329', 'AAOA336', 'AATQ1008', 'AATQ1013', 'AAVP1004', 'AAYJ055', 'AAYJ067', 'ABRK002', 'ABRK095', 'AGE388', 'AGT012', 'AMAC1018', 'AMMC1002', 'AMMC1003', 'AMMC1004', 'AMTS010', 'AND2993', 'AND5172', 'AND5869', 'AND5915', 'ANEP002', 'ANEP070', 'APS237', 'ARCN093', 'ARRK003', 'ASA153', 'ASMS1004', 'ASMS1005', 'ASSO002', 'ASUA1022', 'B11675', 'B13947', 'B26715', 'B26756', 'B27921', 'B28480', 'B31716');--and party_Code='S189865'



	 print 'update Ekyc_ActivateDeactivateUserCode'       
    update mimansa.CRM.dbo.Ekyc_ActivateDeactivateUserCode_process set ProcessingStatus='W' where  ProcessID=@ProcessID

		Declare @party_Code varchar(20),
	@segment varchar(20),@NewRemark varchar(300),@updatedby varchar(300)
	Declare @Deactive_Remarks varchar(500),@InActive_Date varchar(500)

	DECLARE cur_Deactive CURSOR  FOR           
	select party_Code,segment,NewRemark,updatedby
	from #tempDeactiveInfo 

	OPEN cur_Deactive
		FETCH NEXT FROM cur_Deactive INTO @party_Code,@segment,@NewRemark,@updatedby
	      
		 WHILE @@FETCH_STATUS = 0          
		 BEGIN 

		 set @MainPartycode=@party_Code


		 if(@segment='EQUITY')
		 Begin
			Print 'Inside EQUITY ' +@party_Code+' '+@segment

			if exists(select * from msajag.dbo.client_brok_details where cl_code=@party_Code and Exchange in('BSE','NSE','NSX')) --,'MCD'
			Begin
				Print 'Record exists in BO ' +@party_Code+' '+@segment
				if exists(Select party_code from mimansa.CRM.dbo.vw_EKYC_AutoDeactivate_OpenPosition where party_code=@party_Code and seg in('FO','CURRENCY','CAPITAL') and 1=2)
				Begin

					Print 'Client is having Holding/Open Position: '+@party_Code+' '+@segment
					Insert into mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Logtest
					Select CAST(@party_Code as varchar(30)) as party_code,CAST(@segment as varchar(30)) as segment,'OPEN',GETDATE() as updatedOn,'N' as Processed,CAST(@ProcessID as varchar(300)) as ProcessID   

					Insert into mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log
					Select CAST(@party_Code as varchar(30)) as party_code,CAST(@segment as varchar(30)) as segment,'OPEN',GETDATE() as updatedOn,'N' as Processed 
				End
				else
				BEGIN					

					Set @Deactive_Remarks= (Select top 1 Deactive_Remarks from msajag.dbo.client_brok_details where cl_code=@party_Code and Exchange in('BSE','NSE'))
					Print  'Deactivate Remark: ' +@Deactive_Remarks

					Set @InActive_Date= (Select top 1 InActive_From from msajag.dbo.client_brok_details where cl_code=@party_Code and Exchange in('BSE','NSE'))
					Print  'InActive_From: ' +@InActive_Date


					if(isnull(@Deactive_Remarks,'')='' and convert(datetime,@InActive_Date)>getdate())
					BEGIN					
					 
					Print 'Deactivate Update in BO: '+@party_Code+' '+@segment

					--begin transaction 
					
					select 'hi'
					Insert into msajag.dbo.client_brok_details_log(Cl_Code,Exchange,Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit,InActive_From,Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,Market_Type,Multiplier,Charged,Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett,TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,Del_Stt,Del_Tran_Chrgs,Del_SEBI_Fees,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,Rounding_Method,Round_To_Digit,Round_To_Paise,Fut_Brok,Fut_Opt_Brok,Fut_Fut_Fin_Brok,Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty, Fut_Other_Chrgs,Status,Modifiedon,Modifiedby,Imp_Status,Pay_B3B_Payment,Pay_Bank_name,Pay_Branch_name,Pay_AC_No,Pay_payment_Mode,Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,Edit_By,Edit_on,SYSTEMDATE,Active_Date,CheckActiveClient,Deactive_Remarks,Deactive_value)
					Select Cl_Code,Exchange,Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit, 
	InActive_From,Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,Market_Type,Multiplier,Charged,Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett, TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,Del_Stt,               Del_Tran_Chrgs,Del_SEBI_Fees,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,              Rounding_Method,Round_To_Digit,Round_To_Paise,Fut_Brok,Fut_Opt_Brok,Fut_Fut_Fin_Brok, Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty, Fut_Other_Chrgs,Status,Modifiedon,Modifiedby,Imp_Status,Pay_B3B_Payment,Pay_Bank_name,                                      Pay_Branch_name,Pay_AC_No,Pay_payment_Mode,Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,'E36024',GETDATE(),SYSTEMDATE,Active_Date,CheckActiveClient,Deactive_Remarks,Deactive_value
					From msajag.dbo.client_brok_details with(nolock)
					where cl_code=@party_Code and Exchange in('BSE','NSE','NSX','BSX') -- ,'MCD'


					Update msajag.dbo.client_brok_details set Deactive_Remarks=@NewRemark, InActive_From=GETDATE(),
					Deactive_value='I',Imp_Status=0,Modifiedon=getdate(),Modifiedby=@updatedby where 
					cl_code=@party_Code and Exchange in('BSE','NSE','NSX','BSX') -- ,'MCD'

					Insert into mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Logtest
					Select CAST(@party_Code as varchar(30)) as party_code,CAST(@segment as varchar(30)) as segment,'DEACTIVATE',GETDATE() as updatedOn,'N' as Processed,CAST(@ProcessID as varchar(300)) as ProcessID   

					Insert into mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log
					Select CAST(@party_Code as varchar(30)) as party_code,CAST(@segment as varchar(30)) as segment,'DEACTIVATE',GETDATE() as updatedOn,'N' as Processed 
					

				--COMMIT transaction 
					
					END

					ELSE
					BEGIN

					Print 'Already Deactivated: '+@party_Code+' '+@segment

					--begin transaction 
					print '0'
					--Update msajag.dbo.client_brok_details set Deactive_Remarks=@Deactive_Remarks+'/'+@NewRemark,
					Update msajag.dbo.client_brok_details set Deactive_Remarks=case when len(@Deactive_Remarks)<99 then SUBSTRING(@Deactive_Remarks+'/'+ SUBSTRING(@newRemark,0,99-(len(@Deactive_Remarks)-1)),0,100) else @Deactive_Remarks end,
					Deactive_value='I',Imp_Status=0,Modifiedon=getdate(),Modifiedby=@updatedby where 
					cl_code=@party_Code and Exchange in('BSE','NSE','NSX','BSX')

					if(convert(datetime,@InActive_Date)>getdate())
					begin
						print '01'
						Update msajag.dbo.client_brok_details set InActive_From=GETDATE()
						where cl_code=@party_Code and Exchange in('BSE','NSE','NSX','BSX') -- ,'MCD'
					end
					print '1'
					Insert into mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Logtest
					Select CAST(@party_Code as varchar(30)) as party_code,CAST(@segment as varchar(30)) as segment,'ALREADY DEACTIVATE',GETDATE() as updatedOn,'N' as Processed,CAST(@ProcessID as varchar(300)) as ProcessID   
					print '2'
					Insert into mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log
					Select CAST(@party_Code as varchar(30)) as party_code,CAST(@segment as varchar(30)) as segment,'ALREADY DEACTIVATE',GETDATE() as updatedOn,'N' as Processed 
					
					--COMMIT transaction 

					END


				END

			End

		 End
		
		if(@segment='COMMODITY')
		 Begin
			Print 'Inside COMMODITY'

			if exists(select * from msajag.dbo.client_brok_details where cl_code=@party_Code and Exchange in('MCX','NCX'))
			Begin
				Print 'Record exists in BO ' +@party_Code+' '+@segment

				if exists(Select party_code from mimansa.CRM.dbo.vw_EKYC_AutoDeactivate_OpenPosition where party_code=@party_Code and seg = 'COMM'  and 1=2)
				Begin

					Print 'Client is having Holding/Open Position: '+@party_Code+' '+@segment

					Insert into mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Logtest
					Select CAST(@party_Code as varchar(30)) as party_code,CAST(@segment as varchar(30)) as segment,'OPEN',GETDATE() as updatedOn,'N' as Processed,CAST(@ProcessID as varchar(300)) as ProcessID   

					Insert into mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log
					Select CAST(@party_Code as varchar(30)) as party_code,CAST(@segment as varchar(30)) as segment,'OPEN',GETDATE() as updatedOn,'N' as Processed 
				End
				else
				BEGIN					

					Set @Deactive_Remarks=(Select top 1 Deactive_Remarks from msajag.dbo.client_brok_details where cl_code=@party_Code and Exchange in('MCX','NCX'))
					Print  'Deactivate Remark commodity: ' +@Deactive_Remarks

					Set @InActive_Date= (Select top 1 InActive_From from msajag.dbo.client_brok_details where cl_code=@party_Code and Exchange in('BSE','NSE'))
					Print  'InActive_From: ' +@InActive_Date


					if(isnull(@Deactive_Remarks,'')='' and convert(datetime,@InActive_Date)>getdate())
					BEGIN

					Print 'Deactivate Update in BO: '+@party_Code+' '+@segment

					--begin TRAN 

					Insert into msajag.dbo.client_brok_details_log(Cl_Code,Exchange,Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit,InActive_From,Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,Market_Type,Multiplier,Charged,Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett,TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,Del_Stt,Del_Tran_Chrgs,Del_SEBI_Fees,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,Rounding_Method,Round_To_Digit,Round_To_Paise,Fut_Brok,Fut_Opt_Brok,Fut_Fut_Fin_Brok,Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty, Fut_Other_Chrgs,Status,Modifiedon,Modifiedby,Imp_Status,Pay_B3B_Payment,Pay_Bank_name,Pay_Branch_name,Pay_AC_No,Pay_payment_Mode,Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,Edit_By,Edit_on,SYSTEMDATE,Active_Date,CheckActiveClient,Deactive_Remarks,Deactive_value)
					Select Cl_Code,Exchange,Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit, 
InActive_From,Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,
Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,Market_Type,Multiplier,Charged,Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett, TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,Del_Stt,               Del_Tran_Chrgs,Del_SEBI_Fees,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,              Rounding_Method,Round_To_Digit,Round_To_Paise,Fut_Brok,Fut_Opt_Brok,Fut_Fut_Fin_Brok, Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty, Fut_Other_Chrgs,Status,Modifiedon,Modifiedby,Imp_Status,Pay_B3B_Payment,Pay_Bank_name,                                      Pay_Branch_name,Pay_AC_No,Pay_payment_Mode,Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,'E36024',GETDATE(),SYSTEMDATE,Active_Date,CheckActiveClient,Deactive_Remarks,Deactive_value
From msajag.dbo.client_brok_details with(nolock)
where cl_code=@party_Code and Exchange in('MCX','NCX')


					Update msajag.dbo.client_brok_details set Deactive_Remarks=@NewRemark, InActive_From=GETDATE(),
					Deactive_value='I',Imp_Status=0,Modifiedon=getdate(),Modifiedby=@updatedby where 
					cl_code=@party_Code and Exchange in('MCX','NCX')

					
					
					Insert into mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Logtest
					Select CAST(@party_Code as varchar(30)) as party_code,CAST(@segment as varchar(30)) as segment,'DEACTIVATE',GETDATE() as updatedOn,'N' as Processed,CAST(@ProcessID as varchar(300)) as ProcessID 				


					Insert into mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log
					Select CAST(@party_Code as varchar(30)) as party_code,CAST(@segment as varchar(30)) as segment,'DEACTIVATE',GETDATE() as updatedOn,'N' as Processed 
	
					--COMMIT TRAN 

					END

					ELSE
					BEGIN

					Print 'Already Deactivated: '+@party_Code+' '+@segment
					--begin TRAN 

					--Update msajag.dbo.client_brok_details set Deactive_Remarks=@Deactive_Remarks+'/'+@NewRemark,
					Update msajag.dbo.client_brok_details set Deactive_Remarks=case when len(@Deactive_Remarks)<=99 then SUBSTRING(@Deactive_Remarks+'/'+ SUBSTRING(@newRemark,0,99-(len(@Deactive_Remarks)-1)),0,100) else @Deactive_Remarks end,
					Deactive_value='I',Imp_Status=0,Modifiedon=getdate(),Modifiedby=@updatedby where 
					cl_code=@party_Code and Exchange in('MCX','NCX')

					if(convert(datetime,@InActive_Date)>getdate())
					BEGIN
					Update msajag.dbo.client_brok_details set InActive_From=GETDATE()
					where cl_code=@party_Code and Exchange in('MCX','NCX')
					end
					
					Insert into mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Logtest
					Select CAST(@party_Code as varchar(30)) as party_code,CAST(@segment as varchar(30)) as segment,'ALREADY DEACTIVATE',GETDATE() as updatedOn,'N' as Processed,CAST(@ProcessID as varchar(300)) as ProcessID 

					Insert into mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log
					Select CAST(@party_Code as varchar(30)) as party_code,CAST(@segment as varchar(30)) as segment,'ALREADY DEACTIVATE',GETDATE() as updatedOn,'N' as Processed 

					--COMMIT TRAN 

					END
				END
			End
		 End
	
		 FETCH NEXT FROM cur_Deactive INTO @party_Code,@segment,@NewRemark,@updatedby

		 END        

	CLOSE cur_Deactive
	DEALLOCATE cur_Deactive




	print 'befor mail'

	set @Subject = 'Auto Deactivation confirmation Mailer'               
 
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
                                            Auto Deactivation confirmation Mailer.
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
                                            '',td=segment,
                                            '',td=ActDeact
                                            from mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Logtest with(nolock)
                                            where ProcessID=@ProcessID
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
   @recipients = 'Priyanka.Shrikant@angelbroking.com;gupta.ajaykumar@angelbroking.com;',
   --@recipients = 'Priyanka.Shrikant@angelbroking.com;',
    @body_format='HTML',                            
    @subject = @Subject,                            
    @body = @tableHTML,                           
    @profile_name ='MimansaTeam'

 print 'Status Update'
	update mimansa.CRM.dbo.Ekyc_ActivateDeactivateUserCode_process set ProcessingStatus='C',mailType='Success',isMailSend='Y',EmailSentOn=getdate() where  ProcessID=@ProcessID
		
End
Else
BEGIN
	Print 'No Records'

	   update mimansa.CRM.dbo.Ekyc_ActivateDeactivateUserCode_process set ProcessingStatus='C',mailType='NORECORDS',isMailSend='Y',EmailSentOn=getdate() where  ProcessID=@ProcessID
 

END
END TRY
BEGIN CATCH
	print 'catch'
   update mimansa.CRM.dbo.Ekyc_ActivateDeactivateUserCode_process set ProcessingStatus='F',mailType='Fail',isMailSend='Y',EmailSentOn=getdate() where  ProcessID=@ProcessID

    SELECT @ErrorFlag=ERROR_MESSAGE()
    print 'party code:'+@MainPartycode
	Print @ErrorFlag
    
      set @Subject = 'Auto Deactivation Process Failed'
	  SET @tableHTML =''+cast(@ErrorFlag as varchar(8000))+''
	  exec msdb.dbo.sp_send_dbmail   
     @recipients = 'Priyanka.Shrikant@angelbroking.com',
      @body_format='HTML',                            
      @subject = @Subject,                            
      @body = @tableHTML,                           
      @profile_name ='MimansaTeam'

	

END CATCH;
END

GO
