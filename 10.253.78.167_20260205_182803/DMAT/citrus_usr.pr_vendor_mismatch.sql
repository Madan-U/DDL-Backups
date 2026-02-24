-- Object: PROCEDURE citrus_usr.pr_vendor_mismatch
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec pr_vendor_mismatch ''

CREATE procedure [citrus_usr].[pr_vendor_mismatch] (@pa_out varchar(max) out)
as 
begin
set @pa_out = ''
	
	DECLARE @boid varchar(20),@slipnofr varchar(20),@slipnoto varchar(20)
				DECLARE @MyCursor CURSOR
				SET @MyCursor = CURSOR FAST_FORWARD
				FOR
				SELECT distinct VM_BOID,VM_SLIPNOFR,VM_SLIPNOTO
				FROM   VENDOR_MISMATCH where vm_deleted_ind=1
				OPEN @MyCursor
				FETCH NEXT FROM @MyCursor
				INTO @boid,@slipnofr,@slipnoto
				WHILE @@FETCH_STATUS = 0
				BEGIN					
					  
					  if not exists (SELECT distinct sliim_id FROM slip_issue_mstr WHERE CONVERT(NUMERIC,SLIIM_SLIP_NO_FR) = convert(numeric,@slipnofr)
								AND CONVERT(NUMERIC,SLIIM_SLIP_NO_TO) = convert(numeric,@slipnoto) and SLIIM_DPAM_ACCT_NO = @boid)
					  begin
							set @pa_out = @pa_out + @boid + '</td><td>' + @slipnofr + '</td><td>' + @slipnoto + '|*~|'
					  end
 
				FETCH NEXT FROM @MyCursor
				INTO @boid,@slipnofr,@slipnoto
				END
				CLOSE @MyCursor
				DEALLOCATE @MyCursor	

		select @pa_out result
end

GO
