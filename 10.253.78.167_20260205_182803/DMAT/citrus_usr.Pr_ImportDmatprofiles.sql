-- Object: PROCEDURE citrus_usr.Pr_ImportDmatprofiles
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE Proc [citrus_usr].[Pr_ImportDmatprofiles]
as
begin
		Create table #profiles(brom_id bigint,Brom_desc varchar(100),Exchange varchar(10))
		-- Add server name in below query
		insert into #profiles
		select brom_id,Brom_desc,EXCSM_EXCH_CD 
		from Dmat.citrus_usr.brokerage_mstr,exch_seg_mstr,excsm_prod_mstr,product_mstr 
		where excsm_id = excpm_excsm_id 
		and brom_excpm_id = excpm_id
		and excpm_prom_id = prom_id
		and Prom_cd = '01'
		
		-- Add server name in above query
		begin tran
			delete b 
			from brokerage_mstr b,exch_seg_mstr,excsm_prod_mstr,product_mstr 
			where excsm_id = excpm_excsm_id 
			and brom_excpm_id = excpm_id
			and excpm_prom_id = prom_id
			and Prom_cd = '01'
			and EXCSM_EXCH_CD in ('CDSL','NSDL')


			insert into brokerage_mstr
			select brom_id,Brom_desc,excpm_id,'MIG',Getdate(),'MIG',Getdate(),1
			from #profiles,exch_seg_mstr,excsm_prod_mstr,product_mstr 
			where excsm_id = excpm_excsm_id 
			and excpm_prom_id = prom_id
			and Prom_cd = '01'
			and exchange = EXCSM_EXCH_CD
		commit tran

end

GO
