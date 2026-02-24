-- Object: PROCEDURE dbo.C_FdBgHaircutCalSP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





CREATE proc C_FdBgHaircutCalSP
@Exchange Varchar(3),
@Segment Varchar(20),
@Party_Code varchar(10),
@Bank_Code Varchar(20),
@Cl_Type Varchar(4),
@EffDate varchar(11),
@Scrip_cd varchar(12),
@Series Varchar(3),
@Group_Cd varchar(20),
@Fd_Type varchar(1),
@Flag int
as

If @Flag = 1 
Begin
select haircut = isnull((select haircut from fdhaircut where party_code = @party_code and bank_code = @bank_code and 
			 Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) from fdhaircut 
			 where EffDate <= @EffDate + ' 23:59' and party_code = @party_code and bank_code = @bank_code AND 
			 Exchange = @Exchange and Segment = @Segment and Active = 1)),
			 isnull((select haircut from fdhaircut where party_code = @party_code and bank_code = '' and Fd_Type = @Fd_Type and Exchange = @Exchange 
				and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) from fdhaircut where EffDate <= @EffDate + ' 23:59' 
				and party_code = @party_code and bank_code = '' and Fd_Type = @Fd_Type AND Exchange = @Exchange and Segment = @Segment and Active = 1)),
				isnull((select haircut from fdhaircut where party_code = '' and bank_code = @bank_code and 
					Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) 
					from fdhaircut where EffDate <= @EffDate + ' 23:59' and party_code = '' and 
					bank_code = @bank_code AND Exchange = @Exchange and Segment = @Segment and Active = 1)),
 					Isnull((SELECT haircut from fdhaircut where party_code = '' and bank_code = '' and 
						Client_Type = @Cl_Type and Client_Type <> '' and Active = 1 and Exchange = @Exchange and Segment = @Segment and 
						EffDate = (Select max(Effdate) from fdhaircut where EffDate <= @EffDate + ' 23:59' and 
						party_code = '' and bank_code = '' and Client_Type = @Cl_Type and Client_Type <> '' AND 
						Exchange = @Exchange and Segment = @Segment and Active = 1)),
							isnull((select haircut from fdhaircut where party_code = '' and bank_code = '' and client_type = '' and
							Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) 
							from fdhaircut where EffDate <= @EffDate + ' 23:59' and party_code = '' and 
							bank_code = ''  and client_type = '' AND Exchange = @Exchange and Segment = @Segment and Active = 1)),0)
						)
					)
				)
			)
End

If @Flag = 2
Begin
select haircut = isnull((select haircut from bghaircut where party_code = @party_code and bank_code = @bank_code and 
			 Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) from bghaircut 
			 where EffDate <= @EffDate + ' 23:59' and party_code = @party_code and bank_code = @bank_code AND 
			 Exchange = @Exchange and Segment = @Segment and Active = 1)),
			 isnull((select haircut from bghaircut where party_code = @party_code and bank_code = '' and Exchange = @Exchange 
				and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) from bghaircut where EffDate <= @EffDate + ' 23:59' 
				and party_code = @party_code and bank_code = '' AND Exchange = @Exchange and Segment = @Segment and Active = 1)),
				isnull((select haircut from bghaircut where party_code = '' and bank_code = @bank_code and 
					Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) 
					from bghaircut where EffDate <= @EffDate + ' 23:59' and party_code = '' and 
					bank_code = @bank_code AND Exchange = @Exchange and Segment = @Segment and Active = 1)),
 					Isnull((SELECT haircut from bghaircut where party_code = '' and bank_code = '' and 
						Client_Type = @Cl_Type and Client_Type <> ''  and Exchange = @Exchange and Segment = @Segment 
						and Active = 1 and EffDate = (Select max(Effdate) from bghaircut where EffDate <= @EffDate + ' 23:59' and 
						party_code = '' and bank_code = '' and Client_Type = @Cl_Type and Client_Type <> '' AND 
						Exchange = @Exchange and Segment = @Segment and Active = 1)),
							isnull((select haircut from bghaircut where party_code = '' and bank_code = '' and client_type = '' 
							and Active = 1 and Exchange = @Exchange and Segment = @Segment and EffDate = (Select max(Effdate) 
							from bghaircut where EffDate <= @EffDate + ' 23:59' and party_code = '' and 
							bank_code = ''  and client_type = ''  AND Exchange = @Exchange and Segment = @Segment and Active = 1)),0)
						)
					)
				)
			)
End

/*Changes done on April 20 2002 Added series condition in third case.*/

If @Flag = 3
Begin
	select haircut = isnull((select haircut from securityhaircut where party_code = @party_code and Scrip_Cd = @Scrip_Cd and Series = @Series and 
			 Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) from securityhaircut 
			 where EffDate <= @EffDate + ' 23:59' and party_code = @party_code and Scrip_Cd = @Scrip_Cd and Series = @Series AND 
			 Exchange = @Exchange and Segment = @Segment and Active = 1)),
			 isnull((select haircut from securityhaircut where party_code = @party_code and Scrip_Cd = '' and Exchange = @Exchange 
				and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) from securityhaircut where EffDate <= @EffDate + ' 23:59' 
				and party_code = @party_code and Scrip_Cd = '' AND Exchange = @Exchange and Segment = @Segment and Active = 1)),
				isnull((select haircut from securityhaircut where party_code = '' and Scrip_Cd = @Scrip_Cd and Series = @Series and 
					Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) 
					from securityhaircut where EffDate <= @EffDate + ' 23:59' and party_code = '' and 
					Scrip_Cd = @Scrip_Cd and Series = @Series AND Exchange = @Exchange and Segment = @Segment and Active = 1)),
					Isnull((SELECT haircut from securityhaircut where party_code = '' and Scrip_Cd = '' and 
						Group_Cd = @Group_Cd and Group_Cd <> ''  and Exchange = @Exchange and Segment = @Segment 
						and Active = 1 and EffDate = (Select max(Effdate) from securityhaircut where EffDate <= @EffDate + ' 23:59' and 
						party_code = '' and Scrip_Cd = '' and Group_Cd = @Group_Cd and Group_Cd <> '' AND 
						Exchange = @Exchange and Segment = @Segment and Active = 1)),
	 					Isnull((SELECT haircut from securityhaircut where party_code = '' and Scrip_Cd = '' and 
							Client_Type = @Cl_Type and Client_Type <> ''  and Exchange = @Exchange and Segment = @Segment 
							and Active = 1 and EffDate = (Select max(Effdate) from securityhaircut where EffDate <= @EffDate + ' 23:59' and 
							party_code = '' and Scrip_Cd = '' and Client_Type = @Cl_Type and Client_Type <> '' AND 
							Exchange = @Exchange and Segment = @Segment and Active = 1)),
								isnull((select haircut from securityhaircut where party_code = '' and Scrip_Cd = '' and client_type = '' and Group_cd = ''
								and Active = 1 and Exchange = @Exchange and Segment = @Segment and EffDate = (Select max(Effdate) 
								from securityhaircut where EffDate <= @EffDate + ' 23:59' and party_code = '' and 
								Scrip_Cd = ''  and client_type = ''  and Group_cd = '' AND Exchange = @Exchange and Segment = @Segment and Active = 1)),0)
							)
						)
					)
				)
			)
end

GO
