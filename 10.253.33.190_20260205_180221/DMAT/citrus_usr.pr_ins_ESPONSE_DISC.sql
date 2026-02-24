-- Object: PROCEDURE citrus_usr.pr_ins_ESPONSE_DISC
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc pr_ins_ESPONSE_DISC
(
		 @Batch_No As int,
         @Record_Type As int,
         @line_Number As int,
         @Instruction_Type As int,
         @DIS_Instruction_Id As varchar(12),
         @Transaction_Type As int,
         @Acceptance_Rejection_Flag As varchar(1),
         @Filler1  As varchar(7),
         @DIS_Format_flag As varchar(1),
         @DIS_Slip_No_from As varchar(12),
         @DIS_Slip_No_to As varchar(12),
         @Filler2 As varchar(6),
         @DIS_Issuance_Date As datetime,
         @Error_code1 As varchar(6),
         @Error_code2 As varchar(6),
         @Error_code3 As varchar(6),
         @Filler3 As varchar(12)



)
as 
begin
		insert into TMP_DPMRESPONSE_detail values(
		 @Batch_No
        ,@Record_Type
        ,@line_Number
        ,@Instruction_Type
        ,@DIS_Instruction_Id
        ,@Transaction_Type
        ,@Acceptance_Rejection_Flag 
        ,@Filler1 
        ,@DIS_Format_flag
        ,@DIS_Slip_No_from
        ,@DIS_Slip_No_to
        ,@Filler2
        ,@DIS_Issuance_Date
        ,@Error_code1
        ,@Error_code2
        ,@Error_code3
        ,@Filler3)
end

GO
